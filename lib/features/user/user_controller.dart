import 'package:connect_four/features/statistics/pending_statistics/pending_statistics_dao.dart';
import 'package:connect_four/features/statistics/pending_statistics/pending_statistics_model.dart';
import 'package:connect_four/features/statistics/statistics_controller.dart';
import 'package:connect_four/features/statistics/statistics_model.dart';

import 'user_model.dart';
import 'user_dao.dart';
import '../auth/token_storage.dart';
import 'package:get_it/get_it.dart';
import '../core/logger.dart';

class UserController {
  // final UserRepository _repository;
  final UserDao _dao;
  // final StatisticsController _statisticsController;
  UserLocal? _currentUser;
  UserLocal get user => _currentUser!;

  UserController(this._dao); //, this._statisticsController

  Future<void> loadUser() async {
    _currentUser = await _dao.getUser();
    if (_currentUser == null) await createGuest();
  }

  Future<void> createGuest() async {
    final userStats = StatisticsLocal();
    logger.info("UserController: start guest create");
    final guest = UserLocal(
      localId: 0,
      authId: null,
      isGuest: true,
      isCurrent: true,
      token: null,
      totalGames: userStats.totalGames,
      winsPlayer1: userStats.winsPlayer1,
      winsPlayer2: userStats.winsPlayer2,
      draws: userStats.draws,
    );

    await _dao.createUser(guest);
    logger.info("UserController: guest created");
    _currentUser = guest;
  }

  Future<UserLocal?> getUserByUsername(String username) async {
    return await _dao.getUserByAuthId(username);
  }

  Future<void> setAuthUserId(String username) async {
    await _dao.updateUser(user.copyWith(isGuest: false, authId: username));
  }

  Future<void> logout() async {
    await _dao.updateUser(user.copyWith(isCurrent: false));
    final tokenStorage = GetIt.I<TokenStorage>();
    await tokenStorage.clear();
    createGuest();
    // if (localUser == null && user.isGuest) {
    //   await _dao.updateUser(user.copyWith(isGuest: false, authId: username));
    // }
    // await _repository.clearUser();
    // _currentUser = null;
  }
}
