<div class="container">
    <div class="row">
        <h2>{t}Sauvegarde de la base de données{/t}</h2>
    </div>
    <div class="row">
        <p>{t}Ce module est destiné à réaliser une sauvegarde exceptionnelle de la base de données{/t}<br>
            {t}En aucun cas, il se substitue à la procédure de sauvegarde automatique qui doit avoir été implémentée dans le serveur{/t}</p>
        <p>{t}La sauvegarde peut échouer si la taille de la base de données est trop importante.{/t}</p>
        <p>{t}Après avoir récupéré le fichier généré, assurez-vous qu'il contient bien les informations (fichier .sql dans le fichier compressé au format gzip){/t}</p>
    </div>
    <div class="row">
        <div class="col-3">
            <form id="backup" method="post">
                <input type="hidden" name="moduleBase" value="backup">
                <input type="hidden" name="action" value="Exec">
                <div class="row center">
                    <button type="submit" class="btn btn-primary button-valid">{t}Déclencher la sauvegarde{/t}</button>
                </div>
                {$csrf}
            </form>
        </div>
    </div>

</div>