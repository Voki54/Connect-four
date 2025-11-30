import 'package:go_router/go_router.dart';
import '../game/presentation/game_screen.dart';
import '../home/home_screen.dart';
import '../game/presentation/start_game_screen.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(path: '/game', builder: (context, state) => const GameScreen()),
    GoRoute(
      path: '/start_game',
      builder: (context, state) {
        final userId = state.extra as int;
        return StartGameScreen(userId: userId);
      },
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
