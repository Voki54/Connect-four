import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'features/home/presentation/screens/home_screen.dart';

void main() {
  runApp(const ConnectFourApp());
}

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    // GoRoute(
    //   path: '/game',
    //   builder: (context, state) => const GameScreen(),
    // ),
  ],
);

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
      routerConfig: _router,
    );
  }
}
