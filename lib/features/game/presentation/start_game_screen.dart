import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import '../game_controller.dart';
import '../../core/game_constants.dart';

class StartGameScreen extends StatelessWidget {
  // final int userId;

  const StartGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade50,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Заголовок
            const Text(
              'Connect Four',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Кнопка начала игры
            ElevatedButton(
              onPressed: () => _startGame(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                textStyle: const TextStyle(fontSize: 20),
              ),
              child: const Text('Начать игру'),
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future<void> _startGame(BuildContext context) async {
    try {
      // Получаем контроллер
      final controller = GetIt.I<GameController>();
      
      // Показываем индикатор загрузки
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Захардкоженные параметры игры
      await controller.startNewGame(
        // userId: userId,
        rows: GameConstants.defaultRows,           // 6
        columns: GameConstants.defaultColumns,     // 7  
        colorPlayer1: 1,                       // 🔴
        colorPlayer2: 2,                    // 🟡
        timeLimit: null,                           // Без ограничения времени
      );

      // Закрываем индикатор загрузки
      if (context.mounted) {
        Navigator.of(context).pop();
        context.go('/game');
      }

    } catch (e) {
      // Закрываем индикатор загрузки в случае ошибки
      if (context.mounted) {
        Navigator.of(context).pop();
        
        // Показываем ошибку
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Ошибка'),
            content: Text('Не удалось начать игру: $e'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }
}