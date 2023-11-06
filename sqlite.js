(function(){
    var api;

    // lot's of copying from htmx source. It should probably export some of this stuff as functions in internal API?
    var getParameters = function (elt) {
        var results = api.getInputValues(elt, 'post');
        var rawParameters = results.values;
        var expressionVars = api.getExpressionVars(elt);
        var allParameters = api.mergeObjects(rawParameters, expressionVars);
        var filteredParameters = api.filterValues(allParameters, elt);
        return filteredParameters;
    };

    // lot's of copying from htmx source. It should probably export some of this stuff as functions in internal API?
    var swapAndSettle = function(data, elt, responseInfo) {
        var target = api.getTarget(elt);
        if (target == null || target == api.DUMMY_ELT) {
            api.triggerErrorEvent(elt, 'htmx:targetError', {target: api.getAttributeValue(elt, "hx-target")});
            return;
        }

        var shouldSwap = data.length > 0;
        var beforeSwapDetails = {shouldSwap: shouldSwap, target: target, elt: elt};
        if (!api.triggerEvent(target, 'htmx:beforeSwap', beforeSwapDetails)) return;
        target = beforeSwapDetails.target;
        
        responseInfo.target = target;
        responseInfo.failed = false;
        responseInfo.successful = true;

        var serverResponse = JSON.stringify(data);
        if (beforeSwapDetails.shouldSwap) {
            api.withExtensions(elt, function (extension) {
                serverResponse = extension.transformResponse(serverResponse, undefined, elt);
            });

            var swapSpec = api.getSwapSpecification(elt, undefined);

            target.classList.add(htmx.config.swappingClass);

            var doSwap = function () {
                try {
                    var activeElt = document.activeElement;
                    var selectionInfo = {};
                    try {
                        selectionInfo = {
                            elt: activeElt,
                            start: activeElt ? activeElt.selectionStart : null,
                            end: activeElt ? activeElt.selectionEnd : null
                        };
                    } catch (e) {
                        // safari issue - see https://github.com/microsoft/playwright/issues/5894
                    }

                    var settleInfo = api.makeSettleInfo(target);
                    api.selectAndSwap(swapSpec.swapStyle, target, elt, serverResponse, settleInfo, undefined);

                    if (selectionInfo.elt &&
                        !api.bodyContains(selectionInfo.elt) &&
                        api.getRawAttribute(selectionInfo.elt, "id")) {
                        var newActiveElt = document.getElementById(api.getRawAttribute(selectionInfo.elt, "id"));
                        var focusOptions = { preventScroll: swapSpec.focusScroll !== undefined ? !swapSpec.focusScroll : !htmx.config.defaultFocusScroll };
                        if (newActiveElt) {
                            if (selectionInfo.start && newActiveElt.setSelectionRange) {
                                try {
                                    newActiveElt.setSelectionRange(selectionInfo.start, selectionInfo.end);
                                } catch (e) {
                                    // the setSelectionRange method is present on fields that don't support it, so just let this fail
                                }
                            }
                            newActiveElt.focus(focusOptions);
                        }
                    }

                    target.classList.remove(htmx.config.swappingClass);
                    settleInfo.elts.forEach(function (elt) {
                        if (elt.classList) {
                            elt.classList.add(htmx.config.settlingClass);
                        }
                        api.triggerEvent(elt, 'htmx:afterSwap', responseInfo);
                    });

                    var doSettle = function () {
                        settleInfo.tasks.forEach(function (task) {
                            task.call();
                        });
                        settleInfo.elts.forEach(function (elt) {
                            if (elt.classList) {
                                elt.classList.remove(htmx.config.settlingClass);
                            }
                            api.triggerEvent(elt, 'htmx:afterSettle', responseInfo);
                        });
                    }

                    if (swapSpec.settleDelay > 0) {
                        setTimeout(doSettle, swapSpec.settleDelay)
                    } else {
                        doSettle();
                    }
                } catch (e) {
                    api.triggerErrorEvent(elt, 'htmx:swapError', responseInfo);
                    throw e;
                }
            };

            var shouldTransition = htmx.config.globalViewTransitions
            if(swapSpec.hasOwnProperty('transition')){
                shouldTransition = swapSpec.transition;
            }

            if(shouldTransition &&
                api.triggerEvent(elt, 'htmx:beforeTransition', responseInfo) &&
                typeof Promise !== "undefined" && document.startViewTransition){
                var settlePromise = new Promise(function (_resolve, _reject) {
                    settleResolve = _resolve;
                    settleReject = _reject;
                });
                var innerDoSwap = doSwap;
                doSwap = function() {
                    document.startViewTransition(function () {
                        innerDoSwap();
                        return settlePromise;
                    });
                }
            }


            if (swapSpec.swapDelay > 0) {
                setTimeout(doSwap, swapSpec.swapDelay)
            } else {
                doSwap();
            }
        }
    };

    htmx.defineExtension('sqlite', {
        init: function (internalAPI) {
            api = internalAPI;
        },
        onEvent: function (name, evt) {
            if (name === "htmx:afterProcessNode") {
                let elt = evt.detail.elt;

                if (elt.hasAttribute('hx-sql')) {
                    var triggerSpecs = api.getTriggerSpecs(elt);
                    triggerSpecs.forEach(function(triggerSpec) {
                        var nodeData = api.getInternalData(elt);
                        api.addTriggerHandler(elt, triggerSpec, nodeData, function (elt, evt) {
                            if (htmx.closest(elt, htmx.config.disableSelector)) {
                                cleanUpElement(elt);
                                return;
                            }
                            
                            var binds = getParameters(elt);
                            Object.keys(binds).forEach(k => {
                                binds['$' + k] = binds[k];
                                delete binds[k];
                            });

                            var sql = elt.getAttribute('hx-sql');
                            if (sql == "") {
                                sql = elt.value;
                            }
                            
                            let db = htmx.closest(elt, '[hx-sqlite]').getAttribute('hx-sqlite');
                            createSQLiteHTTPPool({ workers: 1 })
                                .then(pool => pool.open(db).then(() => pool))
                                .then(pool => pool.exec(sql, binds, { rowMode: "object" }).finally(() => pool.close()))
                                .then(data => data.map(x => x.row))
                                .then(data => {
                                    var responseInfo = { elt: elt, xhr: { response: data }, target: api.getTarget(elt) };
                                    if (!api.triggerEvent(elt, 'htmx:beforeOnLoad', responseInfo)) return;

                                    swapAndSettle(data, elt, responseInfo);
                                });
                        })
                    });
                }
            }
        }
    });

})();