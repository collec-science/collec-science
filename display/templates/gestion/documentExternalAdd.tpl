<link rel="stylesheet" href="display/node_modules/jstree/dist/themes/default/style.min.css">
<script src="display/node_modules/jstree/dist/jstree.min.js"></script>
<script>
  $( document ).ready( function () {
    $( '#jstree' ).jstree( {

      "plugins": [  "checkbox", "sort", "search", "json_data", "wholerow" ],
      /*"core" : {
        "data" : [{ "id": "root", "text" : "racine", "children" : [], 'state': "selected" }]
      },*/
      'json_data' : {
        "ajax" : {
          'url' : function( node ) {
            return 'index.php';
          },
          'dataType': 'json',
          'data' : function (node) {
            return {
              'path' : node.id,
              'module' : 'documentExternalGetList',
              'uid' : '{$data.uid}'
              };
          },
          "success" : function(ops) {
            console.log(ops);
             data = []
                  // go through data and create an array of objects to be given
                  // to jsTree just like when you're creating a static jsTree.
                  for( opnum in ops ){
                    var op = ops[opnum]
                    node = {
                        "data" : op.info,
                        "metadata" :  op ,
                        "state" : "closed"
                    }
                    data.push( node );
                  }
                  return data;
          }
        }
      }
    });
  } );
</script>
<form id="fileExternal" method="post" action="index.php">
  <input type="hidden" name="uid" value="{$data.uid}">
  <input type="hidden" name="module" value="documentExternalAdd">
<div id="jstree"></div>
</form>
