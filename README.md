# Jeu 2048 en Flutter

## Introduction

Le but de ce projet était de créer un jeu 2048 en utilisant **Flutter**, en mettant en pratique l'utilisation du **provider** pour la gestion de l'état et du **GestureDetector** pour capturer les mouvements de l'utilisateur. L'objectif principal était de développer un jeu avec une interface fluide et responsive. Le jeu détecte les mouvements de l'utilisateur pour contrôler les déplacements des tuiles et gérer efficacement l'état du jeu.

## Fonctionnalités et aspects techniques

L'application utilise **`GestureDetector`** pour capturer les mouvements de l'utilisateur, principalement les glissements pour déplacer les tuiles dans la grille. L'interface est donc très réactive, ce qui est essentiel pour un jeu comme 2048 où l'interaction tactile doit être fluide et précise.

Pour gérer l'état du jeu (la grille, les tuiles, le score, etc.), on a utilisé le package **`provider`**. Le **`GameProvider`** centralise tout : c'est lui qui s'assure que la grille se mette à jour après chaque mouvement, qu'on vérifie si le joueur a gagné ou perdu, et qu'on réinitialise la partie quand nécessaire. Cela permet aussi d'isoler la logique métier du jeu dans des classes distinctes, rendant l'interface plus légère et facile à maintenir.

Côté son, **`audioplayers`** a été utilisé pour ajouter une musique de fond, aussi bien dans l'écran d'accueil que pendant la partie, afin d'enrichir l'expérience utilisateur.

## Fichiers principaux

- **`main.dart`** : Point d'entrée de l'application. Ce fichier gère la navigation entre l'écran d'accueil et la page de jeu. Il lance aussi la musique de fond de l'écran d'accueil.

- **`game.dart`** : Contient toute la logique du jeu. Ce fichier est responsable de la génération de la grille, du déplacement des tuiles, de leur fusion, et de la vérification des conditions de victoire ou de défaite. C'est ici que la méthode `_ajouterTuile()` est définie, qui ajoute une tuile de valeur 2 à une case vide après chaque déplacement.

- **`game_provider.dart`** : Sert de lien entre la logique métier et l'interface utilisateur. Il utilise le pattern `ChangeNotifier` pour notifier les widgets lorsqu'il y a des changements dans l'état du jeu (par exemple, après un déplacement ou lorsque la partie se termine). Il gère aussi la logique de victoire et de défaite.

- **`game_page.dart`** : Gère l'affichage de la grille du jeu et capture les gestes de l'utilisateur grâce à `GestureDetector`. Ce fichier contient aussi la logique pour afficher les boîtes de dialogue (popups) en cas de victoire ou de défaite. À chaque mouvement, il appelle le `GameProvider` pour mettre à jour l'état du jeu et redessiner la grille. Chaque tuile a une couleur spécifique en fonction de sa valeur, et c'est dans ce fichier que ces couleurs sont définies.

- **`assets/`** : Contient les fichiers multimédias :
    - **`images/logo.png`** : Logo affiché sur l'écran d'accueil.
    - **`sounds/2048.mp3`** : Musique jouée pendant la partie.
    - **`sounds/accueil.mp3`** : Musique de fond de l'écran d'accueil.
