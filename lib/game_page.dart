import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
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
    _playBackgroundMusic();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playBackgroundMusic() async {
    await _audioPlayer.play(AssetSource('sounds/2048.mp3'), volume: 0.5);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 176, 107),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 176, 107),
        title: Text("Partie en cours"),
        actions: [
          IconButton(
            icon: Icon(Icons.star),
            onPressed: () {
              Provider.of<GameProvider>(context, listen: false).simulerVictoire();
              Future.delayed(Duration.zero, () {
                _ecranVictoire(context, Provider.of<GameProvider>(context, listen: false));
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.warning),
            onPressed: () {
              Provider.of<GameProvider>(context, listen: false).simulerDefaite();
              Future.delayed(Duration.zero, () {
                _ecranDefaite(context, Provider.of<GameProvider>(context, listen: false));
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
                final velocite = details.velocity.pixelsPerSecond;
                final provider = Provider.of<GameProvider>(context, listen: false);

                if (velocite.dx.abs() > velocite.dy.abs()) {
                  if (velocite.dx > 0) {
                    provider.mouvement('droite');
                  } else {
                    provider.mouvement('gauche');
                  }
                } else {
                  if (velocite.dy > 0) {
                    provider.mouvement('bas');
                  } else {
                    provider.mouvement('haut');
                  }
                }

                if (provider.victoire) {
                  Future.delayed(Duration.zero, () {
                    _ecranVictoire(context, provider);
                  });
                }

                if (provider.jeuTermine) {
                  Future.delayed(Duration.zero, () {
                    _ecranDefaite(context, provider);
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
                      int ligne = index ~/ 4;
                      int colonne = index % 4;
                      int val = gameProvider.tableau[ligne][colonne];

                      return Container(
                        decoration: BoxDecoration(
                          color: _couleurTuile(val),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            val == 0 ? '' : '$val',
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
                        Provider.of<GameProvider>(context, listen: false).mouvement('haut');
                      },
                      child: Icon(Icons.arrow_upward),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 153, 124, 100),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Provider.of<GameProvider>(context, listen: false).mouvement('gauche');
                      },
                      child: Icon(Icons.arrow_back),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 153, 124, 100),
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        Provider.of<GameProvider>(context, listen: false).mouvement('droite');
                      },
                      child: Icon(Icons.arrow_forward),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 153, 124, 100),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Provider.of<GameProvider>(context, listen: false).mouvement('bas');
                      },
                      child: Icon(Icons.arrow_downward),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 153, 124, 100),
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
              onPressed: () => Provider.of<GameProvider>(context, listen: false).reset(),
              child: Text("Nouvelle Partie"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 153, 124, 100),
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  void _ecranVictoire(BuildContext context, GameProvider gameProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: Center(
            child: Text(
              "Victoire !",
              style: TextStyle(color: Colors.white),
            ),
          ),
          content: Text(
            "Votre score a atteint 2048 !",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: () {
                    gameProvider.continueJeu();
                    Navigator.of(context).pop();
                  },
                  child: Text("Continuer"),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    gameProvider.reset();
                    Navigator.of(context).pop();
                  },
                  child: Text("Nouvelle Partie"),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: Text("Menu Principal"),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.red,
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

  void _ecranDefaite(BuildContext context, GameProvider gameProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: Center(
            child: Text(
              "Défaite !",
              style: TextStyle(color: Colors.white),
            ),
          ),
          content: Text(
            "Plus aucun mouvement n'est possible.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () {
                gameProvider.reset();
                Navigator.of(context).pop();
              },
              child: Text("Nouvelle Partie"),
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text("Menu Principal"),
              style: TextButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        );
      },
    );
  }

  Color _couleurTuile(int value) {
    switch (value) {
      case 2:
        return Colors.orange[100]!;
      case 4:
        return Colors.orange[300]!;
      case 8:
        return Colors.orange[500]!;
      case 16:
        return Colors.orange[700]!;
      case 32:
        return Colors.orange[800]!;
      case 64:
        return Colors.red[400]!;
      case 128:
        return Colors.red[500]!;
      case 256:
        return Colors.red[600]!;
      case 512:
        return Colors.red[700]!;
      case 1024:
        return Colors.red[800]!;
      case 2048:
        return Colors.red[900]!;
      default:
        return Colors.grey;
    }
  }
}
