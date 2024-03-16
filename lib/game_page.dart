import 'package:flutter/material.dart';
import 'package:super_tictactoe/game/player.dart';
import 'package:super_tictactoe/game/tic_tac_toe.dart';
import 'package:super_tictactoe/game_grid.dart';
import 'package:super_tictactoe/player_sprite.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final outerGame = TicTacToe(boardDimension: 3);
  late final innerGames = List.generate(
    outerGame.boardDimension * outerGame.boardDimension,
    (_) => TicTacToe(boardDimension: 3),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameGrid(
        boardDimension: outerGame.boardDimension,
        children: [
          for (final game in innerGames)
            Builder(builder: (context) {
              if (game.winner case final winner?) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: PlayerSprite(player: winner.player),
                );
              }

              return GameGrid(
                boardDimension: game.boardDimension,
                children: [
                  for (int row = 0; row < game.boardDimension; row++)
                    for (int col = 0; col < game.boardDimension; col++)
                      Builder(
                        builder: (context) {
                          final player = game.getBoardPosition(row, col);

                          void play() => makePlay(game, row, col);
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
      ),
    );
  }

  void makePlay(TicTacToe game, int row, int col) {
    setState(() => game.makeMove(row, col));
    final winner = game.winner;
    if (winner != null) {}
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
