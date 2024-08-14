<h2>{t}Création - Modification d'un prêt{/t}</h2>
<script>
    $(document).ready(function(){
        $("#borrowingForm").submit(function(event) {
		 var format = "{$formatdatetime}";
            /*
            * Control dates
            */
			var bd = moment($("#borrowing_date").val(), format);
            var ser = $("#expected_return_date").val();
            if (ser.length > 0) {
                var er = moment(ser, format);
                if (bd.isAfter(er)) {
                    alert("{t}La date prévue de retour est antérieure à la date de prêt{/t}");
                    event.preventDefault();
                }
            }
            var srd = $("#return_date").val();
            if (srd.length > 0) {
                var rd = moment(srd, format);
                if (bd.isAfter(rd)) {
                    alert("{t}La date de retour est antérieure à la date de prêt{/t}");
                    event.preventDefault();
                }
            }
	    });
     });
</script>
<div class="row">

    <div class="col-md-6">
            <a href="{$moduleListe}">
            <img src="display/images/list.png" height="25">
            {t}Retour à la liste{/t}
            </a>
            <a href="{$moduleParent}Display?uid={$object.uid}&activeTab={$activeTab}">
            <img src="display/images/edit.gif" height="25">
            {t}Retour au détail{/t} ({$object.uid} {$object.identifier})
            </a>
        <form class="form-horizontal " id="borrowingForm" method="post" action="{$moduleParent}borrowingWrite">
            <input type="hidden" name="moduleBase" value="borrowing">
            <input type="hidden" name="moduleBase" value="{$moduleParent}borrowing">
            <input type="hidden" name="borrowing_id" value="{$data.borrowing_id}">
            <input type="hidden" name="uid" value="{$data.uid}">
            <input type="hidden" name="activeTab" value="{$activeTab}">

            <div class="form-group" >
                <label for="borrower_id"class="control-label col-md-4">
                     {t}Emprunteur :{/t}<span class="red">*</span>
                </label>
                <div class="col-md-8">
                    <select id="borrower_id" name="borrower_id" class="form-control">
                        {foreach $borrowers as $borrower}
                            <option value="{$borrower.borrower_id}" {if $data.borrower.id == $borrower.borrower_id}selected{/if}>
                                {$borrower.borrower_name}
                            </option>
                        {/foreach}
                    </select>
                </div>
            </div>
            <div class="form-group" >
                <label for="borrowing_date" class="control-label col-md-4">{t}Date d'emprunt :{/t}<span class="red">*</span></label>
                <div class="col-md-8">
                    <input id="borrowing_date" name="borrowing_date" value="{$data.borrowing_date}" class="form-control datepicker" >
                </div>
            </div>
            <div class="form-group" >
                <label for="expected_return_date" class="control-label col-md-4">{t}Date de retour escomptée :{/t}</label>
                <div class="col-md-8">
                    <input id="expected_return_date" name="expected_return_date" value="{$data.expected_return_date}" class="form-control datepicker" >
                </div>
            </div>
            <div class="form-group" >
                    <label for="return_date" class="control-label col-md-4">{t}Date de retour réelle :{/t}</label>
                    <div class="col-md-8">
                        <input id="return_date" name="return_date" value="{$data.return_date}" class="form-control datepicker" >
                    </div>
                </div>
            <div class="form-group center">
                    <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
                    {if $data.borrower_id > 0 }
                    <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
                    {/if}
            </div>
      {$csrf}</form>
  </div>
</div>
<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>