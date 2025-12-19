import 'package:connect_four/features/auth/sync_controller.dart';
import 'package:connect_four/features/statistics/api/update_statistics_request.dart';
import 'package:connect_four/features/statistics/statistics_controller.dart';
import 'package:connect_four/features/statistics/statistics_model.dart';
import 'package:connect_four/features/user/user_controller.dart';
import 'package:connect_four/features/statistics/api/statistics_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:uuid/uuid.dart';
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

      final syncController = GetIt.I<SyncController>();
      await syncController.authorizeUser(username);

      final userController = GetIt.I<UserController>();
      final user = userController.user;
      final statisticsController = GetIt.I<StatisticsController>();
      final pendingStats = await statisticsController.getPendingStats(
        user.localId,
      );

      if (pendingStats == null) {
        throw Exception("pendingStats == null during registration!");
      }

      final statsApi = GetIt.I<StatisticsService>();

      print("TOKEN ${await tokenStorage.getAccessToken()}");

      final updatedStats = await statsApi.updateStatistics(
        UpdateStatisticsRequest(
          totalGames: pendingStats.totalGames,
          winsPlayer1: pendingStats.winsPlayer1,
          winsPlayer2: pendingStats.winsPlayer2,
          draws: pendingStats.draws,
          syncId: pendingStats.syncId,
        ),
      );

      await statisticsController.syncUpdatePendingStats(updatedStats);

      final tS = await statisticsController.getPendingStats(user.localId);

      logger.info("PendingStats.totalGames ${tS!.totalGames}");

      logger.info("Registration is successful.");

      if (!mounted) return;
      context.go("/statistics");
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Регистрация')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
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

                const SizedBox(height: 20),

                if (_error != null)
                  Text(_error!, style: const TextStyle(color: Colors.red)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: _loading ? null : _register,
                      child: _loading
                          ? const CircularProgressIndicator()
                          : const Text('Зарегистрироваться'),
                    ),
                    ElevatedButton(
                      onPressed: () => context.go("/statistics"),
                      child: _loading
                          ? const CircularProgressIndicator()
                          : const Text('Назад'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
