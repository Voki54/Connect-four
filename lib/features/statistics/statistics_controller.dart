import 'package:connect_four/features/statistics/api/statistics_response.dart';

import 'statistics_dao.dart';
import 'statistics_model.dart';
import '../core/logger.dart';

class StatisticsController {
  final StatisticsDao _statisticsDao;
  // final PendingStatisticsDao _pendingStatisticsDao;

  StatisticsLocal? _stats;

  Future<StatisticsLocal> get stats async {
    await loadStatistics();
    return _stats!;
  }

  StatisticsController(this._statisticsDao); //, this._pendingStatisticsDao

  Future<void> loadStatistics() async {
    _stats = await _statisticsDao.getByUser();
    if (_stats == null) {
      throw Exception('StatisticsController: User statistics not found!');
    }
    // await _statisticsDao.createEmpty(_userId);
  }

  Future<void> addGameResult({
    required int? winner, // 1, 2 или null
  }) async {
    if (_stats == null) {
      await loadStatistics();
    }

    logger.info(
      "winner - ${winner}\nController stats - ${_stats!.totalGames}, ${_stats!.winsPlayer1}, ${_stats!.winsPlayer2}, ${_stats!.draws}",
    );

    var updated = await stats;

    if (winner == 1) {
      updated = updated.copyWith(
        totalGames: updated.totalGames + 1,
        winsPlayer1: updated.winsPlayer1 + 1,
      );
    } else if (winner == 2) {
      updated = updated.copyWith(
        totalGames: updated.totalGames + 1,
        winsPlayer2: updated.winsPlayer2 + 1,
      );
    } else {
      updated = updated.copyWith(
        totalGames: updated.totalGames + 1,
        draws: updated.draws + 1,
      );
    }

    //lastSync - последняя синхронизация с сервером
    // updated = updated.copyWith(lastSync: DateTime.now());

    _stats = updated.copyWith();
    // await updatePendingStats(updated);

    logger.info(
      "Controller stats2 - ${_stats!.totalGames}, ${_stats!.winsPlayer1}, ${_stats!.winsPlayer2}, ${_stats!.draws}",
    );

    await _statisticsDao.update(updated);
    // await _statisticsDao.update(stats);
  }

  Future<void> updateWithServerStats(StatisticsResponse serverStats) async {
    await loadStatistics();

    await _statisticsDao.update(
      StatisticsLocal(
        totalGames: _stats!.totalGames + serverStats.totalGames,
        winsPlayer1: _stats!.winsPlayer1 + serverStats.winsPlayer1,
        winsPlayer2: _stats!.winsPlayer2 + serverStats.winsPlayer2,
        draws: _stats!.draws + serverStats.draws,
      ),
    );
  }

  Future<void> rewriteStats(StatisticsLocal updated) async {
    await _statisticsDao.update(updated);
  }

  // Future<void> updatePendingStats(StatisticsLocal updated) async {
  //   await _pendingStatisticsDao.updatedByStatisticsLocal(updated);
  // }

  // Future<void> syncUpdatePendingStats(StatisticsResponse updated) async {
  //   await _pendingStatisticsDao.syncUpdatedByStatisticsLocal(
  //     StatisticsLocal(
  //       totalGames: updated.totalGames,
  //       winsPlayer1: updated.winsPlayer1,
  //       winsPlayer2: updated.winsPlayer2,
  //       draws: updated.draws,
  //     ),
  //   );
  // }

  // Future<PendingStatistics?> getPendingStats(userId) async {
  //   return await _pendingStatisticsDao.getByUser(userId);
  // }
}
