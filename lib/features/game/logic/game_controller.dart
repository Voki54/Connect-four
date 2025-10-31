import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/board.dart';
import '../models/cell.dart';
import '../../core/constant/game_constants.dart';

class GameController {
  final Board board;
  CellState currentPlayer;
  bool gameOver = false;
  CellState? winner;

  GameController({int rows = GameConstants.defaultRows, int columns = GameConstants.defaultColumns})
      : board = Board(rows: rows, columns: columns), currentPlayer = CellState.player1;

  /// Makes the player's move
  bool makeMove(int column) {
    if (gameOver) return false;

    int row = board.dropToken(column, currentPlayer);
    if (row == -1) return false;

    if (_checkWin(row, column)) {
      gameOver = true;
      winner = currentPlayer;
    } else if (board.isFull) {
      gameOver = true;
      winner = null;
    } else {
      _switchPlayer();
    }
    return true;
  }

  void _switchPlayer() {
    currentPlayer =
        (currentPlayer == CellState.player1) ? CellState.player2 : CellState.player1;
  }

  bool _checkWin(int row, int column) {
    const checkedDirections = [
      [0, 1], /// horizontal → (row changes to 0, column changes to +1)
      [1, 0], /// vertical ↓ (row changes to +1, column changes to 0)
      [1, 1], /// diagonal ↘ (row and column change to +1)
      [1, -1], /// diagonal ↙ (row changes to +1, column changes to -1)
    ];

    for (var dir in checkedDirections) {
      int count = 1;
      count += _countInDirection(row, column, dir[0], dir[1]);
      count += _countInDirection(row, column, -dir[0], -dir[1]);
      if (count >= GameConstants.connectToWin) return true;
    }
    return false;
  }

  int _countInDirection(int row, int column, int dRow, int dCol) {
    int count = 0;
    CellState player = board.grid[row][column];
    int r = row + dRow;
    int c = column + dCol;

    while (r >= 0 && r < board.rows && c >= 0 && c < board.columns && board.grid[r][c] == player) {
      count++;
      r += dRow;
      c += dCol;
    }
    return count;
  }

  // TODO: при перезапуске игры первым должен холдиться другой игрок, создать функциюгенерации поля в классе board?
  // void reset() {
  //   board.grid = List.generate(
  //     board.rows,
  //     (_) => List.generate(board.columns, (_) => CellState.empty),
  //   );
  //   currentPlayer = CellState.player1;
  //   gameOver = false;
  //   winner = null;
  // }

  void onExitGamePressed(BuildContext context) {
    debugPrint('Выход из игры');
    context.go('/');
  }
}
