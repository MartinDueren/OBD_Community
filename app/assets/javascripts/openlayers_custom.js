var map, layer;

function init() {
  /*map = new OpenLayers.Map( 'map');
  layer = new OpenLayers.Layer.OSM( "Simple OSM Map");
  map.addLayer(layer);
  map.setCenter(
    new OpenLayers.LonLat(-71.147, 42.472).transform(
      new OpenLayers.Projection("EPSG:4326"),
      map.getProjectionObject()
      ), 12
    );*/
  // This function is called by the body onload() event in the view

  // Define a new map.  We want it to be loaded into the 'map_canvas' div in the view
  map = new OpenLayers.Map('map');

  // Add a LayerSwitcher controller
  map.addControl(new OpenLayers.Control.LayerSwitcher());

  // OpenStreetMaps
  var osm = new OpenLayers.Layer.OSM();

  // Add the layers defined above to the map  
  map.addLayers([osm]);

  // Set some styles 
  var myStyleMap = new OpenLayers.StyleMap({
    'strokeColor': 'magenta',
    'strokeOpacity': 1.0,
    'strokeWidth': 2
  });

  // Create a new vector layer including the above StyleMap
  var vectorLayer = new OpenLayers.Layer.Vector(
    "Measurements",
    { styleMap: myStyleMap }
  );
  map.addLayer(vectorLayer);

  // Get the polylines from Rails
  var url = "/measurement/1.json"
  OpenLayers.loadURL(url, {}, null, function (response){
    var geojson_format = new OpenLayers.Format.GeoJSON({
      'internalProjection': new OpenLayers.Projection("EPSG:4326"),//900913 for Google
      'externalProjection': new OpenLayers.Projection("EPSG:4326")
    });

    //Read the GeoJSON
    var features = geojson_format.read(response.responseText,"FeatureCollection");

    var bounds;

    if(features) {
      if(features.constructor != Array) {
        features = [features];
      }

      // Iterate over the features and extend the bounds to the bounds of the geometries
      for(var i=0; i<features.length; ++i) {
        if (!bounds) {
          bounds = features[i].geometry.getBounds();
        } else {
          bounds.extend(features[i].geometry.getBounds());
        }
      }

      // Add features to the 'vectorLayer'
      vectorLayer.addFeatures(features);

      // Set the extent of the map to the 'bounds'
      map.zoomToExtent(bounds);
    }
  });
}

window.onload = init;

