<link rel="stylesheet" href="display/node_modules/leaflet.markercluster/dist/MarkerCluster.css">
<link rel="stylesheet" href="display/node_modules/leaflet.markercluster/dist/MarkerCluster.Default.css">
<script src="display/node_modules/leaflet.markercluster/dist/leaflet.markercluster.js"></script>
<script>

</script>
{include file="mapDefault.tpl"}
<div id="mapList" class="map"></div>

<script>
  var mapList = setMap("mapList");
  L.control.scale().addTo(mapList);
  mapList.setMaxZoom(25);
  var markers = L.markerClusterGroup();
  /** Create the markers */
  {foreach $samples as $sample}
    {if strlen($sample.wgs84_x)>0 && strlen($sample.wgs84_y) > 0}
      markers.addLayer(L.marker([ {$sample.wgs84_y}, {$sample.wgs84_x}], {
        "title": "{$sample.uid} {$sample.identifier}"
      })
      );
    {/if}
  {/foreach}
  mapList.addLayer(markers);
  mapDisplay(mapList);

$("body").on("shown.bs.tab", "#tabmap", function() {
    mapList.invalidateSize(true);
});
</script>