import 'dart:math';

class Game {
  late List<List<int>> board;
  int score;

  Game() : score = 0 {
    // Initialisation de la grille 4x4 avec des zéros
    board = List.generate(4, (_) => List.generate(4, (_) => 0));
    _addNewTile();
    _addNewTile();
  }

  // Ajouter une nouvelle tuile avec une valeur de 2 ou 4
  void _addNewTile() {
    List<int> emptyTiles = [];
    for (int row = 0; row < 4; row++) {
      for (int col = 0; col < 4; col++) {
        if (board[row][col] == 0) {
          emptyTiles.add(row * 4 + col); // Convertir en index 1D
        }
      }
    }

    if (emptyTiles.isNotEmpty) {
      int randomIndex = emptyTiles[Random().nextInt(emptyTiles.length)];
      int newValue = Random().nextInt(10) < 9 ? 2 : 4; // 90% de chances d'obtenir un 2, 10% un 4
      board[randomIndex ~/ 4][randomIndex % 4] = newValue;
    }
  }

  // Déplacer les tuiles dans une direction (haut, bas, gauche, droite)
  bool move(String direction) {
    bool moved = false;
    switch (direction) {
      case 'up':
        moved = _moveUp();
        break;
      case 'down':
        moved = _moveDown();
        break;
      case 'left':
        moved = _moveLeft();
        break;
      case 'right':
        moved = _moveRight();
        break;
    }
    if (moved) {
      _addNewTile(); // Ajouter une nouvelle tuile après un déplacement valide
    }
    return moved;
  }

  // Déplacement des tuiles vers le haut
  bool _moveUp() {
    bool moved = false;
    for (int col = 0; col < 4; col++) {
      List<int> column = [];
      for (int row = 0; row < 4; row++) {
        if (board[row][col] != 0) column.add(board[row][col]);
      }
      List<int> merged = _merge(column);
      for (int row = 0; row < 4; row++) {
        int value = row < merged.length ? merged[row] : 0;
        if (board[row][col] != value) {
          board[row][col] = value;
          moved = true;
        }
      }
    }
    return moved;
  }

  // Autres déplacements (droite, gauche, bas)
  bool _moveDown() {
    bool moved = false;
    for (int col = 0; col < 4; col++) {
      List<int> column = [];
      for (int row = 3; row >= 0; row--) {
        if (board[row][col] != 0) column.add(board[row][col]);
      }
      List<int> merged = _merge(column);
      for (int row = 3; row >= 0; row--) {
        int value = 3 - row < merged.length ? merged[3 - row] : 0;
        if (board[row][col] != value) {
          board[row][col] = value;
          moved = true;
        }
      }
    }
    return moved;
  }

  bool _moveLeft() {
    bool moved = false;
    for (int row = 0; row < 4; row++) {
      List<int> line = [];
      for (int col = 0; col < 4; col++) {
        if (board[row][col] != 0) line.add(board[row][col]);
      }
      List<int> merged = _merge(line);
      for (int col = 0; col < 4; col++) {
        int value = col < merged.length ? merged[col] : 0;
        if (board[row][col] != value) {
          board[row][col] = value;
          moved = true;
        }
      }
    }
    return moved;
  }

  bool _moveRight() {
    bool moved = false;
    for (int row = 0; row < 4; row++) {
      List<int> line = [];
      for (int col = 3; col >= 0; col--) {
        if (board[row][col] != 0) line.add(board[row][col]);
      }
      List<int> merged = _merge(line);
      for (int col = 3; col >= 0; col--) {
        int value = 3 - col < merged.length ? merged[3 - col] : 0;
        if (board[row][col] != value) {
          board[row][col] = value;
          moved = true;
        }
      }
    }
    return moved;
  }

  // Fusionner les tuiles similaires
  List<int> _merge(List<int> tiles) {
    List<int> merged = [];
    int skip = -1;
    for (int i = 0; i < tiles.length; i++) {
      if (i == skip) continue;
      if (i < tiles.length - 1 && tiles[i] == tiles[i + 1]) {
        merged.add(tiles[i] * 2);
        score += tiles[i] * 2;
        skip = i + 1;
      } else {
        merged.add(tiles[i]);
      }
    }
    return merged;
  }

  // Vérifier si le jeu est terminé
  bool isGameOver() {
    for (int row = 0; row < 4; row++) {
      for (int col = 0; col < 4; col++) {
        if (board[row][col] == 0) return false; // Case vide
        if (row > 0 && board[row][col] == board[row - 1][col]) return false; // Tuile fusionnable vers le haut
        if (col > 0 && board[row][col] == board[row][col - 1]) return false; // Tuile fusionnable vers la gauche
      }
    }
    return true;
  }
}
