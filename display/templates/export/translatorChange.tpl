<script>
  $(document).ready(function() {
    var nameid = 10000;
    $(".name").change(function () {
      var lasttr = $('#tableitems tr').last();
      var name = $(lasttr).find(".name").val();
      if (name.length > 0) {
        var content = "<tr id='tr"+nameid+"'><td><input class='name form-control' id='name"+nameid+"' name='name[]' value=''></td><td><input class='value form-control' id='value"+nameid+"' name='value[]' value=''></td></tr>";
        nameid ++;
        $("#tableitems").last().append(content);
      }
    })
  });
</script>
<h2>{t}Modification d'un traducteur{/t}</h2>
<div class="row">
  <div class="col-md-12">
    <a href="index.php?module=translatorList">
      <img src="display/images/list.png" height="25">
      {t}Retour à la liste{/t}
    </a>
  </div>
</div>
<div class="row">
  <div class="col-md-6">
    <form id="translatorId" class="form-horizontal" action="index.php" method="POST">
      <input type="hidden" name="moduleBase" value="translator">
      <input type="hidden" name="action" value="Write">
      <input type="hidden" name="translator_id" value="{$data.translator_id}">
      <div class="form-group center">
        <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
      </div>
      <div class="form-group">
        <label for="translatorName"  class="control-label col-md-4"><span class="red">*</span> {t}Nom :{/t}</label>
        <div class="col-md-8">
          <input id="translatorName" type="text" class="form-control" name="translator_name" value="{$data.translator_name}" autofocus required>
        </div>
      </div>
      <table class="table table-bordered datatable-nopaging" id="tableitems">
        <thead>
          <tr>
            <th>{t}Libellé dans la base de données{/t}</th>
            <th>{t}Libellé exporté{/t}</th>
          </tr>
        </thead>
        <tbody>
          {$nameid = 0}
          {foreach $items as $name => $value}
          <tr id="tr{$nameid}">
            <td>
              <input class="name form-control" id="name{$nameid}" name="name[]" value="{$name}">
            </td>
            <td>
              <input class="value form-control" id="value{$nameId}" name="value[]" value="{$value}">
            </td>
            {$nameid ++}
          </tr>
          {/foreach}
          <tr id="tr{$nameid}">
            <td>
              <input class="name form-control" id="name{$nameid}" name="name[]" value="">
            </td>
            <td>
              <input class="value form-control" id="value{$nameid}" name="value[]" value="">
            </td>
          </tr>
        </tbody>
      </table>
      <div class="form-group center">
        <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
        {if $data.translator_id > 0 }
          <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
        {/if}
      </div>
    </form>
  </div>
</div>