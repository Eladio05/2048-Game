import 'package:flutter/material.dart';

class GamePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Partie en cours"),
      ),
      body: Center(
        child: Text(
          "C'est ici que la grille 2048 sera affichée",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
