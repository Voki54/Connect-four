import 'package:connect_four/features/core/logger.dart';
import 'package:connect_four/features/user/user_dao.dart';
import 'package:uuid/uuid.dart';

import '../../core/local_database.dart';
import 'pending_statistics_model.dart';
import '../statistics_model.dart';

class PendingStatisticsDao {
  final AppDatabase _appDatabase;
  final UserDao _userDao;

  PendingStatisticsDao(this._appDatabase, this._userDao);

  Future<PendingStatistics?> getByUser(int userId) async {
    final user = await _userDao.getUser();
    if (user == null) {
      throw Exception("user == null during get PendingStatistics");
    }

    if (user.isGuest) {
      return null;
    }

    final db = await _appDatabase.db;
    final result = await db.query(
      'PendingStatistics',
      where: 'user_id = ?',
      whereArgs: [userId],
      limit: 1,
    );
    if (result.isEmpty) {
      logger.info("PendingStatisticsDao, getByUser: result.isEmpty");
      return PendingStatistics.defaultValues(statId: 0, userId: user.localId);
    }
    return PendingStatistics.fromMap(result.first);
  }

  Future<void> update(PendingStatistics stats) async {
    final db = await _appDatabase.db;
    await db.update(
      'PendingStatistics',
      stats.toMap(),
      where: 'stat_id = ?',
      whereArgs: [stats.statId],
    );
  }

  Future<void> updatedByStatisticsLocal(StatisticsLocal updated) async {
    final user = await _userDao.getUser();
    if (user == null) return;

logger.info("updatedByStatisticsLocal: user.isGuest - ${user.isGuest}");
    if (!user.isGuest) {
      PendingStatistics currentPendingStats =
          (await getByUser(user.localId)) ??
          PendingStatistics.defaultValues(statId: 0, userId: user.localId);

      update(
        currentPendingStats.copyWith(
          totalGames: updated.totalGames,
          winsPlayer1: updated.winsPlayer1,
          winsPlayer2: updated.winsPlayer2,
          draws: updated.draws,
        ),
      );

final sT = await getByUser(user.localId);

      logger.info("updatedByStatisticsLocal: Updated! - ${sT!.totalGames}");
    }
  }

  Future<void> syncUpdatedByStatisticsLocal(StatisticsLocal updated) async {
    final user = await _userDao.getUser();
    if (user == null) return;
    
    logger.info("syncUpdatedByStatisticsLocal: user.isGuest - ${user.isGuest}");
    if (!user.isGuest) {
      PendingStatistics currentPendingStats =
          (await getByUser(user.localId)) ??
          PendingStatistics.defaultValues(statId: 0, userId: user.localId);

      update(
        currentPendingStats.copyWith(
          totalGames: updated.totalGames,
          winsPlayer1: updated.winsPlayer1,
          winsPlayer2: updated.winsPlayer2,
          draws: updated.draws,
          syncId: Uuid().v4(),
        ),
      );
    }
  }
}
