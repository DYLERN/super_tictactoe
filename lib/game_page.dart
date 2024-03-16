import 'package:flutter/material.dart';
import 'package:super_tictactoe/game/player.dart';
import 'package:super_tictactoe/game/super_tic_tac_toe.dart';
import 'package:super_tictactoe/game_grid.dart';
import 'package:super_tictactoe/player_sprite.dart';

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
      body: _SuperGrid(
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

class _SuperGrid extends StatelessWidget {
  final SuperTicTacToe game;
  final void Function((int, int) gameIndex, (int, int) position) onPlayMade;

  const _SuperGrid({required this.game, required this.onPlayMade});

  @override
  Widget build(BuildContext context) {
    return GameGrid(
      boardDimension: game.boardDimension,
      children: [
        for (int gameRow = 0; gameRow < game.boardDimension; gameRow++)
          for (int gameCol = 0; gameCol < game.boardDimension; gameCol++)
            Builder(builder: (context) {
              if (game.getWinner(gameRow, gameCol) case final innerWinner?) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: PlayerSprite(player: innerWinner),
                );
              }

              return GameGrid(
                boardDimension: game.boardDimension,
                children: [
                  for (int row = 0; row < game.boardDimension; row++)
                    for (int col = 0; col < game.boardDimension; col++)
                      Builder(
                        builder: (context) {
                          final player = game.getInnerGameBoardPosition((gameRow, gameCol), (row, col));

                          void play() => onPlayMade((gameRow, gameCol), (row, col));
                          return _GameTile(
                            player: player,
                            onPressed: player == null && game.playing ? play : null,
                          );
                        },
                      ),
                ],
              );
            }),
      ],
    );
  }
}

class _GameTile extends StatelessWidget {
  final Player? player;
  final VoidCallback? onPressed;

  const _GameTile({
    required this.player,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: switch (player) {
        null => null,
        final player => Padding(
            padding: const EdgeInsets.all(16.0),
            child: PlayerSprite(player: player),
          ),
      },
    );
  }
}
