import 'package:flutter/material.dart';
import 'package:super_tictactoe/game/player.dart';
import 'package:super_tictactoe/player_sprite.dart';

class TicTacToeTile extends StatelessWidget {
  final Player? player;
  final VoidCallback? onPressed;
  final EdgeInsets padding;

  const TicTacToeTile({
    super.key,
    required this.player,
    required this.onPressed,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: switch (player) {
        null => null,
        final player => Padding(
            padding: padding,
            child: PlayerSprite(player: player),
          ),
      },
    );
  }
}
