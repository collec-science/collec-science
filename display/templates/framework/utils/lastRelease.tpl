<script src="display/node_modules/markdown-it/dist/markdown-it.min.js"></script>
<script src="display/node_modules/markdown-it-attrs/markdown-it-attrs.browser.js"></script>
<script>
    $( document ).ready( function () {
        var md = window.markdownit();
        md.use( markdownItAttrs );
        var content = md.render( `{$release.description}` );
        var contentId = document.getElementById( "content" );
        contentId.innerHTML = content;
        $( '.datatable-nopaging' ).DataTable( {
            "language": dataTableLanguage,
            "paging": false,
            "searching": true
        } );
    } );
</script>

<h2>{t}Dernière version publiée{/t}</h2>
<div class="col-md-8 col-lg-6">
    {t}Version actuelle : {/t}{$currentVersion}<br>
    {t}Dernière version publiée : {/t}{$release.tag} du {$release.date}<br>
    {if $currentVersion != $release.tag}
    <b>{t}Vous pouvez demander la mise à jour de votre plate-forme à vos administrateurs !{/t}</b>
    <br>
    {/if}
    <div id="content"></div>
</div>