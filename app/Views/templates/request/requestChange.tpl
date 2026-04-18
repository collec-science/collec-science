<script>
	$(document).ready(function () {
		function toHex(txt) {
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
		$("#execcsv").bind("click keyup", function (event) {
			$("#requestForm").attr("action", "requestExecCsv");
			$("#requestForm").submit();
		});
		$("#saveExec").bind("click keyup", function (event) {
			$("#requestForm").attr("action", "requestWriteExec");
			$("#bodySent").val(toHex($("#body").val()));
			$("#requestForm").submit();
		});
		$("#save").bind("click keyup", function (event) {
			$("#requestForm").attr("action", "requestWrite");
			$("#bodySent").val(toHex($("#body").val()));
			$("#requestForm").submit();
		});
		$(".modif").change(function () {
			$("#exec").prop("disabled", true);
			$("#execcsv").prop("disabled", true);
		});
	});
</script>
<div class="container-fluid">
	<div class="row">
		<a href="requestList">
			<img src="display/images/list.png" height="25">
			{t}Retour à la liste{/t}
		</a>
		&nbsp;
		<a href="dbstructureSchema" target="online-help">
			<img src="display/images/pdf.png" height="25">
			{t}Structure de la base de données{/t}</a>
	</div>
	<div class="row">
		<form class="form-horizontal " id="requestForm" method="post" action="">
			<input type="hidden" id="moduleBase" name="moduleBase" value="request">
			<input type="hidden" name="request_id" value="{$data.request_id}">
			<input type="hidden" name="body" id="bodySent">
			<div class="row">
				<label for="title" class="form-label col-4">
					{t}Description de la requête :{/t} <span class="red">*</span>
				</label>
				<div class="col-8">
					<input class="form-control modif" id="title" name="title" type="text" value="{$data.title}" required autofocus />
				</div>
			</div>
			<div class="row">
				<label for="collection_id" class="form-label col-4">{t}Collection autorisée :{/t}</label>
				<div class="col-8">
					<select class="form-select modif" id="collection_id" name="collection_id">
						<option value="" {if $data.collection_id=="" }selected{/if}>{t}Choisissez...{/t}</option>
						{foreach $collections as $collection}
						<option value="{$collection.collection_id}" {if $data.collection_id==$collection.collection_id}selected{/if}>{$collection.collection_name}</option>
						{/foreach}
					</select>
				</div>
			</div>
			<div class="row">
				<label for="body" class="form-label col-4"><span class="red">*</span> {t}Code SQL :{/t}</label>
				<div class="col-8">
					<textarea id="body" class="form-control modif" cols="70" rows="10" wrap="soft" required>{$data.body}</textarea>
				</div>
			</div>
			<div class="row">
				<label for="datefields" class="form-label col-4">{t}Champs dates de la requête (séparés par une virgule) :{/t}</label>
				<div class="col-8">
					<input class="form-control modif" name="datefields" value="{$data.datefields}" placeholder="sampling_date,sample_creation_date">
				</div>
			</div>
			<div class="row">
				<label for="create_date" class="form-label col-4">{t}date de création :{/t}</label>
				<div class="col-8">
					<input id="create_date" class="form-control" name="create_date" value="{$data.create_date}" readonly>
				</div>
			</div>
			<div class="row">
				<label for="login" class="form-label col-4">{t}par :{/t}</label>
				<div class="col-8">
					<input id="login" class="form-control" name="login" value="{$data.login}" readonly>
				</div>
			</div>
			<div class="row">
				<label for="last_exec" class="form-label col-4">{t}Date de dernière exécution :{/t}</label>
				<div class="col-8">
					<input id="last_exec" class="form-control" name="last_exec" value="{$data.last_exec}" readonly>
				</div>
			</div>
			<div class="row d-flex justify-content-center">
				<div class="col-auto">
					<button type="submit" class="btn btn-primary button-valid" id="save">{t}Enregistrer{/t}</button>
				</div>
				{if $data.request_id > 0 }
				<div class="col-auto">
					<button type="submit" class="btn btn-primary button-valid" id="saveExec">{t}Enregistrer et exécuter{/t}</button>
				</div>
				<div class="col-auto"><button type="submit" class="btn btn-primary button-valid" id="saveExec">{t}Enregistrer et exécuter{/t}</button>
				</div>
				<div class="col-auto"><button type="submit" class="btn btn-primary button-valid" id="execcsv">{t}Exécuter avec export CSV direct{/t}</button>
				</div>
				<div class="col-auto">
					<button class="btn btn-danger" id="suppr">{t}Supprimer{/t}</button>
				</div>
				{/if}
			</div>
			{$csrf}
		</form>
	</div>
	{if !empty($result)}
	<div class=" row">
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
	{else}
	{t}Aucun résultat n'a été retourné par la requête{/t}
	{/if}
</div>