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
            document.getElementById("legend_description").innerHTML="Showing average speed";
            document.getElementById("legend_image").src="http://localhost:8080/geoserver/OBDComm/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20&LAYER=OBDComm:osm_roads&style=avg_speed&FORMAT=image/png&transparent=true&LEGEND_OPTIONS=forceRule:True;dx:0.2;dy:0.2;mx:0.2;my:0.2;fontStyle:borderColor:0000ff;border:true;fontColor:000000;fontSize:14";
            layer.mergeNewParams({styles:sensor});
            break;
        case "avg_rpm":
            document.getElementById("legend_description").innerHTML="Showing average rpm";
            document.getElementById("legend_image").src="http://localhost:8080/geoserver/OBDComm/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20&LAYER=OBDComm:osm_roads&style=avg_rpm&FORMAT=image/png&transparent=true&LEGEND_OPTIONS=forceRule:True;dx:0.2;dy:0.2;mx:0.2;my:0.2;fontStyle:borderColor:0000ff;border:true;fontColor:000000;fontSize:14";
            layer.mergeNewParams({styles:sensor});
            break;
        case "avg_co2": 
            document.getElementById("legend_description").innerHTML="Showing average co2";
            layer.mergeNewParams({styles:sensor});
            break; 
        case "avg_consumption": 
            document.getElementById("legend_description").innerHTML="Showing average consumption";
            layer.mergeNewParams({styles:sensor});
            break; 
        case "avg_standing_time": 
            document.getElementById("legend_description").innerHTML="Showing average standing time";
            layer.mergeNewParams({styles:sensor});
            break; 
        case "max_speed":
            document.getElementById("legend_description").innerHTML="Showing max speed"; 
            layer.mergeNewParams({styles:sensor});
            break;    
    }
    
    
}

$('a#change-sensor-speed').click(function(){ changeSensor("avg_speed");});
$('a#change-sensor-rpm').click(function(){ changeSensor("avg_rpm");});

window.onload = init;