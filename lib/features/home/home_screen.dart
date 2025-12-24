import 'package:connect_four/features/core/game_constants.dart';
import 'package:connect_four/features/game/game_controller.dart';
import 'package:connect_four/features/home/board_container.dart';
import 'package:connect_four/features/home/menu_button.dart';

import '../core/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../core/ui/my_icon_data.dart';
import 'home_icon_button.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomecreenState();
}

class _HomecreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            HomeIconButton(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 40),
              icon: const Icon(MyIcons.documentation),
              iconSize: 75,
              onPressed: () => context.go('/documentation'),
            ),
            Column(
              children: [
                const SizedBox(height: 40),
                Expanded(
                  child: BoardContainer(
                    theme: lightTheme,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        MenuButton(
                          text: 'Новая игра',
                          onPressed: () => _startGame(context),
                          width: 375,
                          height: 56,
                        ),

                        // MenuButton(
                        //   text: 'Продолжить игру',
                        //   onPressed: () => print('Продолжить игру'),
                        //   width: 375,
                        //   height: 56,
                        // ),

                        // MainMenuButton(
                        //   text: 'Настройки',
                        //   onPressed: () => print('Настройки'),
                        // ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            HomeIconButton(
              padding: EdgeInsets.fromLTRB(0, 0, 20, 40),
              icon: const Icon(MyIcons.statistics),
              iconSize: 83,
              onPressed: () {
                context.go('/statistics');
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _startGame(BuildContext context) async {
    try {
      final controller = GetIt.I<GameController>();

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      await controller.startNewGame(
        // userId: userId,
        rows: GameConstants.defaultRows,
        columns: GameConstants.defaultColumns,
        colorPlayer1: 1,
        colorPlayer2: 2,
        timeLimit: null,
      );

      // Закрываем индикатор загрузки
      if (context.mounted) {
        context.go('/game');
      }
    } catch (e) {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Ошибка'),
            content: Text('Не удалось начать игру: $e'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Oк'),
              ),
            ],
          ),
        );
      }
    }
  }
}
