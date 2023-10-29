  let initTemplates = () => {
    let interval = readInterval();
    let q = document.getElementById('query');
    q.value = q.value.replace("{start}", interval.start.toISOString()).replace("{end}", interval.end.toISOString());

    document.body.querySelectorAll('option').forEach(x => {
      if (x.getAttribute('value') == 1) {
        x.setAttribute('value', "SELECT * FROM spot WHERE instant BETWEEN strftime('%s', '" + dateFns.addMonths(new Date(), -1).toISOString() + "') AND strftime('%s', '" + dateFns.addHours(new Date(), 24).toISOString() + "')");
      } else if (x.getAttribute('value') == 2) {
        x.setAttribute('value', "SELECT * FROM spot WHERE instant BETWEEN strftime('%s', '" + dateFns.addMonths(new Date(), -3).toISOString() + "') AND strftime('%s', '" + dateFns.addHours(new Date(), 24).toISOString() + "')");
      } else if (x.getAttribute('value') == 3) {
        x.setAttribute('value', "SELECT * FROM spot WHERE instant BETWEEN strftime('%s', '" + dateFns.addMonths(new Date(), -6).toISOString() + "') AND strftime('%s', '" + dateFns.addHours(new Date(), 24).toISOString() + "')");
      } else if (x.getAttribute('value') == 4) {
        x.setAttribute('value', "SELECT * FROM spot WHERE instant BETWEEN strftime('%s', '" + dateFns.addYears(new Date(), -1).toISOString() + "') AND strftime('%s', '" + dateFns.addHours(new Date(), 24).toISOString() + "')");
      } else if (x.getAttribute('value') == 5) {
        x.setAttribute('value', "SELECT * FROM spot");
      } else if (x.getAttribute('value') == 6) {
        x.setAttribute('value', "SELECT AVG(centsPerKWh) centsPerKWh, instant FROM spot group by strftime('%Y-%m-%d', instant, 'unixepoch')");
      } else if (x.getAttribute('value') == 7) {
        x.setAttribute('value', "SELECT AVG(centsPerKWh) centsPerKWh, instant FROM spot group by strftime('%Y-%W', instant, 'unixepoch')");
      } else if (x.getAttribute('value') == 8) {
        x.setAttribute('value', "SELECT AVG(centsPerKWh) centsPerKWh, instant FROM spot group by strftime('%Y-%m', instant, 'unixepoch')");
      } else if (x.getAttribute('value') == 9) {
        x.setAttribute('value', "SELECT MIN(centsPerKWh) centsPerKWh, instant FROM spot group by strftime('%Y-%m-%d', instant, 'unixepoch')");
      } else if (x.getAttribute('value') == 10) {
        x.setAttribute('value', "SELECT MIN(centsPerKWh) centsPerKWh, instant FROM spot group by strftime('%Y-%W', instant, 'unixepoch')");
      } else if (x.getAttribute('value') == 11) {
        x.setAttribute('value', "SELECT MIN(centsPerKWh) centsPerKWh, instant FROM spot group by strftime('%Y-%m', instant, 'unixepoch')");
      } else if (x.getAttribute('value') == 12) {
        x.setAttribute('value', "SELECT MAX(centsPerKWh) centsPerKWh, instant FROM spot group by strftime('%Y-%m-%d', instant, 'unixepoch')");
      } else if (x.getAttribute('value') == 13) {
        x.setAttribute('value', "SELECT MAX(centsPerKWh) centsPerKWh, instant FROM spot group by strftime('%Y-%W', instant, 'unixepoch')");
      } else if (x.getAttribute('value') == 14) {
        x.setAttribute('value', "SELECT MAX(centsPerKWh) centsPerKWh, instant FROM spot group by strftime('%Y-%m', instant, 'unixepoch')");
      }
    });
    document.getElementById('template').onchange = function() {
      document.getElementById('query').value = this.value;
      document.getElementById('query').dispatchEvent(new Event('change'));
    };
  };
  
  let initTooltips = () => {
    document.body.querySelectorAll('[title]').forEach(x => {
      x.setAttribute('title', x.getAttribute('title').replaceAll('{{today}}', new Date().toISOString().slice(0, 10)));
    });

    tippy(document.body.querySelectorAll('[title]'), {
      allowHTML: true,
      interactive: true,
      theme: 'light',
      content(reference) {
          const title = reference.getAttribute('title');
          reference.removeAttribute('title');
          return title;
      }
  });
  };
  
  let readInterval = () => {
    let initialInterval = window.location.hash ? window.location.hash.substring(1).split('/').map(x => new Date(x))
                                               : [dateFns.addHours(new Date(), -30*24), dateFns.addHours(new Date(), 2*24)];
    return {start: initialInterval[0], end: initialInterval[1]};
  };

  let getData = async (name, queryF, cb) => {
    console.log("Querying " + name);

    const pool = await sqliteWasmHttp.createSQLiteHTTPPool({ workers: 1, backendType: "sync" });
    await pool.open('/spot.db');
    const data = await pool.exec(queryF(), {});

    if (data == "") {
      console.log("Got empty data for " + name);
    } else {
      console.log("Got " + data.length + " rows for " + name);
    }

    cb(data.map(x => {
      let ret = {};
      x.columnNames.forEach((c,i) => {
        ret[c] = x.row[i];
        if (c == 'instant') {
          ret[c] = ret[c]*1000;
        }
      });
      return ret;
    }).sort((a,b) => a.instant - b.instant));

    await pool.close();
  };

  let initChart = () => {
    let root = am5.Root.new("chart"); 
    root.setThemes([
      am5themes_Animated.new(root)
    ]);
    root.numberFormatter.set("numberFormat", "#.00");

    let chart = root.container.children.push( 
      am5xy.XYChart.new(root, {
        panX: true,
        panY: false,
        wheelY: "zoomX",
        pinchZoomX: true,
        layout: root.verticalLayout,
        scrollbarX: am5xy.XYChartScrollbar.new(root, {
          orientation: 'horizontal'
          })
      })
    );

    let yAxis = chart.yAxes.push(
      am5xy.ValueAxis.new(root, {
        autoZoom: false,
        calculateTotals: true,
        renderer: am5xy.AxisRendererY.new(root, {
          minGridDistance: 20
        })
      })
    );
    yAxis.get("renderer").labels.template.setAll({
      fontSize: "0.75em"
    });

    let xAxis = chart.xAxes.push(
      am5xy.DateAxis.new(root, {
        baseInterval: { timeUnit: "hour", count: 1 },
        renderer: am5xy.AxisRendererX.new(root, {
          minGridDistance: 50
        })
      })
    );
    xAxis.get("renderer").labels.template.setAll({
      fontSize: "0.75em",
      location: 0,
      multiLocation: 0
    });

    let mkSeries = (name) => {
      let ret = am5xy.ColumnSeries.new(root, { 
        name: name,
        xAxis: xAxis,
        yAxis: yAxis,
        valueYField: "centsPerKWh", 
        valueXField: "instant",
        stacked: true,
        calculateTotals: true,
        maskBullets: false,
        minBulletDistance: 25
      });
      ret.columns.template.setAll({
        fillOpacity: 0.5,
        cornerRadiusTL: 2,
        cornerRadiusTR: 2,
        tooltipText: "{centsPerKWh} c/kWh",
        tooltipY: am5.percent(0),
        width: am5.percent(90)
      });
      ret.columns.template.states.create("hover", {
        fillOpacity: 1
      });
      chart.series.push(ret);

      ret.columns.template.adapters.add("tooltipText", (text, target) => {
        let instant = target.dataItem.dataContext.instant;
        return dateFnsTz.formatInTimeZone(new Date(instant), 'Europe/Helsinki', "yyyy-MM-dd HH:mm") + " - " + dateFnsTz.formatInTimeZone(dateFns.addHours(new Date(instant), 1), 'Europe/Helsinki', "HH:mm") + "\n" + text;
      });
      
      return ret;
    };
    let series = mkSeries("Spot");
    let taxSeries = mkSeries("Tax 24%");
    let totals = mkSeries("totals");
    
    totals.bullets.push(function () {
      return am5.Bullet.new(root, {
        locationY: 1,
        sprite: am5.Label.new(root, {
          text: "{valueYSum}",
          scale: 0.6,
          centerY: am5.p100,
          centerX: am5.p50,
          populateText: true
        })
      });
    });
    
    series.set("fill", am5.color("#ff8282"));
    series.set("heatRules", [{
      target: series.columns.template,
      dataField: "valueY",
      customFunction: (sprite, min, max, value) => {
        if (value < 0) {
          sprite.set("fill", am5.color("#00ff00"));
        } else {
          sprite.set("fill", am5.color("#ff0000"));
        }
      }
    }]);
    series.columns.template.adapters.add('opacity', (_,target) => 0.3 + Math.abs(2*target.dataItem.dataContext.centsPerKWh / 40));

    series.events.once("datavalidated", () => {
      xAxis.zoomToDates(dateFns.addHours(new Date(), -24), new Date(Math.max(...series.data.values.map(x => x.instant))));
    });

    let legend = chart.plotContainer.children.push(am5.Legend.new(root, {
      layout: root.verticalLayout
    }));
    legend.data.setAll([series, taxSeries]);

    let initRanges = (interval, showWeekends, showNights) => {
      let range = xAxis.makeDataItem({
        value:    new Date().getTime() - 1000*60*1,
        endValue: new Date().getTime() + 1000*60*1
      });
      setInterval(() => {
        let now = new Date();
        range.setAll({
          value:    now.getTime() - 1000*60*1,
          endValue: now.getTime() + 1000*60*1
        });
      }, 60000);
      let axisFill = xAxis.createAxisRange(range).get("axisFill");
      axisFill.setAll({
          fill:        am5.color('#85c7fc'),
          stroke:      am5.color('#85c7fc'),
          fillOpacity: 1,
          strokeWidth: 5,
          visible: true,
          tooltip: am5.Tooltip.new(root, {}),
          tooltipY: 0,
          showTooltipOn: "always"
      });
      axisFill.get("tooltip").adapters.add("bounds", () => chart.plotContainer.globalBounds());
    
      axisFill.adapters.add("tooltipText", (text, target) => {
        let instant = target.dataItem.get('value');
        let price = () => series.data.values.findLast(x => x.instant <= instant).centsPerKWh;
        return dateFnsTz.formatInTimeZone(new Date(instant), 'Europe/Helsinki', "yyyy-MM-dd HH:mm") +
          (series.data.values.length == 0 ? '' : "\n" + (price() > 0 ? price().toFixed(2) + " + " + (price()*0.24).toFixed(2) + " = " + (price()*1.24).toFixed(2) : price()) + " c/kwh");
      });

      if (showWeekends) {
        dateFns.eachWeekendOfInterval(interval).forEach(x => {
          let weekend = xAxis.createAxisRange(xAxis.makeDataItem({
              value:    x.getTime(),
              endValue: dateFns.addHours(x, 24).getTime(),
          }));
          weekend.set("userData", { weekend: true });
          weekend.get("axisFill").setAll({
              visible: true,
              fillOpacity: 0.5,
              fillGradient: am5.LinearGradient.new(root, {
                stops: [{
                  color: am5.color("#000000")
                }, {
                  color: am5.color("#ffffff"),
                  offset: 0.30
                }, {
                  color: am5.color("#ffffff"),
                  offset: 0.95
                }, {
                  color: am5.color("#000000")
                }]
              })
          });
        });
      }

      if (showNights) {
        dateFns.eachDayOfInterval(interval).forEach(x => {
          let night = xAxis.createAxisRange(xAxis.makeDataItem({
              value:    dateFnsTz.zonedTimeToUtc(new Date(dateFnsTz.formatInTimeZone(x, 'Europe/Helsinki', 'yyyy-MM-dd') + 'T22:00:00'), 'Europe/Helsinki').getTime(),
              endValue: dateFnsTz.zonedTimeToUtc(new Date(dateFnsTz.formatInTimeZone(dateFns.addDays(x, 1), 'Europe/Helsinki', 'yyyy-MM-dd') + 'T07:00:00'), 'Europe/Helsinki').getTime(),
          }));
          night.set("userData", { night: true });
          night.get("axisFill").setAll({
              fill:        am5.color('#0000ff'),
              fillOpacity: 0.05,
              visible: true
          });
        });
      }
    };

    let showNights = legend.children.push(am5.Button.new(root, {
      active: true,
      width: 20,
      height: 20,
      dx: 4,
      marginTop: 6,
      fill: am5.color('#0000ff'),
      tooltipText: "Show/hide nights"
    }));
    showNights.get('background').setAll({
      fill: am5.color('#0000ff')
    });
    let showWeekends = legend.children.push(am5.Button.new(root, {
      active: true,
      width: 20,
      height: 20,
      dx: 4,
      marginTop: 6,
      fill: am5.color('#000000'),
      tooltipText: "Show/hide weekends"
    }));
    showWeekends.get('background').setAll({
      fill: am5.color('#000000')
    });

    let init = () => {
      let baseInterval = [...document.querySelectorAll('#template option')].find(x => x.getAttribute('value') == x.parentElement.value).getAttribute('data-baseInterval');
      xAxis.set('baseInterval', { timeUnit: baseInterval, count: 1 });

      getData("spot", () => document.getElementById('query').value, data => {
        series.data.setAll(data);
        taxSeries.data.setAll(data.map(x => {
          return {...x, centsPerKWh: x.centsPerKWh > 0 ? x.centsPerKWh*0.24 : 0};
        }));
        totals.data.setAll(data.map(x => {
          return {...x, centsPerKWh: 0};
        }));
        let interval = {start: Math.min(...data.map(x => x.instant)), end: Math.max(...data.map(x => x.instant))};

        xAxis.axisRanges.clear();
        initRanges(interval, showWeekends.get('active'), showNights.get('active'));
      });
    };

    showNights.events.on("click", () => {
      if (showNights.get('active')) {
        xAxis.axisRanges.values.filter(x => x.get('userData').night).forEach(x => xAxis.axisRanges.removeValue(x));
      } else {
        init();
      }
      showNights.set('active', !showNights.get('active'));
    });

    showWeekends.events.on("click", () => {
      if (showWeekends.get('active')) {
        xAxis.axisRanges.values.filter(x => x.get('userData').weekend).forEach(x => xAxis.axisRanges.removeValue(x));
      } else {
        init();
      }
      showWeekends.set('active', !showWeekends.get('active'));
    });

    init();
    document.getElementById('query').addEventListener('change', init);
  };