import 'package:connect_four/features/auth/auth_api.dart';
import 'package:connect_four/features/statistics/api/statistics_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../user/user_controller.dart';

import 'statistics_detailed_widget.dart';
import 'statistics_controller.dart';
import '../core/logger.dart';
import 'package:go_router/go_router.dart';

// import '../data/statistics_api.dart';
// import '../data/statistics_models.dart';
// import '../domain/statistics_repository.dart';
// import '../../auth/presentation/login_screen.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  StatisticsController? _statisticsController;
  UserController? _userController;
  // bool _loading = true;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  Future<void> _initializeController() async {
    await GetIt.I.isReady<StatisticsController>();
    setState(() {
      _statisticsController = GetIt.I<StatisticsController>();
      _userController = GetIt.I<UserController>();
    });
  }

  // late StatisticsRepository _repository;
  // UpdateStatisticsRequest? _stats;
  // String? _error;

  // @override
  // void initState() {
  //   super.initState();
  //   // _loadStats();
  // }

  // Future<void> _loadStats() async {
  //   try {
  //     final prefs = await SharedPreferences.getInstance();
  //     final token = prefs.getString('accessToken');

  //     if (token == null) {
  //       _logout();
  //       return;
  //     }

  //     _repository = StatisticsRepository(
  //       api: StatisticsApi(
  //         baseUrl: 'http://localhost:8080',
  //         token: token,
  //       ),
  //     );

  //     final stats = await _repository.getStatistics();
  //     setState(() {
  //       _stats = stats;
  //       _loading = false;
  //     });
  //   } catch (e) {
  //     setState(() {
  //       _error = e.toString();
  //       _loading = false;
  //     });
  //   }
  // }

  // Future<void> _save() async {
  //   if (_stats == null) return;

  //   await _repository.updateStatistics(_stats!);
  //   ScaffoldMessenger.of(context)
  //       .showSnackBar(const SnackBar(content: Text('Saved')));
  // }

  Future<void> _logout() async {

    final authApi = GetIt.I<AuthApi>();
    await authApi.logout();

    await _userController!.logout();
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

    final stats = _statisticsController!.stats;
    logger.info(
      "stats screen - ${stats.totalGames}, ${stats.winsPlayer1}, ${stats.winsPlayer2}, ${stats.draws}",
    );
    // if (_error != null) {
    //   return Scaffold(
    //     body: Center(child: Text(_error!)),
    //   );
    // }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              StatsDetailedWidget(stats: stats),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () => context.go('/'), //_startGame(context)
                    // style: ElevatedButton.styleFrom(
                    //   backgroundColor: Colors.indigo,
                    //   foregroundColor: Colors.white,
                    //   padding: const EdgeInsets.symmetric(
                    //     horizontal: 40,
                    //     vertical: 16,
                    //   ),
                    //   textStyle: const TextStyle(fontSize: 20),
                    // ),
                    child: const Text('Назад'),
                  ),
                  if (_userController!.user.isGuest)
                    ElevatedButton(
                      onPressed: () => context.go('/login'),
                      child: const Text('Войти в аккаунт'),
                    )
                  else
                    ElevatedButton(
                      onPressed: _logout,
                      child: const Text('Выйти из аккаунта'),
                    ),
                ],
              ),
              // StatsDetailedWidget(stats: stats),
              // _statField(
              //   'Games played',
              //   _stats!.gamesPlayed,
              //   (v) => _stats = _stats!.copyWith(gamesPlayed: v),
              // ),
              // _statField(
              //   'Wins',
              //   _stats!.wins,
              //   (v) => _stats = _stats!.copyWith(wins: v),
              // ),
              // _statField(
              //   'Losses',
              //   _stats!.losses,
              //   (v) => _stats = _stats!.copyWith(losses: v),
              // ),
              // const SizedBox(height: 20),
              // ElevatedButton(
              //   onPressed: _save,
              //   child: const Text('Save'),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _statField(
  //   String label,
  //   int value,
  //   Function(int) onChanged,
  // ) {
  //   return TextField(
  //     keyboardType: TextInputType.number,
  //     decoration: InputDecoration(labelText: label),
  //     controller: TextEditingController(text: value.toString()),
  //     // onChanged: (v) => onChanged(int.tryParse(v) ?? value),
  //   );
  // }
}
