var map = new OpenLayers.Map("map");//, {controls:[]});
var marker;
//style for selected measurement
highlightStyle = {
  pointRadius: 10,
  'fillColor': '#0066FF',
  'strokeColor': '#0000CC',
  'strokeOpacity': 1.0,
  'strokeWidth': 2
};
//route line style
var style = {
  strokeColor: '#0000ff',
  strokeOpacity: 0.8,
  strokeWidth: 5
};
var gonPoints = [];
var epsg4326;
var projectTo;

function init(){
 initMap();
 initChart();
 addHeatmapLayer();
}

function initChart(){
  
  //defining data and setting up the hash for lookup
  var seriesData = [[],[],[]];
  epsg4326 =  new OpenLayers.Projection("EPSG:4326"); //WGS 1984 projection
  projectTo = map.getProjectionObject();

  for(var i = 0; i < gon.measurements.length; i++) {
    var coords = gon.measurements[i].latlon.replace("(", "").replace(")","").split(" ")
    var date = new Date(gon.measurements[i].recorded_at).getTime();
    //speed
    seriesData[0][i] = {
      x: date,
      y: gon.measurements[i].speed,
      label: "Km/h"
    }
    //rpm
    seriesData[1][i] = {
      x: date,
      y: gon.measurements[i].rpm,
      label: "rpm/10"
    }
    //consumption
    seriesData[2][i] = {
      x: date,
      y: gon.measurements[i].consumption,
      label: "l/100km"
    }
    dataHash[date] = new OpenLayers.Geometry.Point( coords[1], coords[2] ).transform(epsg4326, projectTo);
  }
  
  
  var chart = new CanvasJS.Chart("chartContainer", {
    zoomEnabled: true,
    panEnabled: true,
    legend: {
      horizontalAlign: "left", // left, center ,right 
      verticalAlign: "top",  // top, center, bottom
    },
    axisX:{
        valueFormatString: "hh:mm",
        includeZero: false
    },
    axisY: {
        valueFormatString: " "
    },
    data: [//array of dataSeries
    { //dataSeries object

      /*** Change type "column" to "bar", "area", "line" or "pie"***/
      
      type: "spline",
      name: "Speed in Km/h",
      showInLegend: true,
      xValueType: "dateTime",
      dataPoints: seriesData[0]
    },
    { //dataSeries object

      /*** Change type "column" to "bar", "area", "line" or "pie"***/
      axisYType: "secondary",
      type: "spline",
      name: "Consumption in l/100km",
      showInLegend: true,
      xValueType: "dateTime",
      dataPoints: seriesData[2]
    },
    { //dataSeries object

      /*** Change type "column" to "bar", "area", "line" or "pie"***/
      axisYType: "secondary",
      type: "spline",
      name: "rpm",
      showInLegend: true,
      xValueType: "dateTime",
      dataPoints: seriesData[1]
    }
    ]
  });

  chart.render();
}

function initMap() {

  var osm = new OpenLayers.Layer.OSM("Base Layer");
  var vectorLayer = new OpenLayers.Layer.Vector("Driven Route");
  map.addLayers([osm, vectorLayer]);

  //map.addControl(new OpenLayers.Control.PanZoomBar());
  map.addControl(new OpenLayers.Control.LayerSwitcher());
  //map.addControl(new OpenLayers.Control.MousePosition());
  //map.addControl(new OpenLayers.Control.OverviewMap());
  map.addControl(new OpenLayers.Control.KeyboardDefaults());
  //map.addControl(new OpenLayers.Control.DragPan());

  epsg4326 =  new OpenLayers.Projection("EPSG:4326"); //WGS 1984 projection
  projectTo = map.getProjectionObject();

  var lonLat = new OpenLayers.LonLat(-0.12, 51.503 ).transform(epsg4326, projectTo);

  //Get the coordinates from the gon measurements
  //var gonPoints = [];
  for(var i=0; i<gon.measurements.length; i++) {
    var coords = gon.measurements[i].latlon.replace("(", "").replace(")","").split(" ")
    gonPoints.push(
      new OpenLayers.Geometry.Point( coords[1], coords[2] ).transform(epsg4326, projectTo)
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
  //initGraph();
}

function addHeatmapLayer(){
  features = [];
  for(var i=0; i<gon.measurements.length; i++) {
    var measurement = gon.measurements[i];
    var coords = gon.measurements[i].latlon.replace("(", "").replace(")","").split(" ")
    var g = new OpenLayers.Geometry.Point( coords[1], coords[2] ).transform(epsg4326, projectTo)
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
        radius: 15
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

//call init
window.onload = init;


