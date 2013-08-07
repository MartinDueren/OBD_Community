//########################## MAP 1 ###############################
var map1 = new OpenLayers.Map("map1");//, {controls:[]});
var marker1;
var dataHash1 = {};
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
var gonPointsMap1 = [];
var epsg4326;
var projectTo;

function initChartMap1(){
  
  //defining data and setting up the hash for lookup
  var seriesData = [[],[],[]];
  epsg4326 =  new OpenLayers.Projection("EPSG:4326"); //WGS 1984 projection
  projectTo = map1.getProjectionObject();

  for(var i = 0; i < gon.measurementsMap1.length; i++) {
    var coords = gon.measurementsMap1[i].latlon.replace("(", "").replace(")","").split(" ")
    var date = new Date(gon.measurementsMap1[i].recorded_at).getTime();
    //speed
    seriesData[0][i] = {
      x: date,
      y: gon.measurementsMap1[i].speed,
      label: "Km/h"
    }
    //rpm
    seriesData[1][i] = {
      x: date,
      y: gon.measurementsMap1[i].rpm,
      label: "U/min"
    }
    //consumption
    seriesData[2][i] = {
      x: date,
      y: gon.measurementsMap1[i].consumption,
      label: "l/100 km"
    }
    dataHash1[date] = new OpenLayers.Geometry.Point( coords[1], coords[2] ).transform(epsg4326, projectTo);
  }
  
  
  
  var chart = new CanvasJS.Chart("chartContainerMap1", {
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
        title: "Geschwindigkeit",
        titleFontSize: 15
    },
    axisY2: {
        title: "U/min",
        titleFontSize: 15
        //valueFormatString: " "
    },
    data: [//array of dataSeries
    { //dataSeries object

      /*** Change type "column" to "bar", "area", "line" or "pie"***/
      
      type: "spline",
      name: "Geschwindigkeit in Km/h",
      showInLegend: true,
      xValueType: "dateTime",
      dataPoints: seriesData[0]
    },
    { //dataSeries object

      /*** Change type "column" to "bar", "area", "line" or "pie"***/
      axisYType: "primary",
      type: "spline",
      name: "Verbrauch in l/100 km",
      showInLegend: true,
      xValueType: "dateTime",
      dataPoints: seriesData[2]
    },
    { //dataSeries object

      /*** Change type "column" to "bar", "area", "line" or "pie"***/
      axisYType: "secondary",
      type: "spline",
      name: "U/min",
      showInLegend: true,
      xValueType: "dateTime",
      dataPoints: seriesData[1]
    }
    ]
  });

  chart.render();
}

function initMap1() {

  var osm = new OpenLayers.Layer.OSM("Base Layer");
  var vectorLayer = new OpenLayers.Layer.Vector("Driven Route");
  map1.addLayers([osm, vectorLayer]);

  //map.addControl(new OpenLayers.Control.PanZoomBar());
  map1.addControl(new OpenLayers.Control.LayerSwitcher());
  //map.addControl(new OpenLayers.Control.MousePosition());
  //map.addControl(new OpenLayers.Control.OverviewMap());
  map1.addControl(new OpenLayers.Control.KeyboardDefaults());
  //map.addControl(new OpenLayers.Control.DragPan());

  epsg4326 =  new OpenLayers.Projection("EPSG:4326"); //WGS 1984 projection
  projectTo = map1.getProjectionObject();

  var lonLat = new OpenLayers.LonLat(-0.12, 51.503 ).transform(epsg4326, projectTo);

  //Get the coordinates from the gon measurements
  //var gonPoints = [];
  for(var i=0; i<gon.measurementsMap1.length; i++) {
    var coords = gon.measurementsMap1[i].latlon.replace("(", "").replace(")","").split(" ")
    gonPointsMap1.push(
      new OpenLayers.Geometry.Point( coords[1], coords[2] ).transform(epsg4326, projectTo)
    )
  }

  var feature = new OpenLayers.Feature.Vector(
    new OpenLayers.Geometry.LineString(gonPointsMap1),
    null,
    style
  );

  vectorLayer.addFeatures(feature);

  var bounds = new OpenLayers.Bounds();

  if(gonPointsMap1) {
    if(gonPointsMap1.constructor != Array) {
      gonPointsMap1 = [gonPointsMap1];
    }

    // Iterate over the features and extend the bounds to the bounds of the geometries
    for(var i=0; i<gonPointsMap1.length; i++) {
      if (!bounds) {
        bounds = gonPointsMap1[i].getBounds();
      } else {
        bounds.extend(gonPointsMap1[i].getBounds());
      }
    }
  }
  map1.zoomToExtent(bounds);
  //initGraph();
}

function addHeatmapLayerMap1(){
  features = [];
  for(var i=0; i<gon.measurementsMap1.length; i++) {
    var measurement = gon.measurementsMap1[i];
    var coords = gon.measurementsMap1[i].latlon.replace("(", "").replace(")","").split(" ")
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
  map1.addLayers([heatmap]);
}


//TODO this could be more DRY
function selectPoint(point){
	if(searchResult.dataPoint.x in dataHash1){
		if(map1.getLayersByName("Marker1").length > 0){
			map1.removeLayer(marker1);
  	}
  	marker1 = new OpenLayers.Layer.Vector("Marker1", {
    	'displayInLayerSwitcher': false
  	});
  	var markers1 = [new OpenLayers.Feature.Vector(dataHash1[searchResult.dataPoint.x], null, highlightStyle)];
  	marker1.addFeatures(markers1);
  	map1.addLayers([marker1]);

	}else if(searchResult.dataPoint.x in dataHash2){
		if(map2.getLayersByName("Marker2").length > 0){
    	map2.removeLayer(marker2);
  	}  
	  marker2 = new OpenLayers.Layer.Vector("Marker2", {
	    'displayInLayerSwitcher': false
	  });  
	  var markers2 = [new OpenLayers.Feature.Vector(dataHash2[searchResult.dataPoint.x], null, highlightStyle)];
	  marker2.addFeatures(markers2);
	  map2.addLayers([marker2]);

	}
	
  
  
}

//call init
//window.onload = init1;

//########################## MAP 2 #########################################

var map2 = new OpenLayers.Map("map2");//, {controls:[]});
var marker2;
var dataHash2 = {};
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
var gonPointsMap2 = [];
var epsg4326;
var projectTo;

function init(){
 initMap1();
 initChartMap1();
 //addHeatmapLayerMap1();
 initMap2();
 initChartMap2();
 //addHeatmapLayerMap2();
}

function initChartMap2(){
  
  //defining data and setting up the hash for lookup
  var seriesData = [[],[],[]];
  epsg4326 =  new OpenLayers.Projection("EPSG:4326"); //WGS 1984 projection
  projectTo = map2.getProjectionObject();

  for(var i = 0; i < gon.measurementsMap2.length; i++) {
    var coords = gon.measurementsMap2[i].latlon.replace("(", "").replace(")","").split(" ")
    var date = new Date(gon.measurementsMap2[i].recorded_at).getTime();
    //speed
    seriesData[0][i] = {
      x: date,
      y: gon.measurementsMap2[i].speed,
      label: "Km/h"
    }
    //rpm
    seriesData[1][i] = {
      x: date,
      y: gon.measurementsMap2[i].rpm,
      label: "U/min"
    }
    //consumption
    seriesData[2][i] = {
      x: date,
      y: gon.measurementsMap2[i].consumption,
      label: "l/100 km"
    }
    dataHash2[date] = new OpenLayers.Geometry.Point( coords[1], coords[2] ).transform(epsg4326, projectTo);
  }
  
  
  var chart = new CanvasJS.Chart("chartContainerMap2", {
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
        title: "Geschwindigkeit",
        titleFontSize: 15
    },
    axisY2: {
        title: "U/min",
        titleFontSize: 15
        //valueFormatString: " "
    },
    data: [//array of dataSeries
    { //dataSeries object

      /*** Change type "column" to "bar", "area", "line" or "pie"***/
      
      type: "spline",
      name: "Geschwindigkeit in Km/h",
      showInLegend: true,
      xValueType: "dateTime",
      dataPoints: seriesData[0]
    },
    { //dataSeries object

      /*** Change type "column" to "bar", "area", "line" or "pie"***/
      axisYType: "primary",
      type: "spline",
      name: "Verbrauch in l/100 km",
      showInLegend: true,
      xValueType: "dateTime",
      dataPoints: seriesData[2]
    },
    { //dataSeries object

      /*** Change type "column" to "bar", "area", "line" or "pie"***/
      axisYType: "secondary",
      type: "spline",
      name: "U/min",
      showInLegend: true,
      xValueType: "dateTime",
      dataPoints: seriesData[1]
    }
    ]
  });

  chart.render();
}

function initMap2() {

  var osm = new OpenLayers.Layer.OSM("Base Layer");
  var vectorLayer = new OpenLayers.Layer.Vector("Driven Route");
  map2.addLayers([osm, vectorLayer]);

  //map.addControl(new OpenLayers.Control.PanZoomBar());
  map2.addControl(new OpenLayers.Control.LayerSwitcher());
  //map.addControl(new OpenLayers.Control.MousePosition());
  //map.addControl(new OpenLayers.Control.OverviewMap());
  map2.addControl(new OpenLayers.Control.KeyboardDefaults());
  //map.addControl(new OpenLayers.Control.DragPan());

  epsg4326 =  new OpenLayers.Projection("EPSG:4326"); //WGS 1984 projection
  projectTo = map2.getProjectionObject();

  var lonLat = new OpenLayers.LonLat(-0.12, 51.503 ).transform(epsg4326, projectTo);

  //Get the coordinates from the gon measurements
  //var gonPoints = [];
  for(var i=0; i<gon.measurementsMap2.length; i++) {
    var coords = gon.measurementsMap2[i].latlon.replace("(", "").replace(")","").split(" ")
    gonPointsMap2.push(
      new OpenLayers.Geometry.Point( coords[1], coords[2] ).transform(epsg4326, projectTo)
    )
  }

  var feature = new OpenLayers.Feature.Vector(
    new OpenLayers.Geometry.LineString(gonPointsMap2),
    null,
    style
  );

  vectorLayer.addFeatures(feature);

  var bounds = new OpenLayers.Bounds();

  if(gonPointsMap2) {
    if(gonPointsMap2.constructor != Array) {
      gonPointsMap2 = [gonPointsMap2];
    }

    // Iterate over the features and extend the bounds to the bounds of the geometries
    for(var i=0; i<gonPointsMap2.length; i++) {
      if (!bounds) {
        bounds = gonPointsMap2[i].getBounds();
      } else {
        bounds.extend(gonPointsMap2[i].getBounds());
      }
    }
  }
  map2.zoomToExtent(bounds);
  //initGraph();
}

function addHeatmapLayerMap2(){
  features = [];
  for(var i=0; i<gon.measurementsMap2.length; i++) {
    var measurement = gon.measurementsMap2[i];
    var coords = gon.measurementsMap2[i].latlon.replace("(", "").replace(")","").split(" ")
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
  map2.addLayers([heatmap]);
}

//call init
window.onload = init;



