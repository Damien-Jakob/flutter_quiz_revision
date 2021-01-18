import 'package:flutter/material.dart';
import 'package:quiz/widgets/game_screen.dart';

class StartGameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Quiz"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Difficulté", textScaleFactor: 2.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GameScreen()),
                  );
                },
                child: Text("Rookie",
                    textScaleFactor: 2.0, textAlign: TextAlign.center),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GameScreen()),
                  );
                },
                child: Text("Ninja",
                    textScaleFactor: 2.0, textAlign: TextAlign.center),
              ),
            ],
          ),
        ));
  }
}
