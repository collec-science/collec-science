	<table class="tablesaisie">
	<tr>
	<td>{$LANG.login.0} :</td>
	<td> <input name="login" id="login" maxlength="32" required autofocus></td>
	</tr>
	<tr><td>
	{$LANG.login.1} :</td><td>
	<input name="password" id="password" type="password" autocomplete="off" required maxlength="32"></td>
	</tr>
	<tr>
	<td colspan="2" class="center">
	<form id="theForm" method="POST" action="index.php">
	<input type="hidden" name="module" value={$module}>
		
  <input type="hidden" id="hiddenUsername" name="login"/>
  <input type="hidden" id="hiddenPassword" name="password"/>
  {if $tokenIdentityValidity > 0}
  {$duration = $tokenIdentityValidity / 3600}
  {$LANG.login.46} {$duration} {$LANG.login.47} 
  <input type="checkbox" name="loginByTokenRequested" value="1" checked>
  <br>
  {/if}
	<input type="submit">
	</form>
	
	</td>
	</tr>
	</table>

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
