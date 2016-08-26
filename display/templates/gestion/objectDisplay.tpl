
<dl class="dl-horizontal">
  <dt>Identifiant unique :</dt>
  <dd>{$objectData.uid}</dd>
</dl>
<dl class="dl-horizontal">
  <dt>N° spécifique :</dt>
  <dd>{$objectData.identifier}</dd>
</dl>
{if strlen($objectData.wgs84_x) > 0 || strlen($objectData.wgs84_y) > 0}
<dl class="dl-horizontal">
  <dt>Latitude :</dt>
  <dd>{$objectData.wgs84_y}</dd>
</dl>
<dl class="dl-horizontal">
  <dt>Longitude :</dt>
  <dd>{$objectData.wgs84_x}</dd>
</dl>
{/if}
