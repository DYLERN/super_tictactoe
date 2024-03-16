class TicTacToe {
  final int boardDimension;
  final List<List<Player?>> _board;

  TicTacToe({required this.boardDimension})
      : _board = List.generate(
          boardDimension,
          (index) => List.generate(boardDimension, (index) => null),
        );

  bool _playing = true;
  Player _currentPlayer = Player.X;
  WinningPlayer? _winner;

  bool get playing => _playing;
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
  void makeMove(int row, int col, {Player? asPlayer}) {
    if (!playing) return;

    final existing = _board[row][col];
    if (existing != null) {
      return;
    }

    _board[row][col] = asPlayer ?? currentPlayer;

    final winningPlayer = _checkForWins();
    if (winningPlayer != null) {
      _playing = false;
      _winner = winningPlayer;
      return;
    }

    if (asPlayer == null) {
      _cyclePlayer();
    }

    return;
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
}

enum Player {
  X,
  O;

  Player get nextPlayer => switch (this) {
        Player.X => Player.O,
        Player.O => Player.X,
      };
}

class WinningPlayer {
  final Player player;
  final List<(int, int)> winningIndices;

  const WinningPlayer({required this.player, required this.winningIndices});
}
