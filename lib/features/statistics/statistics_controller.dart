import 'package:connect_four/features/statistics/api/statistics_response.dart';
import 'package:connect_four/features/statistics/pending_statistics/pending_statistics_model.dart';

import 'statistics_dao.dart';
import 'statistics_model.dart';
import 'pending_statistics/pending_statistics_dao.dart';
import '../core/logger.dart';

class StatisticsController {
  final StatisticsDao _statisticsDao;
  final PendingStatisticsDao _pendingStatisticsDao;

  StatisticsLocal? _stats;
  StatisticsLocal get stats => _stats!;

  StatisticsController(this._statisticsDao, this._pendingStatisticsDao);

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

    var updated = stats;

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

    _stats = updated;
    await updatePendingStats(updated);

    logger.info(
      "Controller stats2 - ${_stats!.totalGames}, ${_stats!.winsPlayer1}, ${_stats!.winsPlayer2}, ${_stats!.draws}",
    );

    logger.info(
      "Controller stats3 - ${stats.totalGames}, ${stats.winsPlayer1}, ${stats.winsPlayer2}, ${stats.draws}",
    );

    await _statisticsDao.update(updated);
    // await _statisticsDao.update(stats);
  }

  Future<void> updatePendingStats(StatisticsLocal updated) async {
    await _pendingStatisticsDao.updatedByStatisticsLocal(updated);
  }

  Future<void> syncUpdatePendingStats(StatisticsResponse updated) async {
    await _pendingStatisticsDao.syncUpdatedByStatisticsLocal(StatisticsLocal(
        totalGames: updated.totalGames,
        winsPlayer1: updated.winsPlayer1,
        winsPlayer2: updated.winsPlayer2,
        draws: updated.draws
      ));
  }

  Future<PendingStatistics?> getPendingStats(userId) async {
    return await _pendingStatisticsDao.getByUser(userId);
  }
}

// import 'statistics_statisticsDao.dart';
// import 'statistics_model.dart';

// class StatisticsController {
//   final StatisticsDao _statisticsDao;
//   final int _userId;

//   StatisticsLocal? _stats;
//   StatisticsLocal get stats => _stats!;

//   StatisticsController(this._statisticsDao, this._userId);

//   Future<void> loadStatistics() async {
//     _stats = await _statisticsDao.getByUser(_userId);
//     await _statisticsDao.createEmpty(_userId);
//   }

//   Future<void> addGameResult({
//     required int? winner, // 1, 2 или null
//   }) async {
//     var updated = stats;

//     if (winner == 1) {
//       updated = updated.copyWith(winsPlayer1: updated.winsPlayer1 + 1);
//     } else if (winner == 2) {
//       updated = updated.copyWith(winsPlayer2: updated.winsPlayer2 + 1);
//     } else {
//       updated = updated.copyWith(draws: updated.draws + 1);
//     }

//     //lastSync - последняя синхронизация с сервером
//     // updated = updated.copyWith(lastSync: DateTime.now());

//     _stats = updated;

//     await _statisticsDao.update(updated);
//   }

//   Future<StatisticsLocal> getStatistics() async {
//     StatisticsLocal? userStatistics = await _statisticsDao.getByUser(_userId);
//     if (userStatistics == null) {
//       await _statisticsDao.createEmpty(_userId);
//       userStatistics = await _statisticsDao.getByUser(_userId);
//     }
//     return userStatistics;
//   }
// }
