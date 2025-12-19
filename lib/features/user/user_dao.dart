import 'package:connect_four/features/statistics/statistics_model.dart';

import '../core/local_database.dart';
import 'user_model.dart';
import '../core/logger.dart';

class UserDao {
  final AppDatabase _appDatabase;

  UserDao(this._appDatabase);

  Future<int> createUser(UserLocal user) async {
    final db = await _appDatabase.db;
    return await db.insert('UserLocal', user.toMap());
  }

  Future<UserLocal?> getUser() async {
    final db = await _appDatabase.db;
    final result = await db.query(
      'UserLocal',
      where: 'is_current = ?',
      whereArgs: [1],
      limit: 1,
    );

    if (result.isEmpty) return null;
    return UserLocal.fromMap(result.first);
  }

  Future<UserLocal?> getUserByAuthId(String authId) async {
    final db = await _appDatabase.db;
    final result = await db.query(
      'UserLocal',
      where: 'auth_id = ?',
      whereArgs: [authId],
      limit: 1,
    );

    if (result.isEmpty) return null;
    return UserLocal.fromMap(result.first);
  }

  Future<int> updateUser(UserLocal user) async {
    final db = await _appDatabase.db;

logger.info("UserDao: Updated");

    return db.update(
      'UserLocal',
      user.toMap(),
      where: 'local_id = ?',
      whereArgs: [user.localId],
    );
    
  }

  Future<int> updateUserStatistcs(StatisticsLocal stats) async {
    final UserLocal? user = await getUser();
    if (user == null) {
      throw Exception('No user was detected when update user statistcs!');
    }

    final updatedUser = user.copyWith(
      totalGames: stats.totalGames,
      winsPlayer1: stats.winsPlayer1,
      winsPlayer2: stats.winsPlayer2,
      draws: stats.draws,
    );
    // logger.info(
    //   "updated stats - ${stats.totalGames}, ${stats.winsPlayer1}, ${stats.winsPlayer2}, ${stats.draws}",
    // );
    final db = await _appDatabase.db;

    return db.update(
      'UserLocal',
      updatedUser.toMap(),
      where: 'local_id = ?',
      whereArgs: [updatedUser.localId],
    );
  }
}
