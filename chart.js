let mkRoot = () => {
  let root = am5.Root.new("chart"); 
  root.setThemes([
    am5themes_Animated.new(root)
  ]);
  root.numberFormatter.set("numberFormat", "#.00");
  return root;
};

let mkChart = (root, dateFns, dateFnsTz) => {
  let chart = root.container.children.push(
    am5xy.XYChart.new(root, {
      panX:       true,
      panY:       false,
      wheelY:     "zoomX",
      pinchZoomX: true,
      layout:     root.verticalLayout,
      paddingTop: 0,
      scrollbarX: am5xy.XYChartScrollbar.new(root, {
        orientation: 'horizontal'
      }),
      maxTooltipDistance: -1,
      visible: false
    })
  );

  let tooltip = am5.Tooltip.new(root, {
    pointerOrientation: "down",
    dy: -50
  });
  tooltip.get("background").setAll({
    stroke: am5.color('#000000'),
    strokeOpacity: 0.2,
    fill: am5.color('#ffffff'),
    fillOpacity: 0.8
  });
  tooltip.label.adapters.add("text", function(text) {
    let texts = [];
    chart.series.each(function(series, i) {
      var tooltipDataItem = series.get("tooltipDataItem");
      if (tooltipDataItem) {
        let name = series.get("name");
        if (i == 0) {
          texts.push("[fontFamily: monospace fontSize: 9px verticalAlign: super]" +
                     dateFnsTz.formatInTimeZone(new Date(tooltipDataItem.get("valueX")), 'Europe/Helsinki', "yyyy-MM-dd HH:mm") +
                     " - " +
                     dateFnsTz.formatInTimeZone(dateFns.addHours(new Date(tooltipDataItem.get("valueX")), 1), 'Europe/Helsinki', "HH:mm") +
                    "[fontFamily: monospace fontSize: 9px]");
        }
        if (series.isVisible()) {
          let value = tooltipDataItem.get("valueY" + (name == 'total' ? "Sum" : "")).toFixed(2);
          texts.push((name == 'total' ? "[/][fontFamily: monospace fontSize: 9px verticalAlign: sub]" : "") +
                    name + " ".repeat(19-name.length) + "" + (value < 10 ? "  " : value < 100 ? " " : "") + value + " c/kWh");
        }
      }
    });
    return texts.join("\n") + "[/]";
  });
  chart.plotContainer.setAll({
    tooltip: tooltip,
    tooltipText: " ",
    tooltipPosition: "pointer"
  });

  let cursor = chart.set("cursor", am5xy.XYCursor.new(root, {}));
  cursor.lineX.set("visible", false);
  cursor.lineY.set("visible", false);
  
  return chart;
}

let mkYAxis = (root, chart) => {
  let yAxis = chart.yAxes.push(
    am5xy.ValueAxis.new(root, {
      autoZoom:        false,
      calculateTotals: true,
      renderer:        am5xy.AxisRendererY.new(root, {
        minGridDistance: 20
      })
    })
  );
  yAxis.get("renderer").labels.template.setAll({
    fontSize: "0.75em"
  });
  return yAxis;
};

let mkXAxis = (root, chart) => {
  let xAxis = chart.xAxes.push(
    am5xy.DateAxis.new(root, {
      baseInterval: { timeUnit: "hour", count: 1 },
      renderer:     am5xy.AxisRendererX.new(root, {
        minGridDistance: 50
      })
    })
  );
  xAxis.get("renderer").labels.template.setAll({
    fontSize:      "0.75em",
    location:      0,
    multiLocation: 0
  });
  return xAxis;
};

let mkSeriesConstructor = (dateFns, dateFnsTz, root, chart, xAxis, yAxis) => (name, store) => {
  let ret = am5xy.ColumnSeries.new(root, { 
    name:              name,
    stroke:            am5.color("#cfe2f3"),
    xAxis:             xAxis,
    yAxis:             yAxis,
    valueYField:       "centsPerKWh",
    valueXField:       "instant",
    stacked:           true,
    stackToNegative:   false,
    calculateTotals:   true,
    maskBullets:       false,
    minBulletDistance: 15,
  });
  ret.columns.template.setAll({
    fillOpacity:    0.5,
    tooltip:        am5.Tooltip.new(root, {
      pointerOrientation: 'up',
      dy: 35
    }),
    tooltipText:    "[fontFamily: monospace fontSize: 9px]" + name + ": {centsPerKWh} c/kWh",
    width:          am5.percent(90)
  });
  ret.columns.template.states.create("hover", {
    fillOpacity: 1
  });
  chart.series.push(ret);

  if (store) {
    ret.on("visible", visible => {
      store.checked = visible;
      store.dispatchEvent(new CustomEvent("change"));
    });
  }
  
  return ret;
};

let mkButton = (root, legend, text, color, active) => {
  let ret = legend.children.push(am5.Button.new(root, {
    active:      active,
    width:       20,
    height:      20,
    dx:          4,
    marginTop:   6,
    fill:        am5.color(color),
    label:       am5.Label.new(root, {
      text: text,
      fill: am5.color(color),
      paddingLeft: 14,
      dy: -15
    })
  }));
  ret.get('background').setAll({
    fill: am5.color(color),
    cornerRadiusBL: 5,
    cornerRadiusBR: 5,
    cornerRadiusTL: 5,
    cornerRadiusTR: 5
  });
  return ret;
};

let mkCurrentTimeRange = (dateFns, dateFnsTz, root, chart, xAxis) => data => {
  let now = new Date();
  let currentTime = xAxis.makeDataItem({
    value:    dateFns.addMinutes(now, -1).getTime(),
    endValue: dateFns.addMinutes(now, 1).getTime()
  });

  let axisFill = xAxis.createAxisRange(currentTime).get("axisFill");
  axisFill.setAll({
      fill:          am5.color('#85c7fc'),
      stroke:        am5.color('#85c7fc'),
      fillOpacity:   1,
      strokeWidth:   5,
      visible:       true,
      tooltip:       am5.Tooltip.new(root, {}),
      tooltipY:      0,
      showTooltipOn: "always"
  });
  return currentTime;
};

let mkWeekendRanges = (dateFns, root, xAxis) => interval => {
  dateFns.eachWeekendOfInterval(interval).forEach(x => {
    let weekend = xAxis.createAxisRange(xAxis.makeDataItem({
      value:    x.getTime(),
      endValue: dateFns.addHours(x, 24).getTime()
    }));
    weekend.set("userData", { weekend: true });
    weekend.get("axisFill").setAll({
        visible:      true,
        fillOpacity:  0.5,
        fillGradient: am5.LinearGradient.new(root, {
          stops: [{
            color: am5.color("#000000")
          }, {
            color: am5.color("#ffffff"),
            offset: 0.30
          }, {
            color: am5.color("#ffffff")
          }]
        })
    });
  });
};

let mkNightRanges = (dateFns, dateFnsTz, xAxis, startTime, endTime) => interval => {
  if (startTime && endTime) {
    dateFns.eachDayOfInterval(interval).forEach(x => {
      let night = xAxis.createAxisRange(xAxis.makeDataItem({
        value:    dateFnsTz.zonedTimeToUtc(new Date(dateFnsTz.formatInTimeZone(x,                     'Europe/Helsinki', 'yyyy-MM-dd') + 'T' + startTime + ':00'), 'Europe/Helsinki').getTime(),
        endValue: dateFnsTz.zonedTimeToUtc(new Date(dateFnsTz.formatInTimeZone(dateFns.addDays(x, 1), 'Europe/Helsinki', 'yyyy-MM-dd') + 'T' + endTime + ':00'), 'Europe/Helsinki').getTime(),
      }));
      night.set("userData", { night: true });
      night.get("axisFill").setAll({
          fill:        am5.color('#0000ff'),
          fillOpacity: 0.03,
          visible:     true
      });
    });
  }
};

let findVAT = (data, row) => data.find(y => y.start.getTime() <= row.instant && y.end.getTime() > row.instant).percent / 100;
let findPrice = (data, row) => data.find(y => y.start.getTime() <= row.instant && y.end.getTime() > row.instant).centsPerKWh;

let parseMinutes = duration => duration.split(':').map(x => parseInt(x)).reduce((a,b) => a*60 + b);

let initData = (dateFns, dateFnsTz, mainSeries, spotVATSeries, transferSeries, transferVATSeries, electricityTaxSeries, electricityTaxVATSeries, totals, spotVAT, transferVAT, electricityTax) => (data, dayPrice, nightPrice, nightStart, nightEnd) => {
  data = data.sort((a,b) => a.instant - b.instant);
  
  mainSeries.data.setAll(data);

  spotVATSeries.data.setAll(data.map(x => {
    let currentVAT = findVAT(spotVAT, x);
    return {...x, centsPerKWh: x.centsPerKWh > 0 ? x.centsPerKWh*currentVAT : 0};
  }));

  electricityTaxSeries.data.setAll(data.map(x => {
    let currentVAT = findVAT(transferVAT, x);
    let currentElectricityTax = findPrice(electricityTax, x);
    let currentElectricityTaxExcludingVAT = currentElectricityTax/(1 + currentVAT);
    return {...x, centsPerKWh: currentElectricityTaxExcludingVAT};
  }));

  electricityTaxVATSeries.data.setAll(data.map(x => {
    let currentVAT = findVAT(transferVAT, x);
    let currentElectricityTax = findPrice(electricityTax, x);
    let currentElectricityTaxExcludingVAT = currentElectricityTax/(1 + currentVAT);
    return {...x, centsPerKWh: currentElectricityTaxExcludingVAT * currentVAT};
  }));

  let nightStartMinutes = parseMinutes(nightStart);
  let nightEndMinutes   = parseMinutes(nightEnd);
  transferSeries.data.setAll(data.map(x => {
    let currentVAT = findVAT(transferVAT, x);
    var price;
    if (nightPrice && nightStart && nightEnd) {
      let minutes = dateFns.getHours(new Date(x.instant)) * 60 +
                    dateFns.getMinutes(new Date(x.instant));
      price = (minutes >= nightStartMinutes || minutes < nightEndMinutes ? nightPrice : dayPrice);
    } else {
      price = dayPrice;
    }
    let priceExludingVAT = price/(1 + currentVAT);
    return {...x, centsPerKWh: priceExludingVAT};
  }));

  transferVATSeries.data.setAll(data.map(x => {
    let currentVAT = findVAT(transferVAT, x);
    var price;
    if (nightPrice && nightStart && nightEnd) {
      let minutes = dateFns.getHours(new Date(x.instant)) * 60 +
                    dateFns.getMinutes(new Date(x.instant));
      price = (minutes >= nightStartMinutes || minutes < nightEndMinutes ? nightPrice : dayPrice);
    } else {
      price = dayPrice;
    }
    let priceExludingVAT = price/(1 + currentVAT);
    return {...x, centsPerKWh: priceExludingVAT * currentVAT};
  }));

  totals.data.setAll(data.map(x => {
    return {...x, centsPerKWh: 0};
  }));
};

let mkRangeInitializer = (dateFns, dateFnsTz, root, chart, xAxis, showWeekendsF, showNightsF) => (data, includeNightsAndWeekends, nightStart, nightEnd) => {
  xAxis.axisRanges.clear();

  let currentTime = mkCurrentTimeRange(dateFns, dateFnsTz, root, chart, xAxis)(data);
  setInterval(() => {
    let now = new Date();
    currentTime.setAll({
      value:    now.getTime() - 1000*60*1,
      endValue: now.getTime() + 1000*60*1
    });
  }, 60000);

  if (data.length > 0) {
    let interval = {
      start: Math.min(...data.map(x => x.instant)),
      end:   Math.max(...data.map(x => x.instant))
    };

    if (includeNightsAndWeekends && showWeekendsF()) {
      mkWeekendRanges(dateFns, root, xAxis)(interval);
    }

    if (includeNightsAndWeekends && showNightsF()) {
      mkNightRanges(dateFns, dateFnsTz, xAxis, nightStart, nightEnd)(interval);
    }
  }
};

let initSpotSeries = (dateFns, xAxis, series) => {
  series.setAll({
    fill:      am5.color("#ff8282"),
    heatRules: [{
      target:         series.columns.template,
      dataField:      "valueY",
      customFunction: (sprite, min, max, value) => {
        if (value < 0) {
          sprite.set("fill", am5.color("#00ff00"));
        } else {
          sprite.set("fill", am5.color("#ff0000"));
        }
      }
      }]
  });

  series.columns.template.adapters.add('opacity', (_,target) =>
    0.3 + Math.abs(2*target.dataItem.dataContext.centsPerKWh / 40));
  
  series.events.once("datavalidated", ev =>
    xAxis.zoomToDates(dateFns.addHours(new Date(), -16),
                      new Date(Math.max(...ev.target.data.values.map(x => x.instant)))));
    series.chart.set('visible', true);
};

let initTotals = (root, totals) => {
  totals.bullets.push(function () {
    return am5.Bullet.new(root, {
      locationY: 1,
      sprite:    am5.Label.new(root, {
        text:         "{valueYSum}",
        scale:        0.5,
        centerY:      am5.p100,
        centerX:      am5.p50,
        populateText: true,
        numberFormatter: am5.NumberFormatter.new(root, {
          numberFormat: '#.0'
        })
      })
    });
  });
}

let mkLegend = (root, chart) =>
  chart.plotContainer.children.push(am5.Legend.new(root, {
    layout: root.verticalLayout
  }));

let initChart = (dateFns, dateFnsTz, dayPrice, nightPrice, nightStart, nightEnd, spotVisible, VATVisible, transferVisible, electricityTaxVisible, nightVisible, weekendVisible, spotVAT, transferVAT, electricityTax) => {
  let root = mkRoot();
  let chart = mkChart(root, dateFns, dateFnsTz);
  let yAxis = mkYAxis(root, chart);
  let xAxis = mkXAxis(root, chart);

  let mkSeries = mkSeriesConstructor(dateFns, dateFnsTz, root, chart, xAxis, yAxis);
  let spotSeries              = mkSeries("Spot", spotVisible);
  let spotVATSeries           = mkSeries("Spot VAT", VATVisible);
  let transferSeries          = mkSeries("Transfer", transferVisible);
  let transferVATSeries       = mkSeries("Transfer VAT", VATVisible);
  let electricityTaxSeries    = mkSeries("Electricity tax", electricityTaxVisible);
  let electricityTaxVATSeries = mkSeries("Electricity tax VAT", VATVisible);
  let totals                  = mkSeries("total");
  
  initSpotSeries(dateFns, xAxis, spotSeries);
  
  transferSeries.setAll({
    fill: am5.color("#cfe2f3")
  });
  transferSeries.columns.template.setAll({
    fillOpacity: 0.4
  });

  electricityTaxSeries.setAll({
    fill: am5.color("#c0e0ba")
  });
  electricityTaxSeries.columns.template.setAll({
    fillOpacity: 0.4
  });

  spotVATSeries.set('fill', am5.Color.lighten(spotSeries.get('fill'), 0.6));
  transferVATSeries.set('fill', am5.Color.lighten(transferSeries.get('fill'), 0.6));
  electricityTaxVATSeries.set('fill', am5.Color.lighten(electricityTaxSeries.get('fill'), 0.6));

  initTotals(root, totals);

  if (!spotVisible.checked) {
    spotSeries.hide();
  }
  if (!VATVisible.checked) {
    spotVATSeries.hide();
    transferVATSeries.hide();
    electricityTaxVATSeries.hide();
  }
  if (!transferVisible.checked) {
    transferSeries.hide();
  }

  let VATSeries = am5xy.ColumnSeries.new(root, { 
    name:             'VATs',
    valueYField:       "centsPerKWh",
    valueXField:       "instant",
    xAxis:             xAxis,
    yAxis:             yAxis,
    stacked:           true
  });

  spotSeries.on("visible", visible => {
    if (visible) {
      if (VATSeries.isVisible()) {
        spotVATSeries.show();
      }
    } else {
      spotVATSeries.hide();
    }
  });
  transferSeries.on("visible", visible => {
    if (visible) {
      if (VATSeries.isVisible()) {
        transferVATSeries.show();
      }
    } else {
      transferVATSeries.hide();
    }
  });
  electricityTaxSeries.on("visible", visible => {
    if (visible) {
      if (VATSeries.isVisible()) {
        electricityTaxVATSeries.show();
      }
    } else {
      electricityTaxVATSeries.hide();
    }
  });

  VATSeries.on("visible", visible => {
    if (visible) {
      if (spotSeries.isVisible()) {
        spotVATSeries.show();
      }
      if (transferSeries.isVisible()) {
        transferVATSeries.show();
      }
      if (electricityTaxSeries.isVisible()) {
        electricityTaxVATSeries.show();
      }
    } else {
      spotVATSeries.hide();
      transferVATSeries.hide();
      electricityTaxVATSeries.hide();
    }
  });
  chart.series.push(VATSeries);

  let legend = mkLegend(root, chart);
  legend.data.setAll([spotSeries, transferSeries, electricityTaxSeries, VATSeries]);

  let showNightsButton = mkButton(root, legend, "Nights", '#0000ff', nightVisible.checked);
  let showWeekendsButton = mkButton(root, legend, "Weekends", '#000000', weekendVisible.checked);

  let initRanges = mkRangeInitializer(dateFns, dateFnsTz, root, chart, xAxis, () => showWeekendsButton.get('active'), () => showNightsButton.get('active'));

  showNightsButton.events.on("click", ev => {
    ev.target.set('active', !ev.target.get('active'));
    nightVisible.checked = ev.target.get('active');
    nightVisible.dispatchEvent(new CustomEvent("change"));
    initRanges(spotSeries.data.values, true, nightStart.value || '22:00', nightEnd.value || '07:00');
  });

  showWeekendsButton.events.on("click", ev => {
    ev.target.set('active', !ev.target.get('active'));
    weekendVisible.checked = ev.target.get('active');
    weekendVisible.dispatchEvent(new CustomEvent("change"));
    initRanges(spotSeries.data.values, true, nightStart.value || '22:00', nightEnd.value || '07:00');
  });

  return (data, baseInterval) => {
    window.setTimeout(() => { // execute in main thread
      if (baseInterval) {
        xAxis.set('baseInterval', { timeUnit: baseInterval, count: 1 });
      }
      initData(dateFns, dateFnsTz, spotSeries, spotVATSeries, transferSeries, transferVATSeries, electricityTaxSeries, electricityTaxVATSeries, totals, spotVAT(), transferVAT(), electricityTax())(data, parseFloat(dayPrice.value), parseFloat(nightPrice.value), nightStart.value, nightEnd.value);
      initRanges(data, baseInterval == 'hour', nightStart.value || '22:00', nightEnd.value || '07:00');
    }, 1);
  };
};