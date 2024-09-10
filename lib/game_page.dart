import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart'; // Import du package audioplayers
import 'game_provider.dart';

class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _playBackgroundMusic(); // Jouer la musique de fond au démarrage
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); // Arrêter la musique lorsque la page est fermée
    super.dispose();
  }

  void _playBackgroundMusic() async {
    await _audioPlayer.play(AssetSource('sounds/2048.mp3'), volume: 0.5);
    // Ajuste le volume si nécessaire (entre 0.0 et 1.0)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFB06B),
      appBar: AppBar(
        backgroundColor: Color(0xFFFFB06B),
        title: Text("Partie en cours"),
        actions: [
          IconButton(
            icon: Icon(Icons.star),
            onPressed: () {
              Provider.of<GameProvider>(context, listen: false).simulateVictory();
              Future.delayed(Duration.zero, () {
                _showVictoryDialog(context, Provider.of<GameProvider>(context, listen: false));
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.warning),
            onPressed: () {
              Provider.of<GameProvider>(context, listen: false).simulateDefeat();
              Future.delayed(Duration.zero, () {
                _showDefeatDialog(context, Provider.of<GameProvider>(context, listen: false));
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onPanEnd: (details) {
                final velocity = details.velocity.pixelsPerSecond;
                final gameProvider = Provider.of<GameProvider>(context, listen: false);

                if (velocity.dx.abs() > velocity.dy.abs()) {
                  if (velocity.dx > 0) {
                    gameProvider.move('right');
                  } else {
                    gameProvider.move('left');
                  }
                } else {
                  if (velocity.dy > 0) {
                    gameProvider.move('down');
                  } else {
                    gameProvider.move('up');
                  }
                }

                if (gameProvider.hasWon) {
                  Future.delayed(Duration.zero, () {
                    _showVictoryDialog(context, gameProvider);
                  });
                }

                if (gameProvider.isGameOver) {
                  Future.delayed(Duration.zero, () {
                    _showDefeatDialog(context, gameProvider);
                  });
                }
              },
              child: Consumer<GameProvider>(
                builder: (context, gameProvider, child) {
                  return GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(10),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: 16,
                    itemBuilder: (context, index) {
                      int row = index ~/ 4;
                      int col = index % 4;
                      int value = gameProvider.board[row][col];

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
                  );
                },
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Consumer<GameProvider>(
                  builder: (context, gameProvider, child) {
                    return Text(
                      'Score: ${gameProvider.score}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  },
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
                      onPressed: () {
                        Provider.of<GameProvider>(context, listen: false).move('up');
                      },
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
                      onPressed: () {
                        Provider.of<GameProvider>(context, listen: false).move('left');
                      },
                      child: Icon(Icons.arrow_back),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF997C64),
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        Provider.of<GameProvider>(context, listen: false).move('right');
                      },
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
                      onPressed: () {
                        Provider.of<GameProvider>(context, listen: false).move('down');
                      },
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () => Provider.of<GameProvider>(context, listen: false).resetGame(),
              child: Text("Nouvelle Partie"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF997C64),
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  // Méthode pour afficher la popup de victoire
  void _showVictoryDialog(BuildContext context, GameProvider gameProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black, // Fond noir
          title: Center(
            child: Text(
              "Victoire !",
              style: TextStyle(color: Colors.white), // Texte blanc
            ),
          ),
          content: Text(
            "Votre score a atteint 2048 !",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white), // Texte blanc
          ),
          actions: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: () {
                    gameProvider.continueGame(); // Continuer la partie
                    Navigator.of(context).pop(); // Fermer la popup
                  },
                  child: Text("Continuer"),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.green, // Bouton vert
                    foregroundColor: Colors.white,
                  ),
                ),
                SizedBox(height: 10), // Espace entre les boutons
                TextButton(
                  onPressed: () {
                    gameProvider.resetGame(); // Réinitialiser le jeu
                    Navigator.of(context).pop(); // Fermer la popup
                  },
                  child: Text("Nouvelle Partie"),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blue, // Bouton bleu
                    foregroundColor: Colors.white,
                  ),
                ),
                SizedBox(height: 10), // Espace entre les boutons
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Fermer la popup
                    Navigator.of(context).pop(); // Revenir au menu principal
                  },
                  child: Text("Menu Principal"),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.red, // Bouton rouge
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
          actionsAlignment: MainAxisAlignment.center,
        );
      },
    );
  }

  // Méthode pour afficher la popup de défaite
  void _showDefeatDialog(BuildContext context, GameProvider gameProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black, // Fond noir
          title: Center(
            child: Text(
              "Défaite !",
              style: TextStyle(color: Colors.white), // Texte blanc
            ),
          ),
          content: Text(
            "Plus aucun mouvement n'est possible.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white), // Texte blanc
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () {
                gameProvider.resetGame(); // Réinitialiser le jeu
                Navigator.of(context).pop(); // Fermer la popup
              },
              child: Text("Nouvelle Partie"),
              style: TextButton.styleFrom(
                backgroundColor: Colors.green, // Bouton vert
                foregroundColor: Colors.white,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fermer la popup
                Navigator.of(context).pop(); // Revenir au menu principal
              },
              child: Text("Menu Principal"),
              style: TextButton.styleFrom(
                backgroundColor: Colors.red, // Bouton rouge
                foregroundColor: Colors.white,
              ),
            ),
          ],
        );
      },
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
