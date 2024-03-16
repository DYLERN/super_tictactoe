import 'package:super_tictactoe/game/player.dart';
import 'package:super_tictactoe/game/tic_tac_toe.dart';
import 'package:super_tictactoe/game/winning_player.dart';

class SuperTicTacToe {
  final int boardDimension;
  final List<TicTacToe> _innerGames;

  SuperTicTacToe({required this.boardDimension})
      : _innerGames = List.generate(
          boardDimension * boardDimension,
          (index) => TicTacToe(boardDimension: boardDimension),
        );

  Player _currentPlayer = Player.X;
  final Map<(int, int), WinningPlayer> _winners = {};
  WinningPlayer? _overallWinner;

  Player get currentPlayer => _currentPlayer;
  WinningPlayer? getWinner(int row, int col) => _winners[(row, col)];
  bool get playing => overallWinner == null;
  WinningPlayer? get overallWinner => _overallWinner;

  Player? getInnerGameBoardPosition((int, int) game, (int, int) position) {
    final innerGame = _innerGames[game.$1 * boardDimension + game.$2];
    return innerGame.getBoardPosition(position.$1, position.$2);
  }

  void makeMove((int, int) game, (int, int) position) {
    if (!playing) return;

    final innerGame = _innerGames[game.$1 * boardDimension + game.$2];
    innerGame.makeMove(position.$1, position.$2, asPlayer: currentPlayer);

    if (innerGame.winner case final winner?) {
      _winners[game] = winner;
      final overallWinner = _checkForWinsAboutIndex(game);
      if (overallWinner != null) {
        _overallWinner = overallWinner;
        return;
      }
    }

    _currentPlayer = _currentPlayer.nextPlayer;
  }

  WinningPlayer? _checkForWinsAboutIndex((int, int) index) {
    final (row, col) = index;

    final playersInRow = List.generate(boardDimension, (i) => _winners[(row, i)]);
    if (playersInRow.first case final player? when playersInRow.every((p) => p?.player == player.player)) {
      return player;
    }

    final playersInCol = List.generate(boardDimension, (i) => _winners[(i, col)]);
    if (playersInCol.first case final player? when playersInCol.every((p) => p?.player == player.player)) {
      return player;
    }

    return null;
  }
}
