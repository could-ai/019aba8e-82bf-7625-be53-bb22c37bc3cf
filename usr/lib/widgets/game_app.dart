import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'main_menu_screen.dart';
import 'game_over_screen.dart';
import '../game/miner_dash_game.dart';
import 'package:flame/game.dart';

final game = MinerDashGame();

class GameApp extends StatelessWidget {
  const GameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Miner Dash',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        textTheme: GoogleFonts.pressStart2pTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: Scaffold(
        body: GameWidget(
          game: game,
          initialActiveOverlays: const ['MainMenu'],
          overlayBuilderMap: {
            'MainMenu': (context, _) => MainMenuScreen(game: game),
            'GameOver': (context, _) => GameOverScreen(game: game),
          },
        ),
      ),
    );
  }
}
