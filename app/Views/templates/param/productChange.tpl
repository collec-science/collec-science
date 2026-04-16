<div class="container">
    <h2>{t}Création - Modification des produits ajoutés aux contenants ou aux échantillons{/t}</h2>
    <div class="row">
        <a href="productList">
            <img src="display/images/list.png" height="25">
            {t}Retour à la liste{/t}
        </a>
    </div>
    <div class="row">
        <form class="form-horizontal " id="productForm" method="post" action="productWrite">
            <input type="hidden" name="moduleBase" value="product">
            <input type="hidden" name="product_id" value="{$data.product_id}">
            <div class="row">
                <label for="productName" class="form-label col-4"><span class="red">*</span>
                    {t}Nom du produit :{/t}
                </label>
                <div class="col-8">
                    <input id="productName" type="text" class="form-control" name="product_name" value="{$data.product_name}" autofocus required>
                </div>
            </div>
            <div class="row d-flex justify-content-center">
                <div class="col-auto">
                    <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
                </div>
                {if $data.product_id > 0 }
                <div class="col-auto">
                    <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
                </div>
                {/if}
            </div>
            {$csrf}
        </form>
    </div>

    <div class="row col-12 d-inline">
        <span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>
    </div>
</div>