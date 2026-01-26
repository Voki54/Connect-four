import 'package:connect_four/features/game/win_cell.dart';
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

  CurrentGameLocal? _currentGame;
  CurrentGameLocal get currentGame => _currentGame!;

  late CellState currentPlayer;
  late Board currentBoard;
  bool gameOver = false;
  CellState? winner;
  CellState startingPlayer = CellState.player1;

  List<WinCell> winningCells = [];

  GameController(this._statisticsController, this._currentGameRepository);

  Future<void> loadCurrentGame() async {
    _currentGame = await _currentGameRepository.loadGame();
  }

  Future<void> startNewGame({
    required int rows,
    required int columns,
    required int colorPlayer1,
    required int colorPlayer2,
    int? timeLimit,
  }) async {
    if (_currentGame != null) {
      _currentGameRepository.deleteGame(_currentGame!.gameId!);
    }

    winningCells = [];

    _currentGame = await _currentGameRepository.startNewGame(
      rows: rows,
      columns: columns,
      colorPlayer1: colorPlayer1,
      colorPlayer2: colorPlayer2,
      timeLimit: timeLimit,
    );

    currentPlayer = startingPlayer;
    currentBoard = Board.deserialize(_currentGame!.boardState);
    gameOver = false;
    winner = null;
  }

  Future<void> startNewGameWithSwitchedStarter({
    required int rows,
    required int columns,
    required int colorPlayer1,
    required int colorPlayer2,
    int? timeLimit,
  }) async {
    // Переключаем стартового игрока
    startingPlayer = startingPlayer == CellState.player1
        ? CellState.player2
        : CellState.player1;

    await startNewGame(
      rows: rows,
      columns: columns,
      colorPlayer1: colorPlayer1,
      colorPlayer2: colorPlayer2,
      timeLimit: timeLimit,
    );
  }

  /// Makes the player's move
  Future<bool> makeMove(int column) async {
    if (_currentGame == null) {
      throw Exception('_currentGame is null!');
    }

    if (gameOver) return false;
    logger.info("gameController makeMove");
    logger.info("gameController DBboardState ${_currentGame!.boardState}");
    logger.info("gameController LOCALboardState ${currentBoard.serialize()}");
    final row = currentBoard.dropToken(column, currentPlayer);
    logger.info("gameController row $row column $column");
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
      final line = <WinCell>[];
      line.add(WinCell(row, column));

      _collectInDirection(row, column, dir[0], dir[1], board, line);

      // в обратную сторону
      _collectInDirection(row, column, -dir[0], -dir[1], board, line);

      if (line.length >= GameConstants.connectToWin) {
        winningCells = line;
        return true;
      }
    }
    return false;
  }

  void _collectInDirection(
    int startRow,
    int startCol,
    int dRow,
    int dCol,
    Board board,
    List<WinCell> result,
  ) {
    int r = startRow + dRow;
    int c = startCol + dCol;

    while (r >= 0 &&
        r < board.rows &&
        c >= 0 &&
        c < board.columns &&
        board.grid[r][c] == currentPlayer) {
      result.add(WinCell(r, c));
      r += dRow;
      c += dCol;
    }
  }

  Future<void> saveStatistics() async {
    await _statisticsController.addGameResult(
      winner: winner == null ? null : (winner == CellState.player1 ? 1 : 2),
    );
  }
}
