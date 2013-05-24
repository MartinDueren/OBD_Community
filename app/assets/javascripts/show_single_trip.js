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

  var seriesData = [[],[]];
  var hash = {};
  epsg4326 =  new OpenLayers.Projection("EPSG:4326"); //WGS 1984 projection
  projectTo = map.getProjectionObject();

  for(var i = 0; i < gon.measurements.length; i++) {
    var date = new Date(gon.measurements[i].created_at).getTime();
    //speed
    seriesData[0][i] = {
      x: date,
      y: gon.measurements[i].speed
    }
    //rpm
    seriesData[1][i] = {
      x: date,
      y: gon.measurements[i].rpm
    }
    hash[date] = new OpenLayers.Geometry.Point( gon.measurements[i].lat, gon.measurements[i].lon ).transform(epsg4326, projectTo);
  }
  // instantiate our graph!
  var graph = new Rickshaw.Graph( {
    element: document.getElementById("chart"),
    height: 250,
    width: 400,
    renderer: 'area',
    stroke: true,
    series: [
    {
      color: 'rgba(70,130,180,0.5)',
      stroke: 'rgba(0,0,0,0.15)',
      data: seriesData[0],
      name: 'Speed'
    }, {
      color: 'rgba(202,226,247,0.5)',
      stroke: 'rgba(0,0,0,0.15)',
      data: seriesData[1],
      name: 'Rpm'
    }
    ]
  } );

  var hoverDetail = new Rickshaw.Graph.HoverDetail( {
    graph: graph
  } );

  var time = new Rickshaw.Fixtures.Time();
  var hour = time.unit('hour');

  var xAxis = new Rickshaw.Graph.Axis.Time({
    graph: graph,
    timeUnit: hour
  });

  xAxis.render();
  graph.renderer.unstack = true;
  graph.render();



  var Hover = Rickshaw.Class.create(Rickshaw.Graph.HoverDetail, {

    render: function(args) {

      args.detail.sort(function(a, b) { return a.order - b.order }).forEach( function(d) {

        selectPoint(hash[d.value.x]);

        }, this );
      }
    });

    var hover = new Hover( { graph: graph } );
  }


  //call init
  window.onload = init;