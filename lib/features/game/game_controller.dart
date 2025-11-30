import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'board_model.dart';
import 'cell_states.dart';
import '../core/game_constants.dart';
import '../statistics/statistics_controller.dart';
import 'current_game_model.dart';
import 'current_game_repository.dart';
import '../core/logger.dart';

class GameController {
  final StatisticsController _statisticsController;
  final CurrentGameRepository _currentGameRepository;
  final int _userId;

  CurrentGameLocal? _currentGame;
  CurrentGameLocal get currentGame => _currentGame!;

  late CellState currentPlayer;
  late Board currentBoard;
  bool gameOver = false;
  CellState? winner;

  GameController(
    this._statisticsController,
    this._currentGameRepository,
    this._userId,
  );

  Future<void> loadCurrentGame() async {
    _currentGame = await _currentGameRepository.loadGame(_userId);
  }

  Future<void> startNewGame({
    required int userId,
    required int rows,
    required int columns,
    required int colorPlayer1,
    required int colorPlayer2,
    int? timeLimit,
  }) async {
    if (_currentGame != null) {
      _currentGameRepository.deleteGame(_currentGame!.gameId);
    }

    _currentGame = await _currentGameRepository.startNewGame(
      userId: _userId,
      rows: rows,
      columns: columns,
      colorPlayer1: colorPlayer1,
      colorPlayer2: colorPlayer2,
      timeLimit: timeLimit,
    );

    currentPlayer = CellState.values[_currentGame!.currentPlayer];
    currentBoard = Board.deserialize(_currentGame!.boardState);
    gameOver = false;
    winner = null;
  }

  /// Makes the player's move
  Future<bool> makeMove(int column) async {
    if (gameOver) return false;
    logger.info("gameController makeMove");
    // final CellState currentPlayer =
    //     CellState.values[_currentGame!.currentPlayer];

    // final board = Board.deserialize(_currentGame!.boardState);
    logger.info("gameController DBboardState ${_currentGame!.boardState}");
    logger.info("gameController LOCALboardState ${currentBoard.serialize()}");
    final row = currentBoard.dropToken(column, currentPlayer);
    logger.info("gameController row $row column $column");
    // int row = board.dropToken(column, currentPlayer);
    if (row == -1) return false;

    if (_checkWin(row, column, currentBoard)) {
      gameOver = true;
      winner = currentPlayer;
    } else if (currentBoard.isFull) {
      gameOver = true;
      winner = null;
    } else {
      _switchPlayer();
      logger.info(
        "gameController LOCALboardState before save ${currentBoard.serialize()}",
      );
      _currentGame = _currentGame!.copyWith(
        boardState: currentBoard.serialize(),
        currentPlayer: currentPlayer.index,
      );
      await _currentGameRepository.saveGame(_currentGame!);
      logger.info(
        "gameController DBboardState after save ${_currentGame!.boardState}",
      );
      logger.info("gameController _switchPlayer $currentPlayer");
    }
    return true;
  }

  void _switchPlayer() {
    currentPlayer = (currentPlayer == CellState.player1)
        ? CellState.player2
        : CellState.player1;
  }

  bool _checkWin(int row, int column, Board board) {
    const checkedDirections = [
      /// horizontal → (row changes to 0, column changes to +1)
      [0, 1],

      /// vertical ↓ (row changes to +1, column changes to 0)
      [1, 0],

      /// diagonal ↘ (row and column change to +1)
      [1, 1],

      /// diagonal ↙ (row changes to +1, column changes to -1)
      [1, -1],
    ];

    for (var dir in checkedDirections) {
      int count = 1;
      count += _countInDirection(row, column, dir[0], dir[1], board);
      count += _countInDirection(row, column, -dir[0], -dir[1], board);
      if (count >= GameConstants.connectToWin) return true;
    }
    return false;
  }

  int _countInDirection(
    int currentRow,
    int currentCol,
    int dRow,
    int dCol,
    Board board,
  ) {
    int count = 0;
    // CellState player = board.grid[currentRow][currentCol];
    int r = currentRow + dRow;
    int c = currentCol + dCol;

    while (r >= 0 &&
        r < board.rows &&
        c >= 0 &&
        c < board.columns &&
        board.grid[r][c] == currentPlayer) {
      count++;
      r += dRow;
      c += dCol;
    }
    return count;
  }

  // TODO: при перезапуске игры первым должен холдиться другой игрок, создать функцию генерации поля в классе board?
  // void reset() {
  //   board.grid = List.generate(
  //     board.rows,
  //     (_) => List.generate(board.columns, (_) => CellState.empty),
  //   );
  //   currentPlayer = CellState.player1;
  //   gameOver = false;
  //   winner = null;
  // }

  void saveStatistics() {
    _statisticsController.addGameResult(
      winner: winner == null ? null : (winner == CellState.player1 ? 1 : 2),
    );
  }

  void onExitGamePressed(BuildContext context) {
    debugPrint('Выход из игры');
    context.go('/');
  }
}
