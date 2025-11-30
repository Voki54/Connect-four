import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeController {
  void onNewGamePressed(BuildContext context, int userId) {
    context.go('/start_game', extra: userId);
  }

  void onContinueGamePressed() {
    debugPrint('Продолжить игру');
    // TODO: проверить, есть ли сохранённая игра, и возобновить
  }

  void onSettingsPressed() {
    debugPrint('Открыть настройки');
    // TODO: перейти на экран настроек
  }

  void onStatisticsPressed() {
    debugPrint('Открыть статистику');
    // TODO: перейти на экран статистики
  }

  void onRulesPressed() {
    debugPrint('Показать правила');
    // TODO: перейти на экран правил игры
  }
}
