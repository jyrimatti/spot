
  let readInterval = () => {
    let initialInterval = window.location.hash ? window.location.hash.substring(1).split('/').map(x => new Date(x))
                                               : [addHours(new Date(), -30*24), addHours(new Date(), 2*24)];
    return {start: initialInterval[0], end: initialInterval[1]};
  };

  let interval = readInterval();
  let q = document.getElementById('query');
  q.value = q.value.replace("{start}", interval.start.toISOString()).replace("{end}", interval.end.toISOString());
  
  let getData = function(name, queryF, cb) {
    console.log("Querying " + name + " for " + JSON.stringify(interval));
    let start = Math.floor(interval.start.getTime()/1000);
    let end = Math.floor((interval.end.getTime()/1000));
    load('/spot.db', queryF(start, end))
      .then(function(data) {
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
    fontSize: "0.75em"
  });

  xAxis.createAxisRange(xAxis.makeDataItem({
      value:    new Date().getTime() - 1000*60*3,
      endValue: new Date().getTime() + 1000*60*3,
  })).get("axisFill").setAll({
      fill:        am5.color('#85c7fc'),
      fillOpacity: 1,
      visible: true,
      tooltipText: formatInTimeZone(new Date(), 'Europe/Helsinki', 'yyyy-MM-dd HH:mm')
  });

  let series = chart.series.push( 
    am5xy.ColumnSeries.new(root, { 
      name: "Spot",
      xAxis: xAxis, 
      yAxis: yAxis, 
      valueYField: "centsPerKWh", 
      valueXField: "instant"
    }) 
  );
  series.columns.template.setAll({
    fillOpacity: 0.5,
    cornerRadiusTL: 2,
    cornerRadiusTR: 2,
    tooltipText: "\ncents/kWh: {centsPerKWh}",
    tooltipY: am5.percent(0),
    width: am5.percent(90)
  });
  
  series.columns.template.states.create("hover", {
    fillOpacity: 1
  });
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
  series.columns.template.adapters.add("tooltipText", (text, target) => {
    let instant = target.dataItem.dataContext.instant;
    return formatInTimeZone(new Date(instant), 'Europe/Helsinki', "yyyy-MM-dd HH:mm") + " - " + formatInTimeZone(addHours(new Date(instant), 1), 'Europe/Helsinki', "HH:mm") + text;
  });

  series.events.once("datavalidated", () => {
    xAxis.zoomToDates(addHours(new Date(), -24), new Date(Math.max(...series.data.values.map(x => x.instant))));
  });

  let init = () => {
    getData("spot", (start, end) => document.getElementById('query').value.replace("{start}", start).replace("{end}", end), data => {
      series.data.setAll(data);

      eachDayOfInterval(interval).forEach(x => {
        xAxis.createAxisRange(xAxis.makeDataItem({
            value:    zonedTimeToUtc(new Date(formatInTimeZone(x, 'Europe/Helsinki', 'yyyy-MM-dd') + 'T22:00:00'), 'Europe/Helsinki').getTime(),
            endValue: zonedTimeToUtc(new Date(formatInTimeZone(addHours(x, 24), 'Europe/Helsinki', 'yyyy-MM-dd') + 'T07:00:00'), 'Europe/Helsinki').getTime(),
        })).get("axisFill").setAll({
            fill:        am5.color('#cccccc'),
            fillOpacity: 0.3,
            visible: true
        });
      });
    });
  };

  init();
  q.addEventListener('change', init);