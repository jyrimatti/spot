let mkRoot = () => {
  let root = am5.Root.new("chart"); 
  root.setThemes([
    am5themes_Animated.new(root)
  ]);
  root.numberFormatter.set("numberFormat", "#.00");
  return root;
};

let mkChart = root =>
  root.container.children.push(
    am5xy.XYChart.new(root, {
      panX:       true,
      panY:       false,
      wheelY:     "zoomX",
      pinchZoomX: true,
      layout:     root.verticalLayout,
      scrollbarX: am5xy.XYChartScrollbar.new(root, {
        orientation: 'horizontal'
      })
    })
  );

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
    minBulletDistance: 15
  });
  ret.columns.template.setAll({
    fillOpacity:    0.5,
    cornerRadiusTL: 2,
    cornerRadiusTR: 2,
    tooltipText:    "{centsPerKWh} c/kWh",
    tooltipY:       am5.percent(0),
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

  ret.columns.template.adapters.add("tooltipText", (text, target) => {
    let instant = target.dataItem.dataContext.instant;
    return dateFnsTz.formatInTimeZone(new Date(instant), 'Europe/Helsinki', "yyyy-MM-dd HH:mm") +
            " - " +
            dateFnsTz.formatInTimeZone(dateFns.addHours(new Date(instant), 1), 'Europe/Helsinki', "HH:mm") +
            "\n" +
            text;
  });
  
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
    tooltipText: text
  }));
  ret.get('background').setAll({
    fill: am5.color(color)
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
  axisFill.get("tooltip").adapters.add("bounds", () => chart.plotContainer.globalBounds());

  axisFill.adapters.add("tooltipText", (text, target) => {
    let instant = target.dataItem.get('value');
    let price = () => data.findLast(x => x.instant <= instant).centsPerKWh;
    return dateFnsTz.formatInTimeZone(new Date(instant), 'Europe/Helsinki', "yyyy-MM-dd HH:mm") +
          (data.length == 0 ? '' : "\n" + (price() > 0 ? price().toFixed(2) + " + " + (price()*0.24).toFixed(2) + " = " + (price()*1.24).toFixed(2) : price()) + " c/kwh");
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
          fillOpacity: 0.05,
          visible:     true
      });
    });
  }
};

let initData = (dateFns, dateFnsTz, mainSeries, taxSeries, transmissionSeries, totals) => (data, eltax, dayPrice, nightPrice, nightStart, nightEnd) => {
  data = data.sort((a,b) => a.instant - b.instant);
  
  mainSeries.data.setAll(data);

  taxSeries.data.setAll(data.map(x => {
    return {...x, centsPerKWh: x.centsPerKWh > 0 ? x.centsPerKWh*0.24 : 0};
  }));

  let nightStartMinutes = nightStart.split(':').map(x => parseInt(x)).reduce((a,b) => a*60 + b);
  let nightEndMinutes   = nightEnd.split(':').map(x => parseInt(x)).reduce((a,b) => a*60 + b);
  transmissionSeries.data.setAll(data.map(x => {
    if (nightPrice && nightStart && nightEnd) {
      let minutes = dateFns.getHours(new Date(x.instant)) * 60 +
                    dateFns.getMinutes(new Date(x.instant));
      return {...x, centsPerKWh: (minutes >= nightStartMinutes || minutes < nightEndMinutes ? nightPrice : dayPrice) + eltax};
    } else {
      return {...x, centsPerKWh: dayPrice ? dayPrice + eltax : 0};
    }
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
    xAxis.zoomToDates(dateFns.addHours(new Date(), -24),
                      new Date(Math.max(...ev.target.data.values.map(x => x.instant)))));
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

let initChart = (dateFns, dateFnsTz, eltax, dayPrice, nightPrice, nightStart, nightEnd, spotVisible, taxVisible, transmissionVisible, nightVisible, weekendVisible) => {
  let root = mkRoot();
  let chart = mkChart(root);
  let yAxis = mkYAxis(root, chart);
  let xAxis = mkXAxis(root, chart);

  let mkSeries = mkSeriesConstructor(dateFns, dateFnsTz, root, chart, xAxis, yAxis);
  let spotSeries         = mkSeries("Spot", spotVisible);
  let taxSeries          = mkSeries("Tax 24%", taxVisible);
  let transmissionSeries = mkSeries("Transmission", transmissionVisible);
  let totals             = mkSeries("totals");
  
  initSpotSeries(dateFns, xAxis, spotSeries);
  transmissionSeries.setAll({
    fill: am5.color("#cfe2f3")
  });
  transmissionSeries.columns.template.setAll({
    fillOpacity: 0.2
  });
  initTotals(root, totals);

  if (!spotVisible.checked) {
    spotSeries.hide();
  }
  if (!taxVisible.checked) {
    taxSeries.hide();
  }
  if (!transmissionVisible.checked) {
    transmissionSeries.hide();
  }

  let legend = mkLegend(root, chart);
  legend.data.setAll([spotSeries, taxSeries, transmissionSeries]);

  let showNightsButton = mkButton(root, legend, "Show/hide nights", '#0000ff', nightVisible.checked);
  let showWeekendsButton = mkButton(root, legend, "Show/hide weekends", '#000000', weekendVisible.checked);

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
    if (baseInterval) {
      xAxis.set('baseInterval', { timeUnit: baseInterval, count: 1 });
    }
    initData(dateFns, dateFnsTz, spotSeries, taxSeries, transmissionSeries, totals)(data, parseFloat(eltax.value), parseFloat(dayPrice.value), parseFloat(nightPrice.value), nightStart.value, nightEnd.value);
    initRanges(data, baseInterval == 'hour', nightStart.value || '22:00', nightEnd.value || '07:00');
  };
};