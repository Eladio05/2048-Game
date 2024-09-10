import 'package:flutter/material.dart';
import 'game.dart';

class GameProvider with ChangeNotifier {
  Game _game = Game();
  bool _hasWon = false;

  List<List<int>> get board => _game.board;
  int get score => _game.score;
  bool get hasWon => _hasWon;

  // Getter pour vérifier si le jeu est terminé
  bool get isGameOver => _game.isGameOver();

  // Gérer les mouvements
  void move(String direction) {
    _game.move(direction);
    if (!_hasWon) { // Vérifier la victoire uniquement si la popup n'a pas déjà été affichée
      checkVictory();
    }
    notifyListeners();
  }

  // Simuler une grille perdante
  void simulateDefeat() {
    // Remplir la grille avec des valeurs où aucun déplacement ou fusion n'est possible
    _game.board = [
      [2, 4, 2, 4],
      [4, 2, 4, 2],
      [2, 4, 2, 4],
      [4, 2, 4, 2],
    ];
    notifyListeners();
  }

  // Simuler une victoire avec un score de 2048
  void simulateVictory() {
    _game.score = 2048; // Définir le score à 2048 ou plus
    _hasWon = true;
    notifyListeners();
  }

  // Réinitialiser le jeu
  void resetGame() {
    _game = Game();
    _hasWon = false;
    notifyListeners();
  }

  // Vérifier la victoire lorsque le score atteint 2048
  void checkVictory() {
    if (_game.score >= 2048 && !_hasWon) {
      _hasWon = true;
      notifyListeners(); // Notifier les widgets qu'il y a une victoire
    }
  }

  // Continuer le jeu après une victoire
  void continueGame() {
    _hasWon = false; // Réinitialiser la victoire pour ne plus afficher la popup
    notifyListeners();
  }
}
