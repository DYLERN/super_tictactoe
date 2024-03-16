import 'package:flutter/material.dart';
import 'package:super_tictactoe/game/super_tic_tac_toe.dart';
import 'package:super_tictactoe/super_grid.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final game = SuperTicTacToe(boardDimension: 3);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SuperGrid(
        game: game,
        onPlayMade: makePlay,
      ),
    );
  }

  void makePlay((int, int) game, (int, int) position) {
    setState(() => this.game.makeMove(game, position));
    if (this.game.overallWinner case final winner?) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${winner.player.name} wins the game with ${winner.winningIndices}!')),
      );
    }
  }
}
