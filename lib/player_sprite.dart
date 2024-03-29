import 'package:flutter/material.dart';
import 'package:super_tictactoe/game/player.dart';

class PlayerSprite extends StatelessWidget {
  final Player player;
  final Size size;

  const PlayerSprite({
    super.key,
    required this.player,
    this.size = Size.zero,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: size,
      painter: switch (player) {
        Player.X => _PlayerXPainter(),
        Player.O => _PlayerOPainter(),
      },
    );
  }
}

class _PlayerXPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = Colors.black;
    paint.strokeWidth = 2.0;

    canvas.drawLine(Offset.zero, Offset(size.width, size.height), paint);
    canvas.drawLine(Offset(0, size.height), Offset(size.width, 0), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class _PlayerOPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = Colors.black;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 2.0;

    final ovalRect = Rect.fromLTWH(0, 0, size.width, size.height);

    canvas.drawOval(ovalRect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
