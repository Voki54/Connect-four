import 'package:connect_four/features/auth/sync_controller.dart';
import 'package:connect_four/features/core/game_constants.dart';
import 'package:get_it/get_it.dart';

import 'logger.dart';

import 'local_database.dart';

import '../user/user_dao.dart';
// import '../user/user_repository.dart';
import '../user/user_controller.dart';

import '../statistics/statistics_dao.dart';
import '../statistics/statistics_controller.dart';
import '../statistics/pending_statistics/pending_statistics_dao.dart';

// import '../../settings/data/settings_dao.dart';
// import '../../settings/logic/settings_controller.dart';

import '../game/current_game_dao.dart';
import '../game/current_game_repository.dart';
// import '../../current_game/logic/current_game_controller.dart';

import '../game/game_controller.dart';

import '../auth/token_storage.dart';
import '../auth/auth_api.dart';
import '../statistics/api/statistics_service.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // DATABASE
  getIt.registerSingletonAsync<AppDatabase>(() async {
    final db = AppDatabase.instance;
    await db.db; // открытие базы
    return db;
  });
  logger.info("Зависимость бд +");

  // Auth
  getIt.registerLazySingleton<TokenStorage>(() => TokenStorage());
  getIt.registerLazySingleton<AuthApi>(
    () => AuthApi(GameConstants.baseUrl, getIt<TokenStorage>()),
  );
  getIt.registerLazySingleton<StatisticsService>(
    () => StatisticsService(GameConstants.baseUrl, getIt<TokenStorage>()),
  );

  // DAOs
  getIt.registerSingletonAsync<UserDao>(() async {
    await getIt.isReady<AppDatabase>();
    return UserDao(getIt<AppDatabase>());
  });
  logger.info("Зависимость UserDao +");

  getIt.registerSingletonAsync<StatisticsDao>(() async {
    await getIt.isReady<UserDao>();
    return StatisticsDao(getIt<UserDao>());
  });
  logger.info("Зависимость StatisticsDao +");

  // getIt.registerSingletonAsync<PendingStatisticsDao>(() async {
  //   await getIt.isReady<AppDatabase>();
  //   await getIt.isReady<UserDao>();
  //   return PendingStatisticsDao(getIt<AppDatabase>(), getIt<UserDao>());
  // });
  // logger.info("Зависимость PendingStatisticsDao +");

  // getIt.registerLazySingleton<SettingsDao>(() => SettingsDao());
  getIt.registerSingletonAsync<CurrentGameDao>(() async {
    await getIt.isReady<AppDatabase>();
    await getIt.isReady<UserDao>();
    return CurrentGameDao(getIt<AppDatabase>(), getIt<UserDao>());
  });
  logger.info("Зависимость CurrentGameDao +");

  // REPOSITORIES
  // getIt.registerSingletonAsync<UserRepository>(() async {
  //   await getIt.isReady<UserDao>();
  //   return UserRepository(getIt<UserDao>());
  // });
  // logger.info("Зависимость UserRepository +");

  getIt.registerSingletonAsync<CurrentGameRepository>(() async {
    await getIt.isReady<CurrentGameDao>();
    return CurrentGameRepository(getIt<CurrentGameDao>());
  });
  logger.info("Зависимость CurrentGameRepository +");

  // CONTROLLERS
  getIt.registerSingletonAsync<UserController>(() async {
    await getIt.isReady<UserDao>();
    // await getIt.isReady<StatisticsController>();
    // final controller = UserController(getIt<UserDao>()); //, getIt<StatisticsController>()
    // await controller.loadUser();
    // return controller;
    return UserController(getIt<UserDao>());
  });
  logger.info("Зависимость UserController +");

  getIt.registerSingletonAsync<StatisticsController>(() async {
    // await getIt.isReady<UserController>();
    await getIt.isReady<StatisticsDao>();
    // await getIt.isReady<PendingStatisticsDao>();
    // final userId = getIt<UserController>().user.localId;

    // final controller = StatisticsController(
    //   getIt<StatisticsDao>(),
    //   getIt<PendingStatisticsDao>(),
    // );
    // await controller.loadStatistics();
    // return controller;
    return StatisticsController(
      getIt<StatisticsDao>(),
      // getIt<PendingStatisticsDao>(),
    );
  });
  logger.info("Зависимость StatisticsController +");

  // getIt.registerSingletonAsync<SyncController>(() async {
  //   await getIt.isReady<UserController>();
  //   await getIt.isReady<StatisticsController>();

  //   return SyncController(
  //     getIt<UserController>(),
  //     getIt<StatisticsController>(),
  //     getIt<AuthApi>(),
  //     getIt<TokenStorage>(),
  //   );
  // });
  // logger.info("Зависимость SyncController +");

  // SettingsController
  // getIt.registerSingletonAsync<SettingsController>(() async {
  //   await getIt.isReady<UserController>();
  //   final userId = getIt<UserController>().currentUser.localId;
  //   final controller = SettingsController(getIt<SettingsDao>(), userId);
  //   await controller.load();
  //   return controller;
  // });

  getIt.registerSingletonAsync<GameController>(() async {
    // await getIt.isReady<UserController>();
    await getIt.isReady<StatisticsController>();
    await getIt.isReady<CurrentGameRepository>();

    // final userId = getIt<UserController>().user.localId;

    // final controller = GameController(
    //   getIt<StatisticsController>(),
    //   getIt<CurrentGameRepository>(),
    //   // userId,
    // );

    // await controller.loadCurrentGame();
    // return controller;
    return GameController(
      getIt<StatisticsController>(),
      getIt<CurrentGameRepository>(),
    );
  });
  logger.info("Зависимость GameController +");
}
