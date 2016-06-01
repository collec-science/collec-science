<table id="exampleSearch" class="tableaffichage">
<form method="GET" action="index.php">
<input type="hidden" name="module" value="personnelListe">
<input type="hidden" name="isSearch" value="1">
<tr>
<td>
name :
<input name="comment" value="{$exampleSearch.comment}" maxlength="50" size="30">
<br>
date : 
<input name="dateExample" value="{$exampleSearch.dateExample}" >
<br>
<div style="text-align:center;">
<input type="submit" name="Search...">
</div>
</td>
</tr>
</form>
</table>
