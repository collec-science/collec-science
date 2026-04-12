<nav class="navbar navbar-expand-lg ">
	<div class="container-fluid">
		<a class="navbar-brand" href='/'>
			<span class="navbar-text hidden-xs hidden-sm">
				<img src="{$favicon}" height="20">
				<span class="white"><b>{$APPLI_title}</b></span>
			</span>
		</a>
		<button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent"
			aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
			<span class="navbar-toggler-icon"></span>
		</button>

		<!-- Affichage du menu -->
		<div class="collapse navbar-collapse " id="navbar_collapse">
			<ul class="nav navbar-nav me-auto mb-2 mb-lg-0">{$menu}
			</ul>

			<!-- Boutons a droite du menu -->
			<ul class="nav navbar-nav md navbar-right hidden-xs hidden-sm">
				<li class="nav-item dropdown">
					<a class="nav-link dropdown-toggle" href="{if $isLogged}#{else}connexion{/if}">
						{if $isLogged}{$login}{else}{t}Connexion{/t}{/if}
						<span class="caret"></span>
					</a>
					<ul class="dropdown-menu">
						<li class="nav-item"><a class="nav-link" href='setlocale?locale=fr'> <img
									src='display/images/drapeau_francais.png#180313' width='16' border='0'>
								Français
							</a></li>
						<li class="nav-item"><a class="nav-link" href='setlocale?locale=en'> <img
									src='display/images/drapeau_anglais.png#refresh180313' width='16' border='0'>
								English
							</a> </li>
						{if $isLogged}
						<li class="nav-item"><a class="nav-link" href="totpCreate"
								title="{t}Activer la double authentification pour votre compte{/t}">{t}Activer la double
								authentification{/t}</a></li>
						<li class="nav-item"><a class="nav-link" href="totpShowCode"
								title="{t}Afficher le code TOTP pour configurer un autre appareil{/t}">{t}Afficher le
								code
								TOTP{/t}</a></li>
						<li class="nav-item"><a class="nav-link" href='loginChangePassword'
								title="{t}Modifier le mot de passe{/t}"> <img src='display/images/key.png' width='16'
									border='0' title="{t}Modifier le mot de passe{/t}">
								{t}Mot de passe{/t}</a></li>
						<li class="nav-item"><a class="nav-link" href="disconnect">
								<img src='display/images/key_red.png' height='16' width='16' border='0'
									title="{t}Déconnexion{/t}">
								{t}Déconnexion{/t}</a></li>
						{else}{* not connected *}
						<li class="nav-item"><a class="nav-link" href="connexion">
								<img src='display/images/key_green.png' height='16' width='16' border='0'
									title="{t}Connexion{/t}">
								{t}Connexion{/t}</a></li>
						{/if}

					</ul>
				</li>
			</ul>
		</div>
	</div>
</nav>

<div class="container-fluid" id="messageDiv" {if strlen($message)==0} hidden{/if}>
	<div class="row">
		<div class="col-xs-12 message{if $messageError == 1}Error{/if}" id="message">
			{$message}
		</div>
	</div>
</div>