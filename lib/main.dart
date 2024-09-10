import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart'; // Import du package audioplayers
import 'game_page.dart';
import 'game_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Jeu 2048",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _playBackgroundMusic();
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); // Arrêter la musique lorsque l'utilisateur quitte l'écran d'accueil
    super.dispose();
  }

  void _playBackgroundMusic() async {
    await _audioPlayer.play(AssetSource('sounds/accueil.mp3'), volume: 0.5);
    // Ajoute "ReleaseMode.loop" si tu veux que la musique se répète en boucle
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFB06B),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              "assets/images/logo.png",
              width: 150,
              height: 150,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Arrêter la musique de l'écran d'accueil lorsqu'on commence une partie
                _audioPlayer.stop();

                // Naviguer vers GamePage avec un ChangeNotifierProvider pour le Provider
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangeNotifierProvider(
                      create: (_) => GameProvider(),
                      child: GamePage(),
                    ),
                  ),
                );
              },
              child: Text(
                "Commencer une partie",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF997C64),
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
