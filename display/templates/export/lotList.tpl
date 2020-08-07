<script>
$(document).ready ( function() {
  var collectionId = 0;
  try {
			collectionId = Cookies.get("collectionId");
      if (collectionId) {
         $("#collection_id").val(collectionId);
      }
		} catch {
		}

  $("#lotSearch").submit( function (event) {
    collectionId = $("#collection_id").val();
    Cookies.set("collectionId", collectionId, { expires: 30, secure: true });
  });
});
</script>
<h2>Liste des lots</h2>
<div class="row">
  <div class="col-md-6 form-horizontal">
    <form id="lotSearch" action="index.php" method="GET">
      <input type="hidden" name="moduleBase" value="lot">
      <input type="hidden" name="action" value="List">
      <div class="row">
        <div class="form-group">
          <label for="collection_id" class= "col-sm-3 control-label">{t}Collection :{/t}</label>
          <div class="col-sm-3">
            <select id="collection_id" class="form-control">
              {foreach $collections as $collection}
                <option value="{$collection.collection_id}">{$collection.collection_name}</option>
              {/foreach}
            </select>
          </div>
        </div>
      </div>
      <div class="row center">
        <button type="submit" class="btn btn-success">{t}Rechercher{/t}</button>
      </div>
    </form>
  </div>
</div>
<div class="row ">
  <div class="col-md-6 bg-info">
    {t}Les lots doivent être créés depuis le module de recherche des échantillons.{/t}
  </div>
</div>
{if count($lots) > 0}
<div class="row">
  <div class="col-md-6">
    <table class="table table-bordered table-hover datatable" data-order='[[1, "desc"]]'>
      <thead>
        <tr>
          <th class="center"><img src="display/images/display.png" height="25"></th>
          <th>{t}Date de création{/t}</th>
          <th>{t}Nombre d'échantillons{/t}</th>
        </tr>
      </thead>
      <tbody>
        {foreach $lots as $lot}
        <tr>
          <td class="center">
            <a href="index.php?module=lotDisplay&lot_id={$lot.lot_id}">
                <img src="display/images/display.png" height="25">
            </a>
          </td>
          <td>{$lot.lot_date}</td>
          <td>{$lot.sample_number}</td>
        </tr>
        {/foreach}
      </tbody>
    </table>
  </div>
</div>
{/if}