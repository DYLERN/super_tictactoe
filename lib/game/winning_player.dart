import 'package:super_tictactoe/game/player.dart';

class WinningPlayer {
  final Player player;
  final List<(int, int)> winningIndices;

  const WinningPlayer({required this.player, required this.winningIndices});
}
