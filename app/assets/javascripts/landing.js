!function ($) {
    $(function(){

        var $root = $('html, body');

        $('a').click(function() {
            var href = $.attr(this, 'href');
            $root.animate({
                scrollTop: $(href).offset().top
            }, 500, function () {
                window.location.hash = href;
            });
            return false;
        });
    })
}(window.jQuery)



var map, layer;
function init() {
  // Define a new map.  We want it to be loaded into the 'map_canvas' div in the view
  map = new OpenLayers.Map('map', {controls:[]});
  
  // Add a LayerSwitcher controller
  map.addControl(new OpenLayers.Control.LayerSwitcher());

  var osm = new OpenLayers.Layer.OSM();
  var vectorLayer = new OpenLayers.Layer.Vector("Measurements/Speed");
    
  map.addLayers([osm, vectorLayer]);

  var style = {
    'strokeColor': 'magenta',
    'strokeOpacity': 1.0,
    'strokeWidth': 2
  };

  epsg4326 =  new OpenLayers.Projection("EPSG:4326"); //WGS 1984 projection
  projectTo = map.getProjectionObject(); //The map projection (Spherical Mercator)

  //Get the coordinates from the gon measurements
  var gonPoints = [];
  for(var i=0; i<gon.measurements.length; i++) {
    var measurement = gon.measurements[i];
    gonPoints.push(
        new OpenLayers.Geometry.Point( measurement.lat, measurement.lon ).transform(epsg4326, projectTo)
    )
  }
  //Every Vector can have its own style: 
  var features = [];
  for(var i=0; i<gonPoints.length; i++) {
     style = { 
      pointRadius: Math.round(1 + gon.measurements[i].speed / 50),
      'strokeColor': 'magenta',
      'strokeOpacity': 1.0,
      'strokeWidth': 2
    };
     features.push(
       new OpenLayers.Feature.Vector(gonPoints[i], null, style)
     )
  }
  
  vectorLayer.addFeatures(features);
  
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
  }

  window.onload = init;