<link rel="stylesheet" href="display/node_modules/leaflet.markercluster/dist/MarkerCluster.css">
<link rel="stylesheet" href="display/node_modules/leaflet.markercluster/dist/MarkerCluster.Default.css">
<script src="display/node_modules/leaflet.markercluster/dist/leaflet.markercluster.js"></script>
<script>

</script>
{include file="mapDefault.tpl"}
<div id="mapList" class="map"></div>

<script>
  var mapList = setMap( "mapList" );
  L.control.scale().addTo( mapList );
  mapList.setMaxZoom( 19 );
  var markers = JSON.parse( '{$markers}' );
  var markerGroup = L.markerClusterGroup();
  var isMarkersGenerated = false;
  mapList.addLayer( markerGroup );

  $( "body" ).on( "shown.bs.tab", "#tabmap", function () {
    if ( !isMarkersGenerated ) {
      /** Create the markers */
      markers.markers.forEach( function ( marker ) {
        var markerContent = marker.uid + " " + encodeHtml(marker.identifier);
        var mark = L.marker( marker.latlng, {
          "title": markerContent
        });
        mark.bindPopup("<a href=sampleDisplay?uid=" + marker.uid +">"+ markerContent + "</a>").openPopup();
        markerGroup.addLayer( mark );
      } );
      mapDisplay( mapList );
      isMarkersGenerated = true;
    }
    mapList.invalidateSize( true );
  } );
</script>