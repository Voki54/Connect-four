import 'statistics_dao.dart';
import 'statistics_model.dart';

class StatisticsController {
  final StatisticsDao _dao;
  final int _userId;

  StatisticsLocal? _stats;
  StatisticsLocal get stats => _stats!;

  StatisticsController(this._dao, this._userId);

  Future<void> loadStatistics() async {
    _stats = await _dao.getByUser(_userId);
    _dao.createEmpty(_userId);
  }

  Future<void> addGameResult({
    required int? winner, // 1, 2 или null
  }) async {
    var updated = stats;

    if (winner == 1) {
      updated = updated.copyWith(winsPlayer1: updated.winsPlayer1 + 1);
    } else if (winner == 2) {
      updated = updated.copyWith(winsPlayer2: updated.winsPlayer2 + 1);
    } else {
      updated = updated.copyWith(draws: updated.draws + 1);
    }

//lastSync - последняя синхронизация с сервером
    // updated = updated.copyWith(lastSync: DateTime.now());

    _stats = updated;

    await _dao.update(updated);
  }
}
