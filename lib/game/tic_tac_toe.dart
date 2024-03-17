import 'package:super_tictactoe/game/player.dart';
import 'package:super_tictactoe/game/tic_tac_toe_rules.dart';
import 'package:super_tictactoe/game/winning_player.dart';

class TicTacToe {
  final int boardDimension;
  final TicTacToeRules rules;
  final List<List<Player?>> _board;

  TicTacToe({
    required this.boardDimension,
    this.rules = const TicTacToeRules(),
  }) : _board = List.generate(
          boardDimension,
          (index) => List.generate(boardDimension, (index) => null),
        );

  Player _currentPlayer = Player.X;
  WinningPlayer? _winner;

  bool get playing => winner == null;
  Player get currentPlayer => _currentPlayer;
  WinningPlayer? get winner => _winner;

  Player? getBoardPosition(int row, int col) {
    return _board[row][col];
  }

  /// Make a move on the board.
  ///
  /// If an invalid move is attempted, nothing will happen.
  ///
  /// The [asPlayer] parameter can be used to choose a player to move.
  /// If it is not provided, the [currentPlayer] will be used instead, which will be cycled after the move.
  MoveResult makeMove(int row, int col, {Player? asPlayer}) {
    if (!playing) return const MoveResult.NotPlaying();

    final existing = _board[row][col];
    if (existing != null) {
      return const MoveResult.PositionNotEmpty();
    }

    if (rules.noFirstMoveCenter && !everyPlayerHasPlayed) {
      final centerIndices = _centerIndices;
      if (centerIndices.contains((row, col))) return const MoveResult.CenterUnavailble();
    }

    _board[row][col] = asPlayer ?? currentPlayer;

    final winningPlayer = _checkForWins();
    if (winningPlayer != null) {
      _winner = winningPlayer;
      return MoveResult.WinningMove(winningPlayer: winningPlayer);
    }

    if (asPlayer == null) {
      _cyclePlayer();
    }

    return const MoveResult.Normal();
  }

  void _cyclePlayer() {
    _currentPlayer = _currentPlayer.nextPlayer;
  }

  WinningPlayer? _checkForWins() {
    // For each row, check column by column
    for (int row = 0; row < boardDimension; row++) {
      // Potential winner is the first player in the row
      Player? winnerInThisRow = _board[row][0];

      // If no potential winner, go to next row
      if (winnerInThisRow == null) continue;

      // Check remaining columns
      for (int col = 1; col < boardDimension; col++) {
        final player = _board[row][col];
        // If player is not potential winner, row is no longer candidate
        if (player != winnerInThisRow) {
          winnerInThisRow = null;
          break;
        }
      }

      // If potential winner is still not null, that means each column was the same as potential winner
      // Winner found
      if (winnerInThisRow != null) {
        return WinningPlayer(
          player: winnerInThisRow,
          winningIndices: List.generate(boardDimension, (index) => (row, index)),
        );
      }
    }

    // For each column, check row by row
    for (int col = 0; col < boardDimension; col++) {
      // Potential winner is the first player in this column
      Player? winnerInThisColumn = _board[0][col];

      // If no potential winner, go to next column
      if (winnerInThisColumn == null) continue;

      // Check remaining columns
      for (int row = 0; row < boardDimension; row++) {
        final player = _board[row][col];
        // If player is not potential winner, column is no longer candidate
        if (player != winnerInThisColumn) {
          winnerInThisColumn = null;
          break;
        }
      }

      // If potential winner is still not null, that means each row was the same as potential winner
      // Winner found
      if (winnerInThisColumn != null) {
        return WinningPlayer(
          player: winnerInThisColumn,
          winningIndices: List.generate(boardDimension, (index) => (index, col)),
        );
      }
    }

    // Check diagonal (tlBr = top left -> bottom right)
    final tlBrIndices = List.generate(boardDimension, (index) => (index, index));
    final tlBr = _board[tlBrIndices.first.$1][tlBrIndices.first.$2];
    if (tlBr != null && tlBrIndices.every((index) => tlBr == _board[index.$1][index.$2])) {
      return WinningPlayer(player: tlBr, winningIndices: tlBrIndices);
    }

    // Check diagonal (blTr = bottom left -> top right)
    final blTrIndices = List.generate(boardDimension, (index) => (boardDimension - index - 1, index));
    final blTr = _board[blTrIndices.first.$1][blTrIndices.first.$2];
    if (blTr != null && blTrIndices.every((index) => blTr == _board[index.$1][index.$2])) {
      return WinningPlayer(player: blTr, winningIndices: blTrIndices);
    }

    return null;
  }

  List<(int, int)> get _centerIndices {
    if (boardDimension.isOdd) {
      final index = boardDimension ~/ 2;
      return [(index, index)];
    } else {
      final upper = boardDimension ~/ 2;
      final lower = upper - 1;
      return [
        (lower, lower),
        (lower, upper),
        (upper, lower),
        (upper, upper),
      ];
    }
  }

  bool _playerHasPlayed(Player player) {
    for (final row in _board) {
      for (final played in row) {
        if (played == player) {
          return true;
        }
      }
    }

    return false;
  }

  bool get everyPlayerHasPlayed => Player.values.every(_playerHasPlayed);
}

sealed class MoveResult {
  const MoveResult();

  const factory MoveResult.NotPlaying() = MoveResult$NotPlaying;

  const factory MoveResult.PositionNotEmpty() = MoveResult$PositionNotEmpty;

  const factory MoveResult.CenterUnavailble() = MoveResult$CenterUnavailable;

  const factory MoveResult.WinningMove({required WinningPlayer winningPlayer}) = MoveResult$WinningMove;

  const factory MoveResult.Normal() = MoveResult$Normal;
}

class MoveResult$NotPlaying extends MoveResult {
  const MoveResult$NotPlaying();
}

class MoveResult$PositionNotEmpty extends MoveResult {
  const MoveResult$PositionNotEmpty();
}

class MoveResult$CenterUnavailable extends MoveResult {
  const MoveResult$CenterUnavailable();
}

class MoveResult$WinningMove extends MoveResult {
  final WinningPlayer winningPlayer;

  const MoveResult$WinningMove({required this.winningPlayer});
}

class MoveResult$Normal extends MoveResult {
  const MoveResult$Normal();
}
