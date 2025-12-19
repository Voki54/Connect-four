import 'current_game_dao.dart';
import 'current_game_model.dart';
import 'board_model.dart';
import '../core/logger.dart';

class CurrentGameRepository {
  final CurrentGameDao dao;

  CurrentGameRepository(this.dao);

  Future<CurrentGameLocal?> loadGame() async {
    return await dao.getByUser();
  }

  Future<CurrentGameLocal> startNewGame({
    required int rows,
    required int columns,
    required int colorPlayer1,
    required int colorPlayer2,
    int? timeLimit,
  }) async {
    final boardState = Board(rows: rows, columns: columns).serialize();

    return await dao.create(
      rows: rows,
      columns: columns,
      colorPlayer1: colorPlayer1,
      colorPlayer2: colorPlayer2,
      boardState: boardState,
    );
  }

  Future<void> saveGame(CurrentGameLocal game) async {
    logger.info("come to saveGame in CurrentGameRepository");
    await dao.update(game);
  }

  Future<void> deleteGame(int gameId) async {
    await dao.delete(gameId);
  }
}
