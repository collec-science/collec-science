# Identification pour les services web

## principe général

Sauf pour la consultation des collections publiques, les appels directs au logiciel sans passer par l'interface graphique nécessitent d'identifier l'utilisateur (ou l'application). Cette identification est basée sur l'utilisation d'un jeton cryptographique généré par l'application.

Dans la pratique, un utilisateur dédié est créé dans la base de données. Cet utilisateur est doté d'un jeton (*token*) qui devra être fourni lors de chaque requête, en même temps que son login.

L'utilisateur sera ensuite positionné dans un groupe, dans la gestion des droits, pour pouvoir récupérer les droits d'accès aux modules considérés.

## Créer un compte

Dans le menu *Administration*, *Liste des comptes locaux*, créez un nouveau login :

- indiquez le login utilisé, par exemple le nom de l'application qui devra accéder aux services web ;
- cliquez sur *Compte utilisé pour service web*
- ne renseignez pas de mot de passe
- validez : le compte est créé.

Retournez sur la modification du compte : la zone *Jeton d'identification du service web* est maintenant renseignée. Vous pouvez copier le jeton dans le presse-papier pour l'utiliser dans l'application appelante.

## Donner les droits au compte

Le compte va être géré comme les autres comptes de l'application : il faut le positionner dans les groupes adéquats pour qu'il récupère les droits d'accès aux différents modules.

L'affectation s'effectue depuis le menu *Administration > ACL - groupes de logins*, de la même manière que pour les utilisateurs classiques.

## Limitations

L'utilisation de jetons est incompatible si le mode d'identification définie dans le logiciel est positionnée à **HEADER** et utilise le mode *Mellon* d'Apache (cas de l'identification *via* la fédération d'identités Renater, par exemple). En effet, le mode *Mellon* gère l'accès avant que l'utilisateur puisse appeler l'application, ce qui ne permet pas d'analyser le jeton fourni.

Si vous avez mis en place ce type d'identification, et si vous devez fournir un accès vers les services web, que les collections soient publiques ou non, vous devrez alors disposer d'une seconde adresse et paramétrer l'accès pour celle-ci en utilisant l'identification **BDD**.

Pour de plus amples renseignements sur la mise en place de deux adresses avec des paramétrages différents pour la même instance, consultez le [manuel d'installation et de configuration](index.php?module=documentationGetFile&filename=technical/installation_fr/collec_installation_configuration.pdf&mode=attachment#subsection.2.3.8), chapitre 2.3.8 *Configurer le dossier d'installation, cas particulier : faire cohabiter plusieurs instances avec le même code*. 