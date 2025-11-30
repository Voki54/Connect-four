import '../core/local_database.dart';
import 'current_game_model.dart';
import '../core/logger.dart';

class CurrentGameDao {
  final AppDatabase _appDatabase;

  CurrentGameDao(this._appDatabase);

  Future<CurrentGameLocal?> getByUser(int userId) async {
    final database = await _appDatabase.db;
    final result = await database.query(
      'CurrentGame',
      where: 'user_id = ?',
      whereArgs: [userId],
      limit: 1,
    );

    if (result.isEmpty) return null;
    return CurrentGameLocal.fromMap(result.first);
  }

  Future<int> create(CurrentGameLocal game) async {
    final database = await _appDatabase.db;
    return await database.insert('CurrentGame', game.toMap());
  }

  Future<void> update(CurrentGameLocal game) async {
    logger.info("come to update in CurrentGameDao");
    final database = await _appDatabase.db;
    logger.info("db open? - ${database.isOpen}");
    await database.update(
      'CurrentGame',
      game.toMap(),
      where: 'game_id = ?',
      whereArgs: [game.gameId],
    );
  }

  Future<void> delete(int gameId) async {
    final database = await _appDatabase.db;
    await database.delete(
      'CurrentGame',
      where: 'game_id = ?',
      whereArgs: [gameId],
    );
  }
}
