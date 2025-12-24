import 'package:connect_four/features/docs/documentation_screen.dart';
import 'package:go_router/go_router.dart';
import '../game/presentation/game_screen.dart';
import '../home/home_screen.dart';
import '../game/presentation/start_game_screen.dart';
import '../statistics/statistics_screen.dart';
import '../auth/login_screen.dart';
import '../auth/register_screen.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(path: '/game', builder: (context, state) => const GameScreen()),
    GoRoute(path: '/documentation', builder: (context, state) => const DocumentationScreen()),
    GoRoute(path: '/statistics', builder: (context, state) => const StatisticsScreen()),
    GoRoute(path: '/start_game', builder: (context, state) => const StartGameScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/register', builder: (context, state) => const RegisterScreen()),
  ],
);
