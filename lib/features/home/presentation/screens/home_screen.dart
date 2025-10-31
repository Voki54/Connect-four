import 'package:flutter/material.dart';
import '../../logic/home_controller.dart';
import '../widgets/main_menu_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = HomeController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Четыре в ряд'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MainMenuButton(
              text: 'Новая игра',
              onPressed: () => controller.onNewGamePressed(context),
            ),
            const SizedBox(height: 16),
            MainMenuButton(
              text: 'Продолжить игру',
              onPressed: controller.onContinueGamePressed,
            ),
            const SizedBox(height: 16),
            MainMenuButton(
              text: 'Настройки',
              onPressed: controller.onSettingsPressed,
            ),
            // const SizedBox(height: 16),
            // MainMenuButton(
            //   text: 'Статистика',
            //   onPressed: controller.onStatisticsPressed,
            // ),
            // const SizedBox(height: 16),
            // MainMenuButton(
            //   text: 'Правила игры',
            //   onPressed: controller.onRulesPressed,
            // ),
          ],
        ),
      ),
    );
  }
}
