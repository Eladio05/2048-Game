import 'package:flutter/material.dart';
import 'game.dart';

class GameProvider with ChangeNotifier {
  Game _game = Game();

  List<List<int>> get board => _game.board;
  int get score => _game.score;

  void move(String direction) {
    _game.move(direction);
    notifyListeners();
    if (_game.isGameOver()) {
      // Gérer la fin de la partie ici
      print("Game Over!");
    }
  }

  void resetGame() {
    _game = Game();
    notifyListeners();
  }
}
