<link rel="stylesheet" href="display/javascript/treeview/treeview.css">
<script src="display/javascript/treeview/treeview.js"></script>
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
        data: { "module": "documentExternalGetList", "uid": 45, "folder": folder },
        method: "POST",

      } ).done( function ( content ) {
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
            html += '<span class="glyphicon glyphicon-folder-open folder">&nbsp;</span>';
          }
          html += value.name + '</label>';
          if (value.folder) {
            html += '<div id="div-file' + value.id + '"></div>';
          }
          html += '</li>';
        } );
        html += "</ul>";
        console.log(object);
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
        $( ".folder" ).on( "click", function() {
      var id = $(this).attr("id");
      getList(id);
    });
      } );
    };
  } );
</script>
<form id="fileExternal" method="post" action="index.php">
  <input type="hidden" name="uid" value="{$data.uid}">
  <input type="hidden" name="module" value="documentExternalAdd">
  <div id="treeview">
    <ul class="treeview" id="root">
      <li>
        <input class="treeview-folder folder" type="checkbox" name="root" id="root-input" value="/">
        <label for="root-input" class="custom-unchecked">
          <span class="glyphicon glyphicon-folder-open"></span>
          /
        </label>
        <div id="div-root-input"></div>
      </li>
    </ul>
    <ul>
      <li>
        <input type="checkbox" name="tall-1" id="tall-1">
        <label for="tall-1" class="custom-unchecked">Buildings</label>
      </li>
      <li>
        <input type="checkbox" name="tall-2" id="tall-2">
        <label for="tall-2" class="custom-unchecked">Giants</label>
        <ul>
          <li>
            <input type="checkbox" name="tall-2-1" id="tall-2-1">
            <label for="tall-2-1" class="custom-unchecked">Andre</label>
          </li>
          <li class="last">
            <input type="checkbox" name="tall-2-2" id="tall-2-2">
            <label for="tall-2-2" class="custom-unchecked">Paul Bunyan</label>
          </li>
        </ul>
      </li>
      <li class="last">
        <input type="checkbox" name="tall-3" id="tall-3">
        <label for="tall-3" class="custom-unchecked">Two sandwiches</label>
      </li>
    </ul>
    </li>
    <li class="last">
      <input type="checkbox" name="short" id="short">
      <label for="short" class="custom-unchecked">Short Things</label>

      <ul>
        <li>
          <input type="checkbox" name="short-1" id="short-1">
          <label for="short-1" class="custom-unchecked">Smurfs</label>
        </li>
        <li>
          <input type="checkbox" name="short-2" id="short-2">
          <label for="short-2" class="custom-unchecked">Mushrooms</label>
        </li>
        <li class="last">
          <input type="checkbox" name="short-3" id="short-3">
          <label for="short-3" class="custom-unchecked">One Sandwich</label>
        </li>
      </ul>
    </li>
    </ul>
  </div>
</form>
