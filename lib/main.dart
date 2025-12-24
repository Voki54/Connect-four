import 'package:connect_four/features/game/game_controller.dart';
import 'package:connect_four/features/statistics/statistics_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'features/core/app_router.dart';
import 'features/core/injector.dart';
import 'features/core/logger.dart';
import 'features/core/ui/theme.dart';
import 'features/user/user_controller.dart';

void main() async {
  // getIt.allowReassignment = true;
  setupLogger();
  logger.info("1");
  WidgetsFlutterBinding.ensureInitialized();
  logger.info("2");
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  logger.info("3");
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  logger.info("4");
  // Для того чтобы убрать системные интерфейсы старых утсройств
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      statusBarColor: Colors.transparent,
    ),
  );
  logger.info("5");
  await configureDependencies();
  logger.info("6");

  await getIt.allReady();
  logger.info("Зависимости установлены");

  final userController = getIt<UserController>();
  await userController.loadUser(); // создаёт guest

  final statisticsController = getIt<StatisticsController>();
  await statisticsController.loadStatistics(); // теперь безопасно

  final gameController = getIt<GameController>();
  await gameController.loadCurrentGame();

  runApp(const ConnectFourApp());
}

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();


class ConnectFourApp extends StatelessWidget {
  const ConnectFourApp({super.key});

  @override
  Widget build(BuildContext context) {
    logger.info("7");
    return MaterialApp.router(
      title: 'Четыре в ряд',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      routerConfig: appRouter,
      scaffoldMessengerKey: rootScaffoldMessengerKey,
    );
  }
}
