
  let readInterval = () => {
    let initialInterval = window.location.hash ? window.location.hash.substring(1).split('/').map(x => new Date(x))
                                               : [addHours(new Date(), -30*24), addHours(new Date(), 2*24)];
    return {start: initialInterval[0], end: initialInterval[1]};
  };

  let interval = readInterval();
  let q = document.getElementById('query');
  q.value = q.value.replace("{start}", interval.start.toISOString()).replace("{end}", interval.end.toISOString());
  
  let getData = (name, queryF, cb) => {
    console.log("Querying " + name + " for " + JSON.stringify(interval));
    load('/spot.db', queryF())
      .then(data => {
        if (data == "") {
          console.log("Got empty data for " + name);
        } else {
          console.log("Got " + data.length + " rows for " + name);
        }
        cb(data.map(x => ({...x, instant: x.instant*1000}))
               .sort((a,b) => a.instant - b.instant));
      });
  };

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
      return formatInTimeZone(new Date(instant), 'Europe/Helsinki', "yyyy-MM-dd HH:mm") + " - " + formatInTimeZone(addHours(new Date(instant), 1), 'Europe/Helsinki', "HH:mm") + "\n" + text;
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
    xAxis.zoomToDates(addHours(new Date(), -24), new Date(Math.max(...series.data.values.map(x => x.instant))));
  });

  let legend = chart.plotContainer.children.push(am5.Legend.new(root, {
    layout: root.verticalLayout
  }));
  legend.data.setAll([series, taxSeries]);
  
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
    return formatInTimeZone(new Date(instant), 'Europe/Helsinki', "yyyy-MM-dd HH:mm") +
      (series.data.values.length == 0 ? '' : "\n" + (price() > 0 ? price().toFixed(2) + " + " + (price()*0.24).toFixed(2) + " = " + (price()*1.24).toFixed(2) : price()) + " c/kwh");
  });

  let initRanges = (interval, showWeekends, showNights) => {
    if (showWeekends) {
      eachWeekendOfInterval(interval).forEach(x => {
        let weekend = xAxis.createAxisRange(xAxis.makeDataItem({
            value:    x.getTime(),
            endValue: addHours(x, 24).getTime(),
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
      eachDayOfInterval(interval).forEach(x => {
        let night = xAxis.createAxisRange(xAxis.makeDataItem({
            value:    zonedTimeToUtc(new Date(formatInTimeZone(x, 'Europe/Helsinki', 'yyyy-MM-dd') + 'T22:00:00'), 'Europe/Helsinki').getTime(),
            endValue: zonedTimeToUtc(new Date(formatInTimeZone(addHours(x, 24), 'Europe/Helsinki', 'yyyy-MM-dd') + 'T07:00:00'), 'Europe/Helsinki').getTime(),
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

    getData("spot", () => q.value, data => {
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
  q.addEventListener('change', init);