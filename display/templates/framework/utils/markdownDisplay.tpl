<script src="display/node_modules/markdown-it/dist/markdown-it.min.js"></script>
<script src="display/node_modules/markdown-it-attrs/markdown-it-attrs.browser.js"></script>
<script>
  $(document).ready(function () {
    var md = window.markdownit();
    md.use(markdownItAttrs);
    var content = md.render(`{$markdownContent}`);
    var contentId = document.getElementById("content");
    contentId.innerHTML = content;
    $( '.datatable-nopaging' ).DataTable( {
			"language": dataTableLanguage,
			"paging": false,
			"searching": true
		} );
   });
</script>
<div class="col-md-8 col-lg-6">
<div id="content"></div>
</div>
