<link rel="stylesheet" href="display/javascript/treeview/treeview.css">
<!--script src="display/javascript/treeview/treeview.js"></!--script-->
<script>
  $( document ).ready( function () {

    $( ".folder" ).on( "click", function() {
      var id = $(this).attr("id");
      console.log(this);
      getList(id);
    });
    function getList(object) {
      var folder = $("#"+object).val();
      $.ajax( {
        url: "index.php",
        data: { "module": "documentExternalGetList", "uid": "{$data.uid}", "path": folder },
        method: "POST",

      } ).done( function ( content ) {
        if ( content && content.length > 2){
          $(".fields").show();
          var obj = JSON.parse( content );
          var html = '<ul>';
          obj.forEach( function ( value ) {
            html += '<li><input type="checkbox" class="treeview-checkbox';
              if (value.folder) {
                html += ' folder';
              }
              html += '"';
            if ( !value.folder ) {
              html += ' name="files[]"';
            }
            html += ' id="file' + value.id + '" value="' + value.value + '">';
            html += '<label for="file' + value.id + '" class="custom-unchecked">';
            if ( value.folder ) {
              html += '<span class="glyphicon glyphicon-folder-open folder blue">&nbsp;</span>';
            }
            html += value.name + '</label>';
            if (value.folder) {
              html += '<div id="div-file' + value.id + '"></div>';
            }
            html += '</li>';
          } );
          html += "</ul>";
          $( "#div-"+object ).html( html );
          $( function () {
            $( 'input[type="checkbox"]' ).change( checkboxChanged );

            function checkboxChanged() {
              var $this = $( this ),
                checked = $this.prop( "checked" ),
                container = $this.parent(),
                siblings = container.siblings();

              container.find( 'input[type="checkbox"]' )
                .prop( {
                  indeterminate: false,
                  checked: checked
                } )
                .siblings( 'label' )
                .removeClass( 'custom-checked custom-unchecked custom-indeterminate' )
                .addClass( checked ? 'custom-checked' : 'custom-unchecked' );

              checkSiblings( container, checked );
            }

            function checkSiblings( $el, checked ) {
              var parent = $el.parent().parent(),
                all = true,
                indeterminate = false;

              $el.siblings().each( function () {
                return all = ( $( this ).children( 'input[type="checkbox"]' ).prop( "checked" ) === checked );
              } );

              if ( all && checked ) {
                parent.children( 'input[type="checkbox"]' )
                  .prop( {
                    indeterminate: false,
                    checked: checked
                  } )
                  .siblings( 'label' )
                  .removeClass( 'custom-checked custom-unchecked custom-indeterminate' )
                  .addClass( checked ? 'custom-checked' : 'custom-unchecked' );

                checkSiblings( parent, checked );
              }
              else if ( all && !checked ) {
                indeterminate = parent.find( 'input[type="checkbox"]:checked' ).length > 0;

                parent.children( 'input[type="checkbox"]' )
                  .prop( "checked", checked )
                  .prop( "indeterminate", indeterminate )
                  .siblings( 'label' )
                  .removeClass( 'custom-checked custom-unchecked custom-indeterminate' )
                  .addClass( indeterminate ? 'custom-indeterminate' : ( checked ? 'custom-checked' : 'custom-unchecked' ) );

                checkSiblings( parent, checked );
              }
              else {
                $el.parents( "li" ).children( 'input[type="checkbox"]' )
                  .prop( {
                    indeterminate: true,
                    checked: false
                  } )
                  .siblings( 'label' )
                  .removeClass( 'custom-checked custom-unchecked custom-indeterminate' )
                  .addClass( 'custom-indeterminate' );
              }
            }
          } );
        }
        $( ".folder" ).on( "click", function() {
          if (! $(this).data("isSearched")) {
            $(this).data("isSearched", true);
            var id = $(this).attr("id");
            getList(id);
          }
        });
      } );
    };
  } );
</script>
<fieldset>
  <legend>{t}Fichiers externes à associer avec l'échantillon{/t}</legend>
  <form id="fileExternal" class="form-horizontal" method="post" action="index.php">
    <input type="hidden" name="uid" value="{$data.uid}">
    <input type="hidden" name="module" value="documentExternalAdd">
    <div class="form-group fields" hidden>
			<label for="document_description_external" class="control-label col-md-4">
				{t}Description :{/t} </label>
			<div class="col-md-8">
				<input id="document_description_external" name="document_description" class="form-control">
			</div>
		</div>
		<div class="form-group fields" hidden>
			<label for="document_creation_date_external" class="control-label col-md-4">
				{t}Date de création des documents :{/t} </label>
			<div class="col-md-8">
				<input id="document_creation_date_external" name="document_creation_date"
					class="form-control date">
			</div>
		</div>
    <div class="form-group">
    <label for="root" class="control-label col-md-4">
				{t}Fichiers à associer :{/t} </label>
      <div id="treeview" class="col-md-8">
        <ul class="treeview" id="root">
          <li>
            <input class="treeview-folder folder" type="checkbox" name="root" id="root-input" value="/">
            <label for="root-input" class="custom-unchecked">
              <span class="glyphicon glyphicon-folder-open blue"></span>
              /
            </label>
            <div id="div-root-input"></div>
          </li>
        </ul>
      </div>
    </div>
    <div class="form-group center fields" hidden>
      <button type="submit" class="btn btn-primary button-valid">{t}Associer les fichiers sélectionnés{/t}</button>
    </div>
  </form>
</fieldset>
