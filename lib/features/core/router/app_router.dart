import 'package:go_router/go_router.dart';
import '../../game/presentation/screens/game_screen.dart';
import '../../home/presentation/screens/home_screen.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/game',
      builder: (context, state) => const GameScreen(),
    ),
  ],
);

// final _router = GoRouter(
//   routes: [
//     GoRoute(
//       path: '/',
//       builder: (context, state) => const HomeScreen(),
//     ),
//     GoRoute(
//       path: '/game',
//       builder: (context, state) => const GameScreen(),
//     ),
//   ],
// );