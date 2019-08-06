{* Paramètres > Lieux de prélèvement > Nouveau > *}
<script type="text/javascript" charset="utf-8" src="display/javascript/ol-v4.2.0-dist/ol.js"></script>
<link rel="stylesheet" type="text/css" href="display/javascript/ol-v4.2.0-dist/ol.css">

<div id="map" class="map"></div>
<script>
var earth_radius = 6389125.541;
var zoom = {$mapDefaultZoom};
var mapIsChange = 0;
{if $mapIsChange == 1}mapIsChange = 1;{/if}
var mapCenter = [{$mapDefaultX}, {$mapDefaultY}];
{if strlen({$data.sampling_place_x})>0 && strlen({$data.sampling_place_y})>0} 
	mapCenter = [{$data.sampling_place_x}, {$data.sampling_place_y}];
{/if}
function getStyle() {
	var styleRed = new ol.style.Style( { 
		image: new ol.style.Circle({
		    radius: 6,
		    fill: new ol.style.Fill({
		          color: [255, 0, 0, 0.5]
		 	}),
			stroke: new ol.style.Stroke( { 
				color: [255 , 0 , 0 , 1],
				width: 1
			})
		})
	});
return styleRed;
}


var attribution = new ol.control.Attribution({
  collapsible: false
});
var mousePosition = new ol.control.MousePosition( { 
    coordinateFormat: ol.coordinate.createStringXY(2),
    projection: 'EPSG:4326',
    target: undefined,
    undefinedHTML: '&nbsp;'
});
var map = new ol.Map({
  controls: ol.control.defaults({ attribution: false }).extend([attribution]),
  target: 'map',
  view: new ol.View({
  	center: ol.proj.fromLonLat(mapCenter),
    zoom: zoom
  })
});

var layer = new ol.layer.Tile({
  source: new ol.source.OSM()
});

function transform_geometry(element) {
  var current_projection = new ol.proj.Projection({ code: "EPSG:4326" });
  var new_projection = layer.getSource().getProjection();

  element.getGeometry().transform(current_projection, new_projection);
}

map.addLayer(layer);
var coordinates;
var point;
var point_feature;
var features = new Array();
/*
 * Traitement de chaque localisation
 */
/*console.log("Début de traitement de l'affichage du point");
console.log("x : " + {$data.wgs84_x});
console.log("y  : "+ {$data.wgs84_y});
*/

coordinates = [{$data.sampling_place_x}, {$data.sampling_place_y}];
 point = new ol.geom.Point(coordinates);
 point_feature = new ol.Feature ( {
	geometry: point
});
point_feature.setStyle(getStyle({$data.uid}));
features.push ( point_feature) ;

/*  
 * Fin d'integration des points
 * Affichage de la couche
 */
var layerPoint = new ol.layer.Vector({
  source: new ol.source.Vector( {
    features: features
  })
});
features.forEach(transform_geometry);
map.addLayer(layerPoint);
map.addControl(mousePosition);

	$(".position").change(function () {
		var lon = $("#wgs84_x").val();
		var lat = $("#wgs84_y").val();
		if (lon.length > 0 && lat.length > 0) {
			console.log("longitude saisie : "+ lon);
			console.log ("latitude saisie : " + lat);
			var lonlat3857 = ol.proj.transform([parseFloat(lon),parseFloat(lat)], 'EPSG:4326', 'EPSG:3857');
	        point.setCoordinates (lonlat3857);
		}
	});
 
map.on('click', function(evt) {
	  var lonlat3857 = evt.coordinate;
	  var lonlat = ol.proj.transform(lonlat3857, 'EPSG:3857', 'EPSG:4326');
	  var lon = lonlat[0];
	  var lat = lonlat[1];
	  console.log("longitude sélectionnée : "+ lon);
	  console.log ("latitude sélectionnée : " + lat);
	  point.setCoordinates (lonlat3857);
	  $("#sampling_place_x").val(lon);
	  $("#sampling_place_y").val(lat);
});


</script>