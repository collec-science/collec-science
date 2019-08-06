	<div class="navbar navbar-default" role="navigation">
	<div class="container-fluid">
	
		<div class="navbar-header navbar">{* la classe css navbar est là pour conserver une grande taille comme avant. TODO trouver autre solution (css) *}
			<button type="button" class="navbar-toggle" data-toggle="collapse"
				data-target=".navbar-collapse">
				<span class="sr-only">Toggle navigation</span> <span
					class="icon-bar"></span> <span class="icon-bar"></span> <span
					class="icon-bar"></span>
			</button>
			<div class="navbar-brand"><a href='/'><img src="{$favicon}" height="25"></a></div>
			<a href='/'><span class="navbar-text hidden-xs hidden-sm"><b>{$APPLI_title}</b></span></a>
		</div>
		<!-- Affichage du menu -->
		<div class="collapse navbar-collapse" id="navbar_collapse">
		<ul class="nav navbar-nav md">{$menu}
		</ul>

		<!-- Boutons a droite du menu -->
		<ul class="nav navbar-nav md navbar-right hidden-xs hidden-sm">
			<li><a href="{if $isConnected}#{else}index.php?module=connexion{/if}">{if $isConnected }{$login}{else}{t}Connexion{/t}{/if} <span class="caret"></span></a>
				<ul class="dropdown-menu">
				    <li><a href='index.php?module=setlanguage&langue=fr'> <img
								src='display/images/drapeau_francais.png#180313' width='16'  border='0'> 
								Français
							</a></li>
				    <li><a href='index.php?module=setlanguage&langue=en'> <img
								src='display/images/drapeau_anglais.png#refresh180313' width='16'  border='0'> 
								English
							</a> </li>
{if $isConnected}
				    <li><a href='index.php?module=loginChangePassword' title="{t}Modifier le mot de passe{/t}"> <img
								src='display/images/key.png' width='16' border='0' title="{t}Modifier le mot de passe{/t}">
							{t}Mot de passe{/t}</a></li>
					<li><a href="index.php?module=disconnect">
<img src='display/images/key_red.png' height='16' width='16' border='0' title="{t}Déconnexion{/t}">
			{t}Déconnexion{/t}</a></li>
{else}{* not connected *}
			        <li><a href="index.php?module=connexion">
<img src='display/images/key_green.png' height='16' width='16' border='0' title="{t}Connexion{/t}">
			{t}Connexion{/t}</a></li>
{/if}

				</ul>
			</li>
		</ul>
		</div>
	</div>
</div>
{if (strlen($message) > 0) }
<div class="container-fluid">
<div class="row">
	<div class="col-xs-12 message{if $messageError == 1}Error{/if}" id="message">
		{$message}
	</div>
</div>
</div>
{/if}
