<script>
$(document).ready(function() {
	function toHex(txt){
		const encoder = new TextEncoder();
		return Array
			.from(encoder.encode(txt))
			.map(b => b.toString(16).padStart(2, '0'))
			.join('')
	}
	$("#suppr").bind("click keyup", function (event) {
		if (confirm("{t}Confirmez la suppression de la requête{/t}")) {
			$("#requestForm").attr("action", "requestDelete");
			$("#requestForm").submit();
		}
	});
	$("#exec").bind("click keyup", function (event) {
		$("#requestForm").attr("action", "requestExec");
		$("#requestForm").submit();
	});
	$("#saveExec").bind("click keyup", function (event) {
		$("#requestForm").attr("action", "requestWriteExec");
		$("#bodySent").val(toHex ($("#body").val() ) );
		$("#requestForm").submit();
	});
	$("#save").bind("click keyup", function (event) {
		$("#requestForm").attr("action", "requestWrite");
		$("#bodySent").val(toHex ($("#body").val() ) );
		$("#requestForm").submit();
	});
	$(".modif").change(function() {
		$("#exec").prop("disabled", true);
	});
});
</script>
<div class="row">
	<div class="col-lg-8 col-md-12">
		<a href="requestList">
			<img src="display/images/list.png" height="25">
			{t}Retour à la liste{/t}
		</a>
		&nbsp;
		<a href="dbstructureSchema" target="_blank">
			<img src="display/images/pdf.png" height="25">
			{t}Structure de la base de données{/t}</a>


		<form class="form-horizontal " id="requestForm" method="post" action="">
			<input type="hidden" id="moduleBase" name="moduleBase" value="request">
			<input type="hidden" name="request_id" value="{$data.request_id}">
			<input type="hidden" name="body" id="bodySent">
			<div class="form-group">
				<label for="title" class="control-label col-md-4">
					{t}Description de la requête :{/t} <span class="red">*</span>
				</label>
				<div class="col-md-8">
					<input class="form-control modif" id="title" name="title" type="text" value="{$data.title}" required autofocus/>
				</div>
			</div>
			<div class="form-group">
				<label for="collection_id" class="control-label col-md-4">{t}Collection autorisée :{/t}</label>
				<div class="col-md-8">
					<select class="form-control modif" id="collection_id" name="collection_id">
						<option value="" {if $data.collection_id == ""}selected{/if}>{t}Choisissez...{/t}</option>
						{foreach $collections as $collection}
							<option value="{$collection.collection_id}" {if $data.collection_id == $collection.collection_id}selected{/if}>{$collection.collection_name}</option>
						{/foreach}
					</select>
				</div>
			</div>
			<div class="form-group">
				<label for="body" class="control-label col-md-4"><span class="red">*</span> {t}Code SQL :{/t}</label>
				<div class="col-md-8">
					<textarea id="body" class="form-control modif" cols="70" rows="10" wrap="soft" required>{$data.body}</textarea>
				</div>
			</div>
			<div class="form-group">
				<label for="datefields" class="control-label col-md-4">{t}Champs dates de la requête (séparés par une virgule) :{/t}</label>
				<div class="col-md-8">
					<input class="form-control modif"  name="datefields" value="{$data.datefields}" placeholder="sampling_date,sample_creation_date">
				</div>
			</div>
			<div class="form-group">
				<label for="create_date" class="control-label col-md-4">{t}date de création :{/t}</label>
				<div class="col-md-8">
					<input id="create_date" class="form-control" name="create_date" value="{$data.create_date}" readonly>
				</div>
			</div>
			<div class="form-group">
				<label for="login" class="control-label col-md-4">{t}par :{/t}</label>
				<div class="col-md-8">
					<input id="login" class="form-control" name="login" value="{$data.login}" readonly>
				</div>
			</div>
			<div class="form-group">
			<label for="last_exec" class="control-label col-md-4">{t}Date de dernière exécution :{/t}</label>
				<div class="col-md-8">
					<input id="last_exec" class="form-control" name="last_exec" value="{$data.last_exec}" readonly>
				</div>
			</div>

			<div class="form-group">
				<div class="col-md-12 center">
					<button type="submit" class="btn btn-primary button-valid" id="save">{t}Enregistrer{/t}</button>
					{if $data.request_id > 0}
						<button type="submit" class="btn btn-primary button-valid" id="saveExec">{t}Enregistrer et exécuter{/t}</button>
						<button type="submit" class="btn btn-primary button-valid" id="exec">{t}Exécuter{/t}</button>
						<button type="submit" class="btn btn-danger" id="suppr">{t}Supprimer{/t}</button>
					{/if}
				</div>
			</div>
		{$csrf}</form>
	</div>
</div>
{if !empty($result)}
	<div class="row">
		<div class="col-lg-12">
			<table id="crequestList" class="table table-bordered table-hover datatable-export display">
				<thead>
					<tr>
					{foreach $result[0] as $key=>$value}
						<th>{$key}</th>
					{/foreach}
					</tr>
				</thead>
				<tbody>
					{foreach $result as $line}
						<tr>
							{foreach $line as $value}
								<td>{$value}</td>
							{/foreach}
						</tr>
					{/foreach}
				</tbody>
			</table>
		</div>
	</div>
	{else}
	{t}Aucun résultat n'a été retourné par la requête{/t}
{/if}
