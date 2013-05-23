var map = new OpenLayers.Map("map", {controls:[]});//, {controls:[]});
var marker;
highlightStyle = {
  pointRadius: 10,
  'strokeColor': 'magenta',
  'strokeOpacity': 1.0,
  'strokeWidth': 2
};
var gonPoints = [];
var epsg4326;
var projectTo;

function init() {

  var osm = new OpenLayers.Layer.OSM("Base Layer");
  var vectorLayer = new OpenLayers.Layer.Vector("Driven Route");
  map.addLayers([osm, vectorLayer]);

  map.addControl(new OpenLayers.Control.PanZoomBar());
  map.addControl(new OpenLayers.Control.LayerSwitcher());
  map.addControl(new OpenLayers.Control.MousePosition());
  map.addControl(new OpenLayers.Control.OverviewMap());
  map.addControl(new OpenLayers.Control.KeyboardDefaults());
  map.addControl(new OpenLayers.Control.DragPan());



  var style = {
    strokeColor: '#0000ff',
    strokeOpacity: 0.8,
    strokeWidth: 10
  };

  epsg4326 =  new OpenLayers.Projection("EPSG:4326"); //WGS 1984 projection
  projectTo = map.getProjectionObject();

  var lonLat = new OpenLayers.LonLat(-0.12, 51.503 ).transform(epsg4326, projectTo);

  //Get the coordinates from the gon measurements
  //var gonPoints = [];
  for(var i=0; i<gon.measurements.length; i++) {
    var measurement = gon.measurements[i];
    gonPoints.push(
      new OpenLayers.Geometry.Point( measurement.lat, measurement.lon ).transform(epsg4326, projectTo)
    )
  }

  var feature = new OpenLayers.Feature.Vector(
    new OpenLayers.Geometry.LineString(gonPoints),
    null,
    style
  );

  vectorLayer.addFeatures(feature);

  var bounds = new OpenLayers.Bounds();

  if(gonPoints) {
    if(gonPoints.constructor != Array) {
      gonPoints = [gonPoints];
    }

    // Iterate over the features and extend the bounds to the bounds of the geometries
    for(var i=0; i<gonPoints.length; i++) {
      if (!bounds) {
        bounds = gonPoints[i].getBounds();
      } else {
        bounds.extend(gonPoints[i].getBounds());
      }
    }
  }
  map.zoomToExtent(bounds);
  initGraph();

  addHeatmapLayer();
}

function addHeatmapLayer(){
  features = [];
  for(var i=0; i<gon.measurements.length; i++) {
    var measurement = gon.measurements[i];
    var g = new OpenLayers.Geometry.Point( measurement.lat, measurement.lon ).transform(epsg4326, projectTo)
    //insert what has to be shown here, e.g. speed/CO2
    features.push(
      new OpenLayers.Feature.Vector(g, {count: measurement.speed})
    )
  }

  //create our vectorial layer using heatmap renderer
  var heatmap = new OpenLayers.Layer.Vector("Heatmap Layer", {
    opacity: 0.3,
    renderers: ['Heatmap'],
    rendererOptions: {
      weight: 'count',
      heatmapConfig: {
        radius: 10
      }
    }
  });
  heatmap.addFeatures(features);
  map.addLayers([heatmap]);
}

function selectPoint(point){
  if(map.getLayersByName("Marker").length > 0){
    map.removeLayer(marker);
  }

  marker = new OpenLayers.Layer.Vector("Marker", { 
                'displayInLayerSwitcher': false 
        });
  var markers = [new OpenLayers.Feature.Vector(point, null, highlightStyle)];
  marker.addFeatures(markers);
  map.addLayers([marker]);
}



/*
* All below is for the rickshaw graph
*/
function initGraph(){
  // set up our data series with 50 random data points

  var seriesData = [[]];
  var hash = {};
  epsg4326 =  new OpenLayers.Projection("EPSG:4326"); //WGS 1984 projection
  projectTo = map.getProjectionObject();

  for(var i = 0; i < gon.measurements.length; i++) {
    var date = new Date(gon.measurements[i].created_at).getTime();
    seriesData[0][i] = {
      x: date,
      y: gon.measurements[i].speed
    }
    hash[date] = new OpenLayers.Geometry.Point( gon.measurements[i].lat, gon.measurements[i].lon ).transform(epsg4326, projectTo);
  }
  // instantiate our graph!
  var graph = new Rickshaw.Graph( {
    element: document.getElementById("chart"),
    height: 400,
    renderer: 'line',
    series: [
    {
      color: "#0000ff",
      data: seriesData[0],
      name: 'Speed'
    }
    ]
  } );

  var xAxis = new Rickshaw.Graph.Axis.Time({
    graph: graph
  });

  var yAxis = new Rickshaw.Graph.Axis.Y({
    graph: graph
  });

  yAxis.render();

  xAxis.render();

  graph.render();

  var legend = document.querySelector('#legend');

  var Hover = Rickshaw.Class.create(Rickshaw.Graph.HoverDetail, {

    render: function(args) {

      legend.innerHTML = args.formattedXValue;

      args.detail.sort(function(a, b) { return a.order - b.order }).forEach( function(d) {

        selectPoint(hash[d.value.x]);

        var line = document.createElement('div');
        line.className = 'line';

        var swatch = document.createElement('div');
        swatch.className = 'swatch';
        swatch.style.backgroundColor = d.series.color;

        var label = document.createElement('div');
        label.className = 'label';
        label.innerHTML = d.name + ": " + d.formattedYValue;

        line.appendChild(swatch);
        line.appendChild(label);

        legend.appendChild(line);

        var dot = document.createElement('div');
        dot.className = 'dot';
        dot.style.top = graph.y(d.value.y0 + d.value.y) + 'px';
        dot.style.borderColor = d.series.color;

        this.element.appendChild(dot);

        dot.className = 'dot active';

        this.show();

        }, this );
      }
    });

    var hover = new Hover( { graph: graph } );
  }


  //call init
  window.onload = init;