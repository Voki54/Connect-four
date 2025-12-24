import 'package:connect_four/features/auth/auth_api.dart';
import 'package:connect_four/features/core/ui/snackbars.dart';
import 'package:connect_four/features/core/ui/theme.dart';
import 'package:connect_four/features/home/menu_button.dart';
import 'package:connect_four/features/statistics/api/statistics_service.dart';
import 'package:connect_four/features/statistics/api/update_statistics_request.dart';
import 'package:connect_four/features/statistics/statistics_model.dart';
import 'package:connect_four/features/user/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../user/user_controller.dart';

import 'statistics_detailed_widget.dart';
import 'statistics_controller.dart';
import '../core/logger.dart';
import 'package:go_router/go_router.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  StatisticsController? _statisticsController;
  UserController? _userController;
  late UserLocal _user;
  late StatisticsLocal _stats;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  Future<void> _initializeController() async {
    await GetIt.I.isReady<StatisticsController>();
    await GetIt.I.isReady<UserController>();
    _statisticsController = GetIt.I<StatisticsController>();
    _userController = GetIt.I<UserController>();
    final stats = await _statisticsController!.stats;
    final user = await _userController!.user;
    if (!mounted) return;
    setState(() {
      _stats = stats;
      _user = user;
    });
  }

  Future<void> _logout() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final statsApi = GetIt.I<StatisticsService>();

      await statsApi.updateStatistics(
        UpdateStatisticsRequest(
          totalGames: _stats.totalGames,
          winsPlayer1: _stats.winsPlayer1,
          winsPlayer2: _stats.winsPlayer2,
          draws: _stats.draws,
        ),
      );

      final authApi = GetIt.I<AuthApi>();
      await authApi.logout();

      await _userController!.logout();

      if (!mounted) return;

      await _initializeController();
      logger.info("Logout is successful.");
      ResultSnackBar.showSuccessSnackBar(message: 'Вы вышли из аккаунта');
    } catch (e) {
      setState(() => _error = e.toString());
      logger.info("Logout is unsuccessful. Error: $_error");
      ResultSnackBar.showFailSnackBar(
        message: 'При выходе возникла ошибка: $_error',
      );
    } finally {
      setState(() => _loading = false);
    }
    //обновить виджет статистики для показа гостевой стат

    // final prefs = await SharedPreferences.getInstance();
    // await prefs.clear();

    // if (!mounted) return;
    // Navigator.pushAndRemoveUntil(
    //   context,
    //   MaterialPageRoute(builder: (_) => const LoginScreen()),
    //   (_) => false,
    // );
  }

  @override
  Widget build(BuildContext context) {
    if (_statisticsController == null || _userController == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    logger.info(
      "StatScreen: isGuest - ${_user.isGuest}",
    ); //authId - ${userC.user.authId},

    // final stats = _statisticsController!.stats;
    logger.info(
      "stats screen - ${_stats.totalGames}, ${_stats.winsPlayer1}, ${_stats.winsPlayer2}, ${_stats.draws}",
    );
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (_loading)
                    const CircularProgressIndicator()
                  else ...[
                    Text(
                      'Статистика игр',
                      textAlign: TextAlign.center,
                      style: lightTheme.textTheme.headlineMedium,
                    ),

                    const SizedBox(height: 16),

                    StatsDetailedWidget(stats: _stats),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MenuButton(
                            text: 'Назад',
                            onPressed: () => context.go('/'),
                            width: 320,
                            height: 55,
                          ),

                          if (_user.isGuest)
                            MenuButton(
                              text: 'Войти в аккаунт',
                              onPressed: () => context.go('/login'),
                              width: 320,
                              height: 55,
                            )
                          else
                            MenuButton(
                              text: 'Выйти из аккаунта',
                              onPressed: _logout,
                              width: 320,
                              height: 55,
                            ),
                        ],
                      ),
                    ),
                  ],
                  if (_error != null)
                    Text(_error!, style: const TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
