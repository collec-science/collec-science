<script>
    $(document).ready(function () {
    var myStorage = window.localStorage;
    var defaults = {};
      try {
      defaults =JSON.parse( myStorage.getItem("campaignImportParameters"));
      Object.keys(defaults).forEach(key=>{
          $("#"+key).val(defaults[key]);
    });
      } catch (Exception) {
      }
      $("#campaignImport").submit(function(e) { 
          defaults = {
                "separator": $("#separator").val(),
                "encoding": $("#encoding").val()
          };;
          myStorage.setItem("campaignImportParameters", JSON.stringify(defaults));
      });
    });
</script>
<h2>{t}Campagnes de prélèvement{/t}</h2>
<div class="row">
    <div class="col-md-6">
        {if $rights.param == 1}
        <a href="campaignChange?campaign_id=0">
            {t}Nouveau...{/t}
        </a>
        {/if}
        <table id="campaignList" class="table table-bordered table-hover datatable ">
            <thead>
                <tr>
                    <th>{t}Nom{/t}</th>
                    <th>{t}Id{/t}</th>
                    <th>{t}Responsable{/t}</th>
                    <th>{t}du{/t}</th>
                    <th>{t}au{/t}</th>
                    <th class="lexical" data-lexical="uuid">{t}UUID{/t}</th>
                    {if $rights.param == 1}
                    <th>{t}Modifier{/t}</th>
                    {/if}
                </tr>
            </thead>
            <tbody>
                {foreach $data as $row}
                <tr>
                    <td>
                        <a href="campaignDisplay?campaign_id={$row.campaign_id}">
                            {$row.campaign_name}
                        </a>
                    </td>
                    <td class="center">{$row.campaign_id}</td>
                    <td >{$row.referent_name} {$row.referent_firstname}</td>
                    <td class="center nowrap">{$row.campaign_from}</td>
                    <td class="center nowrap">{$row.campaign_to}</td>
                    <td class="nowrap">{$row.uuid}</td>
                    {if $rights.param == 1}
                    <td class="center">
                        <a href="campaignChange?campaign_id={$row.campaign_id}"
                            title="{t}Modifier{/t}">
                            <img src="display/images/edit.gif" height="25" alt="{t}Modifier{/t}">
                        </a>
                    </td>
                    {/if}
                </tr>
                {/foreach}
            </tbody>
        </table>
    </div>
</div>
<div class="row">
    <fieldset class="col-md-6">
        <legend>{t}Importer une liste de campagnes à partir d'un fichier CSV{/t}</legend>
        <form class="form-horizontal" id="campaignImport" method="post" action="index.php"
            enctype="multipart/form-data">
            <input type="hidden" name="module" value="campaignImport" required>
            <div class="form-group">
                <label for="upfile" class="control-label col-md-4"><span class="red">*</span> 
                    {t}Nom du fichier à importer :{/t}
                </label>
                <div class="col-md-8">
                    <input type="file" name="upfile" class="form-control" required>
                </div>
            </div>
            <div class="form-group">
                <label for="separator" class="control-label col-md-4">{t}Séparateur utilisé :{/t}</label>
                <div class="col-md-8">
                      <select id="separator" name="separator" class="form-control">
                            <option value=",">{t}Virgule{/t}</option>
                            <option value=";">{t}Point-virgule{/t}</option>
                            <option value="tab">{t}Tabulation{/t}</option>
                      </select>
                </div>
          </div>
          <div class="form-group">
                <label for="encoding" class="control-label col-md-4">{t}Encodage du fichier :{/t}</label>
                <div class="col-md-8">
                      <select id="encoding" name="utf8_encode" class="form-control">
                            <option value="0" >UTF-8</option>
                            <option value="1" >ISO-8859-x</option>
                      </select>
                </div>
          </div>
            <div class="form-group center">
                <button type="submit" class="btn btn-primary">{t}Importer les nouvelles campagnes{/t}</button>
            </div>
            <div class="bg-info">
                {t}Description du fichier :{/t}
                <ul>
                    <li>{t}campaign_name : nom de la campagne (obligatoire){/t}</li>
                    <li>{t}campaign_from : date de début de la campagne, sous la forme yyyy-mm-dd{/t}</li>
                    <li>{t}campaign_to : date de fin de la campagne, sous la forme yyyy-mm-dd{/t}</li>
                    <li>{t}referent_name : nom du responsable de la campagne. S'il n'existe pas dans la liste des référents, il sera créé{/t}</li>
                    <li>{t}referent_firstname : prénom du responsable de la campagne{/t}</li>
                    <li>{t}uuid : identifiant de type UUID, si existant{/t}</li>
                </ul>
            </div>
        {$csrf}</form>
    </fieldset>
</div>