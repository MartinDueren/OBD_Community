var map, layer, format, sld;

function init() {
    var geographic = new OpenLayers.Projection("EPSG:4326");
    var mercator = new OpenLayers.Projection("EPSG:900913");

    var muenster_center = new OpenLayers.LonLat(7.623718, 51.960769).transform(
        geographic, mercator
    );

    var mapOptions = {
        div: "map",
        projection: new OpenLayers.Projection("EPSG:900913"),
        units: "m",
    };

    map = new OpenLayers.Map('map', mapOptions);


    var osm = new OpenLayers.Layer.OSM();
    map.addLayers([osm]);


    layer = new OpenLayers.Layer.WMS(
        "Vienna Calling",
        "http://localhost:8080/geoserver/OBDComm/wms?", {
            layers: "OBDComm:osm_roads",
            transparent: true   
        }
    );

    map.addLayer(layer);
    map.setCenter(muenster_center, 13);

}


function changeSensor(sensor){
    switch (sensor){
        case "avg_speed":
            layer.mergeNewParams({styles:sensor});
            break;
        case "avg_rpm":
            layer.mergeNewParams({styles:sensor});
            break;
        case "avg_co2": 
            layer.mergeNewParams({styles:sensor});
            break; 
        case "avg_consumption": 
            layer.mergeNewParams({styles:sensor});
            break; 
        case "avg_standing_time": 
            layer.mergeNewParams({styles:sensor});
            break; 
        case "max_speed": 
            layer.mergeNewParams({styles:sensor});
            break;    
    }
    
    
}

$('a#change-sensor-speed').click(function(){ changeSensor("avg_speed");});
$('a#change-sensor-rpm').click(function(){ changeSensor("avg_rpm");});

window.onload = init;