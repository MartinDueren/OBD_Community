var map;

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


    map.setCenter(muenster_center, 13);

}



window.onload = init;

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