/* TODO
get trip id with gon
display gps route (w nice styling)
*/

var lineLayer = new OpenLayers.Layer.Vector("Line Layer"); 
var line = new OpenLayers.Geometry.LineString(gon.coords)
var style = { 
  strokeColor: '#0000ff', 
  strokeOpacity: 0.5,
  strokeWidth: 5
};

var lineFeature = new OpenLayers.Feature.Vector(line, null, style);
lineLayer.addFeatures([lineFeature]);  
  
var map = new OpenLayers.Map("map");

var ol_wms = new OpenLayers.Layer.WMS(
    "OpenLayers WMS",
    "http://vmap0.tiles.osgeo.org/wms/vmap0",
    {layers: "basic"}
);



map.addLayers([ol_wms, lineLayer]);
map.zoomToMaxExtent();