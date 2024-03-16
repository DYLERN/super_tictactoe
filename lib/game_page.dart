import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
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
      appBar: AppBar(
        title: const Text('Super Tic-Tac-Toe'),
        centerTitle: false,
        actions: [
          FilledButton(
            onPressed: () {},
            child: const Text('RESET'),
          ),
          const Gap(8.0),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: SuperGrid(
                  game: game,
                  onPlayMade: makePlay,
                ),
              ),
              const Gap(8.0),
              Text(
                'Currently playing: ${game.currentPlayer.name}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ),
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
