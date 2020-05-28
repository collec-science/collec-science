<h2>{t}Sauvegarde de la base de données{/t}</h2>
<p>{t}Ce module est destiné à réaliser une sauvegarde exceptionnelle de la base de données{/t}<br>
  {t}En aucun cas, il se substitue à la procédure de sauvegarde automatique qui doit avoir été implémentée dans le serveur{/t}</p>
<p>{t}La sauvegarde peut échouer si la taille de la base de données est trop importante.{/t}</p>
<p>{t}Après avoir récupéré le fichier généré, assurez-vous qu'il contient bien les informations (fichier .sql dans le fichier compressé au format gzip){/t}</p>
<div class="row">
  <div class="col-md-3">
    <form id="backup">
      <input type="hidden" name="moduleBase" value="backup">
      <input type="hidden" name="action" value="Exec">
      <div class="form-group center">
        <button type="submit" class="btn btn-primary button-valid">{t}Déclencher la sauvegarde{/t}</button>
      </div>
    </form>
  </div>
</div>