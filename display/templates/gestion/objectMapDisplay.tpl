
<script type="text/javascript" charset="utf-8" src="display/javascript/ol.js"></script>
<style type="text/css" >
@import "display/CSS/ol.css";
</style>
<div id="map" class="map"></div>
<script>
var earth_radius = 6389125.541;
var zoom = {$mapDefaultZoom};
var mapIsChange = 0;
{if $mapIsChange == 1}mapIsChange = 1;{/if}
var mapCenter = [{$mapDefaultX}, {$mapDefaultY}];
{if strlen({$data.wgs84_x})>0 && strlen({$data.wgs84_y})>0} 
	mapCenter = [{$data.wgs84_x}, {$data.wgs84_y}];
{/if}
function getStyle(libelle) {
	libelle = libelle.toString();
	//console.log("libelle : "+libelle);
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
		}),
		text: new ol.style.Text( {
			textAlign: 'Left',
			text: libelle,
			textBaseline: 'middle',
			offsetX: 7,
			offsetY: 0,
			font: 'bold 12px Arial',
			/*fill: new ol.style.Fill({ color: 'rgba(255, 0, 0, 0.1)' }),
			stroke : new ol.style.Stroke({ color : 'rgba(255, 0, 0, 1)' })*/
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

coordinates = [{$data.wgs84_x}, {$data.wgs84_y}];
 point = new ol.geom.Point(coordinates);
// console.log("Coordonnées : "+coordinates);
// console.log("point :" + point);
 point_feature = new ol.Feature ( {
	geometry: point
});
console.log ("point généré");
//point_feature.setStyle(getStyle({$localisation[lst].localisation_id}));
point_feature.setStyle(getStyle({$data.uid}));
console.log("point_feature : " +point_feature);
features.push ( point_feature) ;
console.log("features : "+features);

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

if ( mapIsChange == 1) {
map.on('click', function(evt) {
	  var lonlat3857 = evt.coordinate;
	  var lonlat = ol.proj.transform(lonlat3857, 'EPSG:3857', 'EPSG:4326');
	  var lon = lonlat[0];
	  var lat = lonlat[1];
	  console.log("longitude sélectionnée : "+ lon);
	  console.log ("latitude sélectionnée : " + lat);
	  point.setCoordinates (lonlat3857);
	  $("#wgs84_x").val(lon);
	  $("#wgs84_y").val(lat);
});
}

</script>