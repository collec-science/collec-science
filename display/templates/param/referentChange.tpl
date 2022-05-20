<h2>{t}Création - Modification d'un référent{/t}</h2>
<div class="row">
<div class="col-md-6">
<a href="index.php?module=referentList">{t}Retour à la liste{/t}</a>

<form class="form-horizontal protoform" id="referentForm" method="post" action="index.php">
<input type="hidden" name="moduleBase" value="referent">
<input type="hidden" name="action" value="Write">
<input type="hidden" name="referent_id" value="{$data.referent_id}">
<div class="form-group">
<label for="referentName"  class="control-label col-md-4"><span class="red">*</span> {t}Nom :{/t}</label>
<div class="col-md-8">
<input id="referentName" type="text" class="form-control" name="referent_name" value="{$data.referent_name}" autofocus required></div>
</div>
<div class="form-group">
<label for="firstname"  class="control-label col-md-4"> {t}Prénom :{/t}</label>
<div class="col-md-8">
<input id="firstname" class="form-control" name="referent_firstname" value="{$data.referent_firstname}"></div>
</div>
<div class="form-group">
<label for="referent_organization"  class="control-label col-md-4"> {t}Organisme :{/t}</label>
<div class="col-md-8">
<input id="referent_organization" class="form-control" name="referent_organization" value="{$data.referent_organization}"></div>
</div>
<div class="form-group">
<label for="referentEmail"  class="control-label col-md-4"> {t}Mail :{/t}</label>
<div class="col-md-8">
<input id="referentEmail" type="email" class="form-control" name="referent_email" value="{$data.referent_email}"></div>
</div>
<div class="form-group">
<label for="referentPhone"  class="control-label col-md-4"> {t}Téléphone :{/t}</label>
<div class="col-md-8">
<input id="referentPhone" type="text" class="form-control" name="referent_phone" value="{$data.referent_phone}"></div>
</div>
<div class="form-group">
<label for="academical_directory"  class="control-label col-md-4"> {t}Annuaire académique utilisé :{/t}</label>
<div class="col-md-8">
<input id="academical_directory" class="form-control" name="academical_directory" value="{$data.academical_directory}" placeholder="https://orcid.org"></div>
</div>
<div class="form-group">
<label for="academical_link"  class="control-label col-md-4"> {t}Lien académique :{/t}</label>
<div class="col-md-8">
<input id="academical_link" class="form-control" name="academical_link" value="{$data.academical_link}" placeholder="https://orcid.org/0000-0003-4207-4107"></div>
</div>
<fieldset>
<legend>{t}Adresse postale{/t}</legend>
<div class="form-group">
<label for="addressName"  class="control-label col-md-4"> {t}Nom :{/t}</label>
<div class="col-md-8">
<input id="addressName" type="text" class="form-control" name="address_name" value="{$data.address_name}"></div>
</div>
<div class="form-group">
<label for="addressLine2"  class="control-label col-md-4"> {t}Seconde ligne :{/t}</label>
<div class="col-md-8">
<input id="addressLine2" type="text" class="form-control" name="address_line2" value="{$data.address_line2}"></div>
</div>
<div class="form-group">
<label for="addressLine3"  class="control-label col-md-4"> {t}Troisième ligne :{/t}</label>
<div class="col-md-8">
<input id="addressLine3" type="text" class="form-control" name="address_line3" value="{$data.address_line3}"></div>
</div>
<div class="form-group">
<label for="addressCity"  class="control-label col-md-4"> {t}Code postal et ville :{/t}</label>
<div class="col-md-8">
<input id="addressCity" type="text" class="form-control" name="address_city" value="{$data.address_city}"></div>
</div>
<div class="form-group">
<label for="addressCountry"  class="control-label col-md-4"> {t}Pays :{/t}</label>
<div class="col-md-8">
<input id="addressCountry" type="text" class="form-control" name="address_country" value="{$data.address_country}"></div>
</div>
</fieldset>


<div class="form-group center">
      <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
      {if $data.referent_id > 0 }
      <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
      {/if}
 </div>
</form>
</div>
</div>
<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>
