# Idea Inker

L'application Idea Inker est une application qui a pour objectif de réunir, partager et exprimer l'art du tatouage à travers l'exposition des salons, des réalisations des artistes et des notes données par les utilisateurs.

Elle permet également de rechercher et trouver les salons correspondant à vos attentes grâce à notre map utilisant la géolocalisation.

Les gérants de salons pourront également utiliser notre application pour trouver des artistes qui répondent aux attentes du salon de tatouage.

De cette manière chaque personne qu'il soit utilisateur, artiste ou gérant de salon pourra observer les œuvres publiées, s'en inspirer et être marqué par l'art.


## 1) Conception

L'application Idea Inker à été codé par une équipe de 5 développeurs : 

- Emerick CHALET
- Florent DEBUCHY
- Antoine HALLER
- Matteo RUFFE
- Ramy SAIDANE


Lors de notre préparation à la conception de l'application, nous avons décidés de créer Idea Inker avec le langage Flutter qui est un langage permettant de faire du cross-platform.
En partant sur du cross-platform, notre but était de pouvoir déployer l'application sur IOS et Android en ne développent qu'une fois afin de gagner du temps et baisser les coûts que la conception allait engendrer.
De plus, Flutter est un langage de programmation simple à appréhender qui s'approche du natif avec une documentation riche qui ne cesse de croitre grâce à sa technologie jeune en pleine expension.

## 2) Prérequis

Comme toute application, Idea Inker requière quelques prérequis avant de pouvoir passer à l'installation.
Tout d'abord, il vous faut une connexion internet, c'est un point indispensable pour pouvoir utiliser l'application. 
Ensuite, il vous faut un compte pour accéder au store de votre téléphone, ici je fais référence à un compte Google pour Google Play et à un compte IOS pour l'Apple Store.
De plus, il faut impérativement mettre à jour votre téléphone. La version minimum pour les IOS est la 9.0 et pour les Android la 11.0

## 3) Installation

Pour l'installation, vous devez incorporer des dépendances à l'application afin que ces fonctionnalités soient opérationnelles :

- sdk: flutter
- flutter_staggered_grid_view: ^0.6.1
- transparent_image: ^2.0.0
- convex_bottom_bar: ^3.0.0
- flutter_map: ^0.14.0
- latlng: ^0.1.0
- google_maps_flutter: ^2.1.0
- http: ^0.13.4
- fluttertoast: ^8.0.9
- image_picker: ^0.8.5
- cupertino_icons: ^1.0.2
- streaming_shared_preferences: ^2.0.0
- geocode: ^1.0.1
- permission_handler: ^9.2.0
- flutter_rating_bar: ^4.0.0
- date_format: ^2.0.6
- intl: ^0.17.0
- mime: ^1.0.2
- toggle_bar: ^1.0.0
- smooth_star_rating: ^1.1.1
- jwt_decoder: ^2.0.1

## 4) Utilisation de l'application

Idea Inker est une application simple à prendre en main. 

Lors de la toute première utilisation de l'application, l'utilisateur à uniquement accès à :
- La page d'accueil contenant une mosaïque d'images représentant toutes les publications
- La carte permettant de géolocaliser les salons autour de soit
- La liste des salons regroupant tous les salons

Sans avoir de compte sur Idea Inker, un utilisateur peut donc utiliser ces fonctionnalités de l'application.
A partir de la carte et de la liste des salons, un utilisateur peut observer le profil du salon afin d'y regarder ces créations, ces informations et ces artistes liés.

Si nous suivons le cas d'un utilisateur voulait avoir un profil sur l'application, ce dernier peut appuyer sur le bouton "Se connecter" afin d'arriver sur une page lui proposant de se connecter ou de créer son compte.
Une fois qu'un utilisateur à créer son compte, il à cette fois-ci accès à son profil sur lequel il pourra voir ses posts favoris et ses propres informations. Il pourra également modifier les informations de son profil et ajouter une photo de profil.
Seuls les comptes d'artistes et de salons peuvent faire des posts composé d'une photo et d'un nom.

De plus, si un utilisateur possède un compte ou non, il pourra depuis le profil d'un salon ou d'un artiste accéder à la page regroupant la liste des avis en plus lui permettre de laisser lui-même un avis accompagné d'une note.

Pour plus d'informations, veuillez trouver ci-dessous notre manuel utilsateur :
- [Manuel utilisateur de l'application](https://docs.google.com/document/d/1qwQirJHe6MRBU7UMwt3PosMA7jYsFfIXrhm0qofRJhA/edit?usp=sharing)


