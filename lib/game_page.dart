import 'dart:math';

import 'package:flutter/material.dart';
import 'package:super_tictactoe/game.dart';
import 'package:super_tictactoe/player_sprite.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final game = Game(boardDimension: 3);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final minDimension = min(constraints.maxWidth, constraints.maxHeight);
          return Center(
            child: Container(
              width: minDimension,
              height: minDimension,
              padding: const EdgeInsets.all(16.0),
              child: Table(
                columnWidths: {
                  for (int columnIndex = 0; columnIndex < game.boardDimension; columnIndex++)
                    columnIndex: const FlexColumnWidth(1),
                },
                border: const TableBorder(
                  verticalInside: BorderSide(color: Colors.black),
                  horizontalInside: BorderSide(color: Colors.black),
                ),
                children: [
                  for (int row = 0; row < game.boardDimension; row++)
                    TableRow(
                      children: [
                        for (int col = 0; col < game.boardDimension; col++)
                          TableCell(
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: Builder(
                                builder: (context) {
                                  final player = game.getBoardPosition(row, col);

                                  void play() => makePlay(row, col);

                                  return _GameTile(
                                    player: player,
                                    onPressed: player == null && game.playing ? play : null,
                                  );
                                },
                              ),
                            ),
                          ),
                      ],
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void makePlay(int row, int col) {
    setState(() => game.makeMove(row, col));
    final winner = game.winner;
    if (winner != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${winner.player.name} has won!')));
    }
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
