# Qu'est-ce que la double authentification ?

Lorsque vous vous identifiez dans l'application, vous utilisez un login et un mot de passe, soit que vous avez choisi, soit qui vous a été fourni.

Si quelqu'un arrive à découvrir votre mot de passe, soit par des essais successifs, soit en arrivant à vous piéger, il pourra se connecter à votre place dans le logiciel. Pour limiter les risques, un second mécanisme d'identification peut être utilisé, qui va être basé sur l'utilisation d'un appareil en votre possession : c'est la double authentification. 

Quel est l'appareil que vous emmenez toujours avec vous, et dont vous ne vous séparez (presque) jamais ? Votre smartphone ! C'est à celui-ci que nous allons confier le soin de réaliser la seconde authentification.

## Comment ça marche ?

Un secret va être partagé entre l'application et votre smartphone. Ce secret est une clé cryptographique, qu'il est impossible de découvrir si on ne la connait pas. Dans l'application, cette clé est associée à votre compte.

Un algorithme, basé sur l'heure courante, permet de générer un code de 6 chiffres à partir de cette clé secrète. Les smartphones et les serveurs partagent la même heure : ils se synchronisent plusieurs fois par jour avec des horloges de référence. Comme l'algorithme utilisé, la clé secrète, et l'heure sont identiques entre le smartphone et le serveur, le code généré est forcément identique. 

Ainsi, l'application peut facilement vérifier que le code généré par le smartphone est identique à celui qu'elle peut calculer, et s'assurer que vous êtes bien le possesseur du compte utilisé.

Dans la pratique, le code a une durée de validité de 30 secondes : au bout de ce laps de temps, il est caduc, et un nouveau code va être généré.

## Comment la clé secrète est échangée ?

Au moment de l'activation de la double authentification, le serveur va générer la clé secrète et l'encapsuler dans un QRCode, qui va être affiché à l'écran. Il suffit alors de le lire avec une application dédiée pour qu'il soit enregistré dans votre smartphone.

La clé secrète est associée à votre compte dans la base de données et est également chiffrée avec un autre mécanisme : si celle-ci venait à être récupérée de manière illégale, sans les clés de chiffrement complémentaires, votre clé secrète restera illisible.

Une fois la clé secrète copiée dans votre smartphone, celle-ci n'est plus jamais échangée, et mis à part si vous perdez votre smartphone, elle a peu de chances d'être découverte.

## Quand faut-il activer la double authentification ?

Il est préférable d'activer la double authentification quand vous disposez de fonctions d'administration étendues dans l'application (profil d'administration des comptes ou profil d'administration de l'application). 

Si l'application gère des données sensibles, il est également souhaitable d'activer ce mécanisme.

## Quels logiciels peut-on utiliser dans le smartphone ?

Vous devez utiliser un logiciel supportant la norme TOTP. Parmi les plus connus, vous pouvez installer *Google Authenticator*, disponible uniquement avec Android, ou *FreeOTP*, disponible sur IOS ou Android.

## Que faire si vous perdez votre smartphone ou votre clé secrète ?

Demandez à un administrateur de réinitialiser votre clé secrète. Si vous êtes le dernier administrateur de l'application, il vous faudra (faire) effacer la clé secrète dans la base de données.