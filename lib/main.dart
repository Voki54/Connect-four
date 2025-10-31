import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'features/core/router/app_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft, 
    DeviceOrientation.landscapeRight
  ]);

  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersiveSticky,
  );

  // Для того чтобы убрать системные интерфейсы старых утсройств
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      statusBarColor: Colors.transparent,
    ),
  );

  runApp(const ConnectFourApp());
}

class ConnectFourApp extends StatelessWidget {
  const ConnectFourApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Четыре в ряд',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white70, ),
        useMaterial3: true,
      ),
      routerConfig: appRouter,
    );
  }
}
