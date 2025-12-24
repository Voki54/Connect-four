import '../user/user_dao.dart';
import 'statistics_model.dart';
import '../core/logger.dart';

class StatisticsDao {
  final UserDao _userDao;

  StatisticsDao(this._userDao);

  Future<StatisticsLocal?> getByUser() async {
    final user = await _userDao.getUser();
    logger.info("StatisticsDao: user?");
    if (user == null) return null;
    logger.info("StatisticsDao: user - ${user.localId}");
    return StatisticsLocal(
      totalGames: user.totalGames,
      winsPlayer1: user.winsPlayer1,
      winsPlayer2: user.winsPlayer2,
      draws: user.draws,
    );
  }

  Future<void> update(StatisticsLocal stats) async {
    await _userDao.updateUserStatistcs(stats);
  }
}
