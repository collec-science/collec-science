{* Paramètres > Sous-échantillonnage > Nouveau > *}
<div class="container">
<h2>{t}Création - Modification d'un type de sous-échantillonnage{/t}</h2>
<div class="row">
<div class="col-6">
<a href="multipleTypeList">{t}Retour à la liste{/t}</a>

<form class="form-horizontal " id="multipleTypeForm" method="post" action="multipleTypeWrite">
<input type="hidden" name="moduleBase" value="multipleType">
<input type="hidden" name="multiple_type_id" value="{$data.multiple_type_id}">
<div class="row">
<label for="multipleTypeName"  class="form-label col-4"><span class="red">*</span> {t}Nom :{/t}</label>
<div class="col-8">
<input id="multipleTypeName" type="text" class="form-control" name="multiple_type_name" value="{$data.multiple_type_name}" autofocus required></div>
</div>
<div class="row center">
      <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
      {if $data.multiple_type_id > 0 }
      <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
      {/if}
 </div>
{$csrf}</form>
</div>
</div>
	<div class="row col-12 d-inline">
		<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>
	</div>