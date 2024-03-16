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
  Player get currentPlayer => _currentPlayer;

  final Map<(int, int), WinningPlayer> _winners = {};
  WinningPlayer? getWinner(int row, int col) => _winners[(row, col)];

  Player? getInnerGameBoardPosition((int, int) game, (int, int) position) {
    final innerGame = _innerGames[game.$1 * boardDimension + game.$2];
    return innerGame.getBoardPosition(position.$1, position.$2);
  }

  void makeMove((int, int) game, (int, int) position) {
    final innerGame = _innerGames[game.$1 * boardDimension + game.$2];
    innerGame.makeMove(position.$1, position.$2, asPlayer: currentPlayer);

    if (innerGame.winner case final winner?) {
      _winners[game] = winner;
    }

    _currentPlayer = _currentPlayer.nextPlayer;
  }
}
