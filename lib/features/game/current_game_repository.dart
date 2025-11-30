import 'current_game_dao.dart';
import 'current_game_model.dart';
import 'board_model.dart';
import '../core/logger.dart';

class CurrentGameRepository {
  final CurrentGameDao dao;

  CurrentGameRepository(this.dao);

  Future<CurrentGameLocal?> loadGame(int userId) async {
    return await dao.getByUser(userId);
  }

  Future<CurrentGameLocal> startNewGame({
    required int userId,
    required int rows,
    required int columns,
    required int colorPlayer1,
    required int colorPlayer2,
    int? timeLimit,
  }) async {
    final boardState = Board(rows: rows, columns: columns).serialize();

    final newGame = CurrentGameLocal(
      gameId: 0,
      userId: userId,
      rows: rows,
      columns: columns,
      colorPlayer1: colorPlayer1,
      colorPlayer2: colorPlayer2,
      timeLimit: timeLimit,
      boardState: boardState,
      currentPlayer: 1,
    );

    await dao.create(newGame);

    return newGame.copyWith();
  }

  Future<void> saveGame(CurrentGameLocal game) async {
    logger.info("come to saveGame in CurrentGameRepository");
    await dao.update(game);
  }

  Future<void> deleteGame(int gameId) async {
    await dao.delete(gameId);
  }
}
