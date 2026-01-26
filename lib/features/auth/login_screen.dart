import 'package:connect_four/features/core/ui/snackbars.dart';
import 'package:connect_four/features/home/menu_button.dart';
import 'package:connect_four/features/statistics/api/statistics_service.dart';
import 'package:connect_four/features/core/ui/theme.dart';
import 'package:connect_four/features/statistics/api/update_statistics_request.dart';
import 'package:connect_four/features/statistics/statistics_controller.dart';
import 'package:connect_four/features/statistics/statistics_model.dart';
import 'package:connect_four/features/user/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import '../core/logger.dart';

import 'auth_models.dart';
import 'auth_api.dart';
import 'token_storage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _login() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final authApi = GetIt.I<AuthApi>();

      final email = _emailController.text.trim();

      final response = await authApi.login(
        LoginRequest(email: email, password: _passwordController.text),
      );

      final tokenStorage = GetIt.I<TokenStorage>();
      await tokenStorage.saveTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );

      final userController = GetIt.I<UserController>();
      final statisticsController = GetIt.I<StatisticsController>();

      final statsApi = GetIt.I<StatisticsService>();
      final serverUserStats = await statsApi.getStatistics();

      final savedUser = await userController.getUserByUsername(email);

      if (savedUser == null) {
        await userController.setAuthUserId(email);
        await statisticsController.updateWithServerStats(serverUserStats);
      } else {
        final stats = await statisticsController.stats;

        final oldUser = await userController.user;
        await userController.changeUser(email);

        await statisticsController.rewriteStats(
          StatisticsLocal(
            totalGames: stats.totalGames + serverUserStats.totalGames,
            winsPlayer1: stats.winsPlayer1 + serverUserStats.winsPlayer1,
            winsPlayer2: stats.winsPlayer2 + serverUserStats.winsPlayer2,
            draws: stats.draws + serverUserStats.draws,
          ),
        );

        await userController.deleteUser(oldUser.localId!);
      }

      final updatedStats = await statisticsController.stats;

      await statsApi.updateStatistics(
        UpdateStatisticsRequest(
          totalGames: updatedStats.totalGames,
          winsPlayer1: updatedStats.winsPlayer1,
          winsPlayer2: updatedStats.winsPlayer2,
          draws: updatedStats.draws,
        ),
      );
      

      if (!mounted) return;
      logger.info("Login is successful.");
      ResultSnackBar.showSuccessSnackBar(message: 'Вы успешно вошли в аккаунт');

      context.go("/statistics");
    } catch (e) {
      setState(() => _error = e.toString());
      logger.info("Login is unsuccessful. Error: $_error");
      ResultSnackBar.showFailSnackBar(
        message: 'Вход не выполнен. Проверьте подключение к интернету или попробуйте позже.',
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 700,
              ), // задаем ширину блока
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
                        'Авторизация',
                        textAlign: TextAlign.center,
                        style: lightTheme.textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(labelText: 'Email'),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(labelText: 'Пароль'),
                      ),

                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MenuButton(
                            text: 'Назад',
                            onPressed: () => context.go('/statistics'),
                            width: 220,
                            height: 55,
                          ),
                          MenuButton(
                            text: 'Войти',
                            onPressed: _login,
                            width: 220,
                            height: 55,
                          ),
                          MenuButton(
                            text: 'Регистрация',
                            onPressed: () => context.go('/register'),
                            width: 220,
                            height: 55,
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
