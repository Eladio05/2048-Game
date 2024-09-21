import 'package:flutter/material.dart';
import 'game.dart';

class GameProvider with ChangeNotifier {
  Game _game = Game();
  bool _victoire = false;
  List<List<int>> get tableau => _game.grille;
  int get score => _game.score;
  bool get victoire => _victoire;
  bool get jeuTermine => _game.partieTermine();

  void mouvement(String direction) {
    _game.mouvement(direction);
    if (!_victoire) {
      verifVictoire();
    }
    notifyListeners();
  }

  void simulerDefaite() {
    _game.grille = [
      [2, 4, 2, 4],
      [4, 2, 4, 2],
      [2, 4, 2, 4],
      [4, 2, 4, 2],
    ];
    notifyListeners();
  }

  void simulerVictoire() {
    _game.score = 2048;
    _victoire = true;
    notifyListeners();
  }

  void reset() {
    _game = Game();
    _victoire = false;
    notifyListeners();
  }

  void verifVictoire() {
    if (_game.score >= 2048 && !_victoire) {
      _victoire = true;
      notifyListeners();
    }
  }

  void continueJeu() {
    _victoire = false;
    notifyListeners();
  }
}
