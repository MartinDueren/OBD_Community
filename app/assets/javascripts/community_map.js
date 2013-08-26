var map, layer, format, sld;
//var wms_url = "http://localhost:8080/geoserver/OBDComm/wms?";
var wms_url = "http://giv-dueren.uni-muenster.de:8080/geoserver/OBDComm/wms?";

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

    map.events.register("move", map, function() {
            postAnalytics();
        });
    
    var osm = new OpenLayers.Layer.OSM();
    map.addLayers([osm]);

    var grey = new OpenLayers.Layer.OSM('Simple OSM Map', null, {
        eventListeners: {
            tileloaded: function(evt) {
                var ctx = evt.tile.getCanvasContext();
                if (ctx) {
                    var imgd = ctx.getImageData(0, 0, evt.tile.size.w, evt.tile.size.h);
                    var pix = imgd.data;
                    for (var i = 0, n = pix.length; i < n; i += 4) {
                        pix[i] = pix[i + 1] = pix[i + 2] = (3 * pix[i] + 4 * pix[i + 1] + pix[i + 2]) / 8;
                    }
                    ctx.putImageData(imgd, 0, 0);
                    evt.tile.imgDiv.removeAttribute("crossorigin");
                    evt.tile.imgDiv.src = ctx.canvas.toDataURL();
                }
            }
        }
    });

    map.addLayer(grey);


    layer = new OpenLayers.Layer.WMS(
        "Community Statistics",
        wms_url, {
            layers: "OBDComm:osm_roads",
            transparent: true   
        }
    );

    map.addLayer(layer);
    map.addControl(new OpenLayers.Control.LayerSwitcher());
    map.setCenter(muenster_center, 13);

}


function changeSensor(sensor){
    postAnalytics();
    switch (sensor){
        case "avg_speed":
            document.getElementById("legend_description").innerHTML="Durchschnittliche Geschwindigkeit";
            document.getElementById("legend_image").src= wms_url + "REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20&LAYER=OBDComm:osm_roads&style=avg_speed&FORMAT=image/png&transparent=true&LEGEND_OPTIONS=forceRule:True;dx:0.2;dy:0.2;mx:0.2;my:0.2;fontStyle:borderColor:0000ff;border:true;fontColor:000000;fontSize:14";
            layer.mergeNewParams({styles:sensor});
            break;
        case "avg_rpm":
            document.getElementById("legend_description").innerHTML="Durchschnittliche Umdrehungen";
            document.getElementById("legend_image").src= wms_url + "REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20&LAYER=OBDComm:osm_roads&style=avg_rpm&FORMAT=image/png&transparent=true&LEGEND_OPTIONS=forceRule:True;dx:0.2;dy:0.2;mx:0.2;my:0.2;fontStyle:borderColor:0000ff;border:true;fontColor:000000;fontSize:14";
            layer.mergeNewParams({styles:sensor});
            break;
        case "avg_co2": 
            document.getElementById("legend_description").innerHTML="Durchschnittliche CO2 Emissionen";
            document.getElementById("legend_image").src= wms_url + "REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20&LAYER=OBDComm:osm_roads&style=avg_co2&FORMAT=image/png&transparent=true&LEGEND_OPTIONS=forceRule:True;dx:0.2;dy:0.2;mx:0.2;my:0.2;fontStyle:borderColor:0000ff;border:true;fontColor:000000;fontSize:14";
            layer.mergeNewParams({styles:sensor});
            break; 
        case "avg_consumption": 
            document.getElementById("legend_description").innerHTML="Durchschnittlicher Verbrauch";
            document.getElementById("legend_image").src= wms_url + "REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20&LAYER=OBDComm:osm_roads&style=avg_consumption&FORMAT=image/png&transparent=true&LEGEND_OPTIONS=forceRule:True;dx:0.2;dy:0.2;mx:0.2;my:0.2;fontStyle:borderColor:0000ff;border:true;fontColor:000000;fontSize:14";
            layer.mergeNewParams({styles:sensor});
            break; 
        case "avg_standing_time": 
            document.getElementById("legend_description").innerHTML="Durchschnittliche Standzeit";
            document.getElementById("legend_image").src= wms_url + "REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20&LAYER=OBDComm:osm_roads&style=avg_standing_time&FORMAT=image/png&transparent=true&LEGEND_OPTIONS=forceRule:True;dx:0.2;dy:0.2;mx:0.2;my:0.2;fontStyle:borderColor:0000ff;border:true;fontColor:000000;fontSize:14";
            layer.mergeNewParams({styles:sensor});
            break; 
        case "max_speed":
            document.getElementById("legend_description").innerHTML="Max Geschwindigkeit"; 
            document.getElementById("legend_image").src= wms_url + "REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=20&LAYER=OBDComm:osm_roads&style=max_speed&FORMAT=image/png&transparent=true&LEGEND_OPTIONS=forceRule:True;dx:0.2;dy:0.2;mx:0.2;my:0.2;fontStyle:borderColor:0000ff;border:true;fontColor:000000;fontSize:14";
            layer.mergeNewParams({styles:sensor});
            break;    
    }
    
    
}

var lastPost = new Date().getTime();
function postAnalytics(){
  if(lastPost != 0 && (new Date().getTime() - lastPost) > 3000){
    console.log("interaction");
    $.post("http://giv-dueren.uni-muenster.de/analytics/create", { user_id: gon.user, group: gon.user_group, action_name: gon.params.action, url: "/" + gon.params.controller + "/" + gon.params.action + "/", category: "interaction", description: JSON.stringify(gon.params) } );

    lastPost = new Date().getTime();
  }
}

$('a#change-sensor-avg-speed').click(function(){ changeSensor("avg_speed");});
$('a#change-sensor-avg-rpm').click(function(){ changeSensor("avg_rpm");});
$('a#change-sensor-avg-co2').click(function(){ changeSensor("avg_co2");});
$('a#change-sensor-avg-consumption').click(function(){ changeSensor("avg_consumption");});
$('a#change-sensor-avg-standing-time').click(function(){ changeSensor("avg_standing_time");});
$('a#change-sensor-max-speed').click(function(){ changeSensor("max_speed");});

window.onload = init;