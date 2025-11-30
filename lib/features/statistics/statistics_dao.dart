import '../core/local_database.dart';
import 'statistics_model.dart';

class StatisticsDao {
  final AppDatabase _appDatabase;

  StatisticsDao(this._appDatabase);

  Future<StatisticsLocal?> getByUser(int userId) async {
    final db = await _appDatabase.db;
    final result = await db.query(
      'StatisticsLocal',
      where: 'user_id = ?',
      whereArgs: [userId],
      limit: 1,
    );
    if (result.isEmpty) return null;
    return StatisticsLocal.fromMap(result.first);
  }

  Future<int> createEmpty(int userId) async {
    final db = await _appDatabase.db;
    return await db.insert('StatisticsLocal', {
      'user_id': userId,
      'total_Games': 0,
      'wins_player1': 0,
      'wins_player2': 0,
      'draws': 0,
      'last_sync': null,
    });
  }

  Future<void> update(StatisticsLocal stats) async {
    final db = await _appDatabase.db;
    await db.update(
      'StatisticsLocal',
      stats.toMap(),
      where: 'stat_id = ?',
      whereArgs: [stats.statId],
    );
  }
}
