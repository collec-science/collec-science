	<div class="col-sm-6">
	<div class="form-horizontal protoform">
	<div class="form-group">
	<label for="login" class="control-label col-sm-4">
	{t}Login :{/t}
	</label>
	<div class="col-sm-8"> 
	<input class="form-control" name="login" id="login" maxlength="32" required autofocus>
	</div>
	</div>
	<div class="form-group">
	<label for="login" class="control-label col-sm-4">
	{t}Mot de passe :{/t}
	</label>
	<div class="col-sm-8">
	<input  class="form-control" name="password" id="password" type="password" autocomplete="off" required maxlength="32">
	</div>
	</div>
	<div class="form-group center">
	<form id="theForm" method="POST" action="index.php">
	<input type="hidden" name="module" value="{$module}">
	<input type="hidden" id="hiddenUsername" name="loginAdmin"/>
 	<input type="hidden" id="hiddenPassword" name="password"/>
    <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>	
	</form>

	</div>
	</div>
</div>

<script>
  $("#theForm").submit(function() {
    $("#hiddenUsername").val($("#login").val());
    $("#hiddenPassword").val($("#password").val());
  });
  $("#login,#password").keypress(function(e) {
    if (e.which == 13) {
      $("#theForm").submit();
    }
  });
</script>