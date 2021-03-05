<script src="display/node_modules/markdown-it/dist/markdown-it.min.js"></script>
<script>
  $(document).ready(function () {
    var md = window.markdownit();
    var content = md.render(`{$markdownContent}`);
    var contentId = document.getElementById("content");
    contentId.innerHTML = content;
   });
</script>
<div class="col-md-8 col-lg-6">
<div id="content"></div>
</div>
