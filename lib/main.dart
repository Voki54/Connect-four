import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'features/core/app_router.dart';
import 'features/core/injector.dart';
import 'features/core/logger.dart';

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

  // print('Registered dependencies:');
  // getIt.forEach((key, value) {
  //   print(' - $key: ${value.instance}');
  // });

  await getIt.allReady();
  logger.info("Зависимости установлены");

  runApp(const ConnectFourApp());
}

class ConnectFourApp extends StatelessWidget {
  const ConnectFourApp({super.key});

  @override
  Widget build(BuildContext context) {
    logger.info("7");
    return MaterialApp.router(
      title: 'Четыре в ряд',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white70),
        useMaterial3: true,
      ),
      routerConfig: appRouter,
    );
  }
}
