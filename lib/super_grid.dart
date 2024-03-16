import 'package:flutter/material.dart';
import 'package:super_tictactoe/game/super_tic_tac_toe.dart';
import 'package:super_tictactoe/game_grid.dart';
import 'package:super_tictactoe/player_sprite.dart';
import 'package:super_tictactoe/tic_tac_toe_tile.dart';

class SuperGrid extends StatelessWidget {
  final SuperTicTacToe game;
  final void Function((int, int) gameIndex, (int, int) position) onPlayMade;
  final EdgeInsets interGamePadding;
  final EdgeInsets intraTilePadding;

  const SuperGrid({
    super.key,
    required this.game,
    required this.onPlayMade,
    this.interGamePadding = const EdgeInsets.all(16.0),
    this.intraTilePadding = const EdgeInsets.all(8.0),
  });

  @override
  Widget build(BuildContext context) {
    return GameGrid(
      boardDimension: game.boardDimension,
      children: [
        for (int gameRow = 0; gameRow < game.boardDimension; gameRow++)
          for (int gameCol = 0; gameCol < game.boardDimension; gameCol++)
            Padding(
              padding: interGamePadding,
              child: Builder(builder: (context) {
                if (game.getWinner(gameRow, gameCol) case final innerWinner?) {
                  return PlayerSprite(player: innerWinner);
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
                            return TicTacToeTile(
                              player: player,
                              onPressed: player == null && game.playing ? play : null,
                              padding: intraTilePadding,
                            );
                          },
                        ),
                  ],
                );
              }),
            ),
      ],
    );
  }
}
