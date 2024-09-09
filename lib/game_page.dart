import 'package:flutter/material.dart';
import 'game.dart';

class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late Game _game;

  @override
  void initState() {
    super.initState();
    _game = Game(); // Initialiser la logique du jeu
  }

  // Fonction pour gérer les mouvements et mettre à jour l'interface
  void _handleMove(String direction) {
    setState(() {
      _game.move(direction);
    });
    if (_game.isGameOver()) {
      _showGameOverDialog();
    }
  }

  // Afficher une boîte de dialogue si le jeu est terminé
  void _showGameOverDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Partie terminée'),
          content: Text('Voulez-vous recommencer ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _game = Game(); // Réinitialiser la partie
                });
              },
              child: Text('Oui'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Non'),
            ),
          ],
        );
      },
    );
  }

  // Méthode pour détecter la direction du glissement
  void _onPanEnd(DragEndDetails details) {
    final velocity = details.velocity.pixelsPerSecond;

    if (velocity.dx.abs() > velocity.dy.abs()) {
      // Mouvement horizontal
      if (velocity.dx > 0) {
        // Vers la droite
        _handleMove('right');
      } else {
        // Vers la gauche
        _handleMove('left');
      }
    } else {
      // Mouvement vertical
      if (velocity.dy > 0) {
        // Vers le bas
        _handleMove('down');
      } else {
        // Vers le haut
        _handleMove('up');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFB06B),
      appBar: AppBar(
        backgroundColor: Color(0xFFFFB06B),
        title: Text("Partie en cours"),
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onPanEnd: _onPanEnd, // Utiliser onPanEnd pour détecter les gestes
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(), // Désactiver le défilement
                padding: EdgeInsets.all(10),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, // Grille 4x4
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: 16, // 16 tuiles dans une grille 4x4
                itemBuilder: (context, index) {
                  int row = index ~/ 4;
                  int col = index % 4;
                  int value = _game.board[row][col];

                  return Container(
                    decoration: BoxDecoration(
                      color: _getTileColor(value),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        value == 0 ? '' : '$value',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          // Ajout du score avec un carré noir et des bords arrondis
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(15), // Bord arrondi
                ),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text(
                  'Score: ${_game.score}',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => _handleMove('up'),
                      child: Icon(Icons.arrow_upward),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF997C64),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => _handleMove('left'),
                      child: Icon(Icons.arrow_back),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF997C64),
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () => _handleMove('right'),
                      child: Icon(Icons.arrow_forward),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF997C64),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => _handleMove('down'),
                      child: Icon(Icons.arrow_downward),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF997C64),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _game = Game(); // Réinitialiser la partie
              });
            },
            child: Text("Nouvelle Partie"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF997C64),
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  // Méthode pour définir la couleur de la tuile en fonction de sa valeur
  Color _getTileColor(int value) {
    switch (value) {
      case 2:
        return Colors.orange[200]!;
      case 4:
        return Colors.orange[300]!;
      case 8:
        return Colors.orange[400]!;
      case 16:
        return Colors.orange[500]!;
      case 32:
        return Colors.orange[600]!;
      case 64:
        return Colors.orange[700]!;
      case 128:
        return Colors.orange[800]!;
      case 256:
        return Colors.orange[900]!;
      case 512:
        return Colors.deepOrange[500]!;
      case 1024:
        return Colors.deepOrange[600]!;
      case 2048:
        return Colors.deepOrange[700]!;
      default:
        return Colors.grey[300]!;
    }
  }
}
