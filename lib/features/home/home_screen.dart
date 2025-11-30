import 'package:connect_four/features/user/user_model.dart';
import 'package:flutter/material.dart';
import 'home_controller.dart';
import 'main_menu_button.dart';
import 'package:get_it/get_it.dart';
import '../user/user_controller.dart';
import '../core/logger.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomecreenState();
}

class _HomecreenState extends State<HomeScreen> {
  late UserLocal _user;

  @override
  void initState() {
    super.initState();
    _loadUserController();
  }

  Future<UserLocal> _loadUserController() async {
    await GetIt.I.isReady<UserController>();
    // userId = GetIt.I<UserController>().user.localId!;
    return GetIt.I<UserController>().user;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserLocal>(
      // 2. Говорим FutureBuilder: дождись загрузки контроллера
      future: _loadUserController(),

      // 3. Получаем snapshot — в нём статус загрузки
      builder: (context, snapshot) {
        // Пока future выполняется — показываем loader
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Когда контроллер готов — достаём его
        _user = snapshot.data!;
        final homeController = HomeController();
        logger.info("userId homeScreen - ${_user.localId}");

        return Scaffold(
          appBar: AppBar(title: const Text('Четыре в ряд'), centerTitle: true),
          body: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MainMenuButton(
                  text: 'Новая игра',
                  onPressed: () =>
                      homeController.onNewGamePressed(context, _user.localId),
                ),
                const SizedBox(height: 16),
                MainMenuButton(
                  text: 'Продолжить игру',
                  onPressed: homeController.onContinueGamePressed,
                ),
                const SizedBox(height: 16),
                MainMenuButton(
                  text: 'Настройки',
                  onPressed: homeController.onSettingsPressed,
                ),
                // const SizedBox(height: 16),
                // MainMenuButton(
                //   text: 'Статистика',
                //   onPressed: homeController.onStatisticsPressed,
                // ),
                // const SizedBox(height: 16),
                // MainMenuButton(
                //   text: 'Правила игры',
                //   onPressed: homeController.onRulesPressed,
                // ),
              ],
            ),
          ),
        );
      },
    );
  }
}
