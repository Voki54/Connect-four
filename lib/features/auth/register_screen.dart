import 'package:connect_four/features/core/ui/snackbars.dart';
import 'package:connect_four/features/core/ui/theme.dart';
import 'package:connect_four/features/home/menu_button.dart';
import 'package:connect_four/features/statistics/api/update_statistics_request.dart';
import 'package:connect_four/features/statistics/statistics_controller.dart';
import 'package:connect_four/features/user/user_controller.dart';
import 'package:connect_four/features/statistics/api/statistics_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../core/logger.dart';

import 'auth_models.dart';
import 'auth_api.dart';
import 'token_storage.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _register() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final authApi = GetIt.I<AuthApi>();

      final response = await authApi.register(
        RegisterRequest(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );

      final tokenStorage = GetIt.I<TokenStorage>();
      await tokenStorage.saveTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );

      Map<String, dynamic> decodedToken = JwtDecoder.decode(
        response.accessToken,
      );

      String username = decodedToken['sub'];

      final userController = GetIt.I<UserController>();
      await userController.setAuthUserId(username);

      final statisticsController = GetIt.I<StatisticsController>();
      final stats = await statisticsController.stats;

      final statsApi = GetIt.I<StatisticsService>();

      await statsApi.updateStatistics(
        UpdateStatisticsRequest(
          totalGames: stats.totalGames,
          winsPlayer1: stats.winsPlayer1,
          winsPlayer2: stats.winsPlayer2,
          draws: stats.draws,
        ),
      );

      if (!mounted) return;
      logger.info("Registration is successful");
      ResultSnackBar.showSuccessSnackBar(
        message: 'Вы успешно зарегистрировались',
      );

      context.go("/statistics");
    } catch (e) {
      setState(() => _error = e.toString());
      logger.info("Registration is unsuccessful. Error: $_error");
      ResultSnackBar.showFailSnackBar(
        message: 'Регистрация не выполнена. Ошибка: $_error',
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
                        'Регистрация',
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
                            onPressed: () => context.go('/login'),
                            width: 320,
                            height: 55,
                          ),
                          MenuButton(
                            text: 'Зарегистрироваться',
                            onPressed: _register,
                            width: 320,
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

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(title: const Text('Регистрация')),
  //     body: SafeArea(
  //       child: Padding(
  //         padding: const EdgeInsets.all(16),
  //         child: SingleChildScrollView(
  //           child: Column(
  //             children: [
  //               TextField(
  //                 controller: _emailController,
  //                 decoration: const InputDecoration(labelText: 'Email'),
  //               ),
  //               const SizedBox(height: 12),
  //               TextField(
  //                 controller: _passwordController,
  //                 obscureText: true,
  //                 decoration: const InputDecoration(labelText: 'Пароль'),
  //               ),

  //               const SizedBox(height: 20),

  //               if (_error != null)
  //                 Text(_error!, style: const TextStyle(color: Colors.red)),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                 children: [
  //                   ElevatedButton(
  //                     onPressed: _loading ? null : _register,
  //                     child: _loading
  //                         ? const CircularProgressIndicator()
  //                         : const Text('Зарегистрироваться'),
  //                   ),
  //                   ElevatedButton(
  //                     onPressed: () => context.go("/statistics"),
  //                     child: _loading
  //                         ? const CircularProgressIndicator()
  //                         : const Text('Назад'),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
