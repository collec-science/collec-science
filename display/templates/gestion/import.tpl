<h2>Import d'échantillons ou de containers à partir d'un fichier CSV</h2>
<div class="row">
<div class="col-md-6">
<div class="bg-info">
Ce module permet d'importer des échantillons ou des containers, et de créer le cas échéant les mouvements d'entrée.
<br>
Il n'accepte que des fichiers au format CSV. La ligne d'entête doit comprendre exclusivement les colonnes suivantes :
<br>
<ul>
<li><b>sample_identifier</b> : l'identifiant de l'échantillon (obligatoire)</li>
<li><b>project_id</b> : le numéro informatique du projet (obligatoire)</li>
<li><b>sample_type_id</b> : le numéro informatique du type d'échantillon (obligatoire)</li>
<li><b>sample_date</b> : la date de création de l'échantillon, au format dd/mm/yyyy</li>
<li><b>sample_range</b> : l'emplacement de rangement de l'échantillon dans le container</li>
<li><b>container_identifier</b> : l'identifiant du container (obligatoire)</li>
<li><b>container_type_id</b> : le numéro informatique du type de container (obligatoire)</li>
<li><b>container_status_id</b> : le numéro informatique du statut que prendra le container</li>
<li><b>container_range</b> : l'emplacement de rangement du container dans son parent</li>
<li><b>container_parent_uid</b> : l'UID du container parent</li>
</ul>
Les codes informatiques peuvent être consultés à partir du menu <i>Paramètres</i>.
<br>
L'import sera réalisé ainsi :
<ol>
<li>si sample_identifier est renseigné : création de l'échantillon</li>
<li>si container_identifier est renseigné : création du container</li>
<li>si container_parent_uid est renseigné : création du mouvement d'entrée du container</li>
<li>si l'échantillon et le container ont été créés, création du mouvement d'entrée de l'échantillon dans le container</li>
</ol>
</div>
</div>
</div>