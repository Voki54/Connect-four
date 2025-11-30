import 'package:get_it/get_it.dart';

import 'logger.dart';

import 'local_database.dart';

import '../user/user_dao.dart';
import '../user/user_repository.dart';
import '../user/user_controller.dart';

import '../statistics/statistics_dao.dart';
import '../statistics/statistics_controller.dart';

// import '../../settings/data/settings_dao.dart';
// import '../../settings/logic/settings_controller.dart';

import '../game/current_game_dao.dart';
import '../game/current_game_repository.dart';
// import '../../current_game/logic/current_game_controller.dart';

import '../game/game_controller.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // DATABASE
  getIt.registerSingletonAsync<AppDatabase>(() async {
    final db = AppDatabase.instance;
    await db.db; // открытие базы
    return db;
  });
  logger.info("Зависимость бд +");

  // DAOs
  getIt.registerSingletonAsync<UserDao>(() async {
    await getIt.isReady<AppDatabase>();
    return UserDao(getIt<AppDatabase>());
  });
  logger.info("Зависимость UserDao +");

  getIt.registerSingletonAsync<StatisticsDao>(() async {
    await getIt.isReady<AppDatabase>();
    return StatisticsDao(getIt<AppDatabase>());
  });
  logger.info("Зависимость StatisticsDao +");

  // getIt.registerLazySingleton<SettingsDao>(() => SettingsDao());
  getIt.registerSingletonAsync<CurrentGameDao>(() async {
    await getIt.isReady<AppDatabase>();
    return CurrentGameDao(getIt<AppDatabase>());
  });
  logger.info("Зависимость CurrentGameDao +");

  // REPOSITORIES
  getIt.registerSingletonAsync<UserRepository>(() async {
    await getIt.isReady<UserDao>();
    return UserRepository(getIt<UserDao>());
  });
  logger.info("Зависимость UserRepository +");

  getIt.registerSingletonAsync<CurrentGameRepository>(() async {
    await getIt.isReady<CurrentGameDao>();
    return CurrentGameRepository(getIt<CurrentGameDao>());
  });
  logger.info("Зависимость CurrentGameRepository +");

  // CONTROLLERS
  getIt.registerSingletonAsync<UserController>(() async {
    await getIt.isReady<UserRepository>();
    final controller = UserController(getIt<UserRepository>());
    await controller.loadUser();
    return controller;
  });
  logger.info("Зависимость UserController +");

  getIt.registerSingletonAsync<StatisticsController>(() async {
    await getIt.isReady<UserController>();
    await getIt.isReady<StatisticsDao>();

    final userId = getIt<UserController>().user.localId;

    final controller = StatisticsController(getIt<StatisticsDao>(), userId);
    await controller.loadStatistics();
    return controller;
  });
  logger.info("Зависимость StatisticsController +");

  // SettingsController
  // getIt.registerSingletonAsync<SettingsController>(() async {
  //   await getIt.isReady<UserController>();
  //   final userId = getIt<UserController>().currentUser.localId;
  //   final controller = SettingsController(getIt<SettingsDao>(), userId);
  //   await controller.load();
  //   return controller;
  // });

  getIt.registerSingletonAsync<GameController>(() async {
    await getIt.isReady<UserController>();
    await getIt.isReady<StatisticsController>();
    await getIt.isReady<CurrentGameRepository>();

    final userId = getIt<UserController>().user.localId;

    final controller = GameController(
      getIt<StatisticsController>(),
      getIt<CurrentGameRepository>(),
      userId,
    );

    await controller.loadCurrentGame();
    return controller;
  });
  logger.info("Зависимость GameController +");
}
