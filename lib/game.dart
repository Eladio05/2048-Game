import 'dart:math';

class Game {
  late List<List<int>> grille;
  int score;

  Game() : score = 0 {
    grille = List.generate(4, (_) => List.generate(4, (_) => 0));
    _ajouterTuile();
    _ajouterTuile();
  }

  void _ajouterTuile() {
    List<int> tuileVide = [];
    for (int ligne = 0; ligne < 4; ligne++) {
      for (int colonne = 0; colonne < 4; colonne++) {
        if (grille[ligne][colonne] == 0) {
          tuileVide.add(ligne * 4 + colonne);
        }
      }
    }

    if (tuileVide.isNotEmpty) {
      int randomIndex = tuileVide[Random().nextInt(tuileVide.length)];
      int newValue = 2;
      grille[randomIndex ~/ 4][randomIndex % 4] = newValue;
    }
  }


  bool mouvement(String direction) {
    bool mouv = false;
    switch (direction) {
      case 'haut':
        mouv = _haut();
        break;
      case 'bas':
        mouv = _bas();
        break;
      case 'gauche':
        mouv = _gauche();
        break;
      case 'droite':
        mouv = _droite();
        break;
    }
    if (mouv) {
      _ajouterTuile();
    }
    return mouv;
  }

  bool _haut() {
    bool mouvement = false;
    for (int colonne = 0; colonne < 4; colonne++) {
      List<int> col = [];
      for (int ligne = 0; ligne < 4; ligne++) {
        if (grille[ligne][colonne] != 0) col.add(grille[ligne][colonne]);
      }
      List<int> fusionne = _fusion(col);
      for (int ligne = 0; ligne < 4; ligne++) {
        int val = ligne < fusionne.length ? fusionne[ligne] : 0;
        if (grille[ligne][colonne] != val) {
          grille[ligne][colonne] = val;
          mouvement = true;
        }
      }
    }
    return mouvement;
  }

  bool _bas() {
    bool mouvement = false;
    for (int colonne = 0; colonne < 4; colonne++) {
      List<int> col = [];
      for (int ligne = 3; ligne >= 0; ligne--) {
        if (grille[ligne][colonne] != 0) col.add(grille[ligne][colonne]);
      }
      List<int> fusionne = _fusion(col);
      for (int ligne = 3; ligne >= 0; ligne--) {
        int val = 3 - ligne < fusionne.length ? fusionne[3 - ligne] : 0;
        if (grille[ligne][colonne] != val) {
          grille[ligne][colonne] = val;
          mouvement = true;
        }
      }
    }
    return mouvement;
  }

  bool _gauche() {
    bool mouvement = false;
    for (int ligne = 0; ligne < 4; ligne++) {
      List<int> line = [];
      for (int colonne = 0; colonne < 4; colonne++) {
        if (grille[ligne][colonne] != 0) {
          line.add(grille[ligne][colonne]);
        }
      }
      List<int> fusionne = _fusion(line);
      for (int colonne = 0; colonne < 4; colonne++) {
        int val = colonne < fusionne.length ? fusionne[colonne] : 0;
        if (grille[ligne][colonne] != val) {
          grille[ligne][colonne] = val;
          mouvement = true;
        }
      }
    }
    return mouvement;
  }

  bool _droite() {
    bool mouvement = false;
    for (int ligne = 0; ligne < 4; ligne++) {
      List<int> line = [];
      for (int colonne = 3; colonne >= 0; colonne--) {
        if (grille[ligne][colonne] != 0){
          line.add(grille[ligne][colonne]);
        }
      }
      List<int> fusionne = _fusion(line);
      for (int colonne = 3; colonne >= 0; colonne--) {
        int val = 3 - colonne < fusionne.length ? fusionne[3 - colonne] : 0;
        if (grille[ligne][colonne] != val) {
          grille[ligne][colonne] = val;
          mouvement = true;
        }
      }
    }
    return mouvement;
  }

  List<int> _fusion(List<int> tuiles) {
    List<int> grilleFusionne = [];
    int skip = -1;
    for (int i = 0; i < tuiles.length; i++) {
      if (i == skip){
        continue;
      }
      if (i < tuiles.length - 1 && tuiles[i] == tuiles[i + 1]) {
        grilleFusionne.add(tuiles[i] * 2);
        score += tuiles[i] * 2;
        skip = i + 1;
      } else {
        grilleFusionne.add(tuiles[i]);
      }
    }
    return grilleFusionne;
  }

  bool partieTermine() {
    for (int ligne = 0; ligne < 4; ligne++) {
      for (int colonne = 0; colonne < 4; colonne++) {
        if (grille[ligne][colonne] == 0){
          return false;
        }
        if (ligne > 0 && grille[ligne][colonne] == grille[ligne - 1][colonne]){
          return false;
        }
        if (colonne > 0 && grille[ligne][colonne] == grille[ligne][colonne - 1]){
          return false;
        }
      }
    }
    return true;
  }
}
