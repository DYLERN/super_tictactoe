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
  final Map<(int, int), Player> _winners = {};
  WinningPlayer? _overallWinner;

  Player get currentPlayer => _currentPlayer;
  Player? getWinner(int row, int col) => _winners[(row, col)];
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
      _winners[game] = winner.player;
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

    final rowIndices = List.generate(boardDimension, (i) => (row, i));
    final playersInRow = rowIndices.map((e) => _winners[e]);
    if (playersInRow.winningPlayer case final winner?) {
      return WinningPlayer(player: winner, winningIndices: rowIndices);
    }

    final colIndices = List.generate(boardDimension, (i) => (i, col));
    final playersInCol = colIndices.map((e) => _winners[e]);
    if (playersInCol.winningPlayer case final winner?) {
      return WinningPlayer(player: winner, winningIndices: colIndices);
    }

    if (row == col) {
      final diagonalIndices = List.generate(boardDimension, (index) => (index, index));
      final playersOnDiagonal = diagonalIndices.map((e) => _winners[e]);
      if (playersOnDiagonal.winningPlayer case final winner?) {
        return WinningPlayer(player: winner, winningIndices: diagonalIndices);
      }
    }

    if (boardDimension - row - 1 == col) {
      final diagonalIndices = List.generate(boardDimension, (i) => (boardDimension - i - 1, i));
      final playersOnDiagonal = diagonalIndices.map((e) => _winners[e]);
      if (playersOnDiagonal.winningPlayer case final winner?) {
        return WinningPlayer(player: winner, winningIndices: diagonalIndices);
      }
    }

    return null;
  }
}

extension _WinningPlayerIterableExtension on Iterable<Player?> {
  Player? get winningPlayer {
    if (first case final player? when every((p) => p == player)) {
      return player;
    } else {
      return null;
    }
  }
}
