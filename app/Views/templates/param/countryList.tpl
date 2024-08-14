<h2>{t}Liste des pays{/t}</h2>
<div class="row">
	<div class="col-md-8">
		<table id="countryList" class="table table-bordered table-hover datatable-searching " data-order='[[1,"asc"]]'>
			<thead>
				<tr>
					<th>{t}Code numérique{/t}</th>
					<th>{t}Nom du pays{/t}</th>
					<th>{t}Code (2 positions){/t}</th>
					<th>{t}Code (3 positions){/t}</th>
				</tr>
			</thead>
      <tbody>
        {foreach $countries as $country}
          <tr>
            <td>{$country.country_id}</td>
            <td>{$country.country_name}</td>
            <td>{$country.country_code2}</td>
            <td>{$country.country_code3}</td>
          </tr>
        {/foreach}
      </tbody>
    </table>
  </div>
</div>
