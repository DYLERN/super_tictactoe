import 'package:flutter/material.dart';
import 'package:super_tictactoe/game_page.dart';

void main() {
  runApp(const SuperTicTacToeApp());
}

class SuperTicTacToeApp extends StatefulWidget {
  const SuperTicTacToeApp({super.key});

  @override
  State<SuperTicTacToeApp> createState() => _SuperTicTacToeAppState();
}

class _SuperTicTacToeAppState extends State<SuperTicTacToeApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: GamePage(),
    );
  }
}
