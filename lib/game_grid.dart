import 'dart:math';

import 'package:flutter/material.dart';

class GameGrid extends StatelessWidget {
  final int boardDimension;
  final List<Widget> children;

  const GameGrid({
    super.key,
    required this.boardDimension,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Table(
        columnWidths: {
          for (int columnIndex = 0; columnIndex < boardDimension; columnIndex++) columnIndex: const FlexColumnWidth(1),
        },
        border: const TableBorder(
          verticalInside: BorderSide(color: Colors.black),
          horizontalInside: BorderSide(color: Colors.black),
        ),
        children: [
          for (int row = 0; row < boardDimension; row++)
            TableRow(
              children: [
                for (int col = 0; col < boardDimension; col++)
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Builder(builder: (context) {
                          final index = boardDimension * row + col;
                          if (children.length > index) {
                            return children[index];
                          } else {
                            return const SizedBox.shrink();
                          }
                        }),
                      ),
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
