<div class="container center-block d-none d-lg-block mt-5">
    <div class="row">
        <div class="col center">
            <a href="containerList">
                <img src="display/images/box.png" height="50">
                <br>
                {t}Liste des contenants{/t}
            </a>
        </div>
        <div class="col center">
            <a href="sampleList">
                <img src="display/images/sample.png" height="50">
                <br>
                {t}Liste des échantillons{/t}
            </a>
        </div>
        <div class="col center">
            <a href="smallMovementChange">
                <img src="display/images/tablet.png" height="50">
                <br>
                {t}Mouvements petit terminal{/t}
            </a>
        </div>
    </div>
</div>

<!-- small terminal -->
<div class="container center-block d-lg-none">
    <div class="row">
        <div class="col center">
            <a href="sampleDisplay">
                <img src="display/images/sample.png" height="50">
                <br>
                <span class="input-lg">
                    {t}Échantillon{/t}
                </span>
            </a>
        </div>
        <div class="col center">
            <a href="smallMovementChange">
                <img src="display/images/tablet.png" height="50">
                <br>
                <span class="input-lg">
                    {t}Mouvements petit terminal{/t}
                </span>
            </a>
        </div>
        <div class="col center">
            <a href="containerDisplay">
                <img src="display/images/box.png" height="50">
                <br>
                <span class="input-lg">
                    {t}Contenant{/t}
                </span>
            </a>
        </div>
    </div>
</div>

{if !empty ($rights) && $rights.manage == 1}
<div class="container center-block d-none d-lg-block mt-5">
    <div class="row">
        <div class="col center">
            <a href="fastInputChange">
                <img src="display/images/input.png" height="50">
                <br>
                {t}Entrer ou déplacer dans un contenant{/t}
            </a>
        </div>
        <div class="col center">
            <a href="movementBatchOpen">
                <img src="display/images/barcode-scanner.png" height="50">
                <br>
                {t}Entrer ou déplacer / Sortir par lots{/t}
            </a>
        </div>
        <div class="col center">
            <a href="fastOutputChange">
                <img src="display/images/output.png" height="50">
                <br>
                {t}Sortir du stock{/t}
            </a>
        </div>
    </div>
</div>
{/if}
{if !empty($collections) && count($collections) > 0}
<div class="container center-block d-none d-lg-block mt-5">
    <div class="row center">
        <div class="col lg-6">
            <table class="table table-bordered table-hover datatable-nopaging-nosearching table-primary">
                <thead>
                    <tr>
                        <th class="center">{t}Collection{/t}</th>
                        <th>{t}Nombre d'échantillons{/t}</th>
                        <th>{t}Date de dernière modification d'un échantillon{/t}</th>
                    </tr>
                </thead>
                <tbody>
                    {foreach $collections as $col}
                    <tr>
                        <td class="nowrap" title="{$col.collection_description}">{$col.collection_name}</td>
                        <td class="center">{$col.samples_number}</td>
                        <td class="center">{$col.last_change}</td>
                    </tr>
                    {/foreach}
                </tbody>
            </table>
        </div>
    </div>
</div>
{/if}