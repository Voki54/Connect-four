import 'package:connect_four/features/core/game_constants.dart';
import 'package:connect_four/features/core/ui/theme.dart';
import 'package:connect_four/features/home/board_container.dart';
import 'package:connect_four/features/home/menu_button.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../game_controller.dart';
import '../cell_states.dart';
import 'board_widget.dart';
import '../../core/logger.dart';
import '../board_model.dart';
import 'package:go_router/go_router.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameController _gameController;
  late Board _currentBoard;

  @override
  void initState() {
    super.initState();
    _loadGameController();
    // controller = GameController(rows: 6, columns: 7);
  }

  // Future<void> _loadController() async {
  //   await GetIt.I.isReady<GameController>();

  //   setState(() {
  //     controller = GetIt.I<GameController>();
  //   });
  // }

  Future<GameController> _loadGameController() async {
    await GetIt.I.isReady<GameController>();
    return GetIt.I<GameController>();
  }

  Future<void> _handleColumnTap(int column) async {
    if (_gameController.gameOver) return;

    final success = await _gameController.makeMove(column);

    if (success && mounted) {
      setState(() {
        _currentBoard = _gameController.currentBoard;
      });
    }

    if (_gameController.gameOver) {
      _showEndDialog();
    }
  }

  Future<void> _playAgain(BuildContext context) async {
    try {
      logger.info("start play again");
      await _gameController.startNewGameWithSwitchedStarter(
        rows: GameConstants.defaultRows,
        columns: GameConstants.defaultColumns,
        colorPlayer1: 1,
        colorPlayer2: 2,
      );

      if (!mounted) return;

      Navigator.of(context).pop(); // закрываем диалог

      setState(() {
        _currentBoard = _gameController.currentBoard;
      });
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

  void _showEndDialog() {
    _gameController.saveStatistics();

    final message = _gameController.winner == null
        ? 'Ничья!'
        : _gameController.winner == CellState.player1
        ? 'Победил игрок 1 🔴'
        : 'Победил игрок 2 🟡';

    showDialog(
      context: context,
      barrierDismissible: false, // 👈 не закрывается по фону
      builder: (context) {
        return PopScope(
          canPop: false, // 👈 не закрывается кнопкой Back
          child: Dialog(
            backgroundColor: lightTheme.scaffoldBackgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              // side: BorderSide(
              //   color: lightTheme.dividerColor,
              //   width: 2,
              // ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Заголовок
                  // Text(
                  //   'Игра окончена',
                  //   style: lightTheme.textTheme.headlineSmall,
                  //   textAlign: TextAlign.center,
                  // ),

                  // const SizedBox(height: 16),

                  // Сообщение
                  Text(
                    message,
                    style: lightTheme.textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 24),

                  // Expanded(
                  //   child:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MenuButton(
                        text: 'Выход',
                        onPressed: () => context.go('/'),
                        width: 320,
                        height: 55,
                      ),
                      const SizedBox(height: 20),
                      MenuButton(
                        text: 'Играть снова',
                        onPressed: () => _playAgain(context),
                        width: 320,
                        height: 55,
                      ),
                    ],
                  ),
                  // ),

                  // SizedBox(
                  //   width: double.infinity,
                  //   child: ElevatedButton(
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor: lightTheme.colorScheme.primary,
                  //       foregroundColor: Colors.white,
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(12),
                  //       ),
                  //       padding: const EdgeInsets.symmetric(vertical: 12),
                  //     ),
                  //     onPressed: () {
                  //       // Navigator.of(context).pop();
                  //       context.go('/');
                  //     },
                  //     child: const Text('Выход'),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // void _showEndDialog() async {
  //   await _gameController.saveStatistics();

  //   final message = _gameController.winner == null
  //       ? 'Ничья!'
  //       : _gameController.winner == CellState.player1
  //       ? 'Победил игрок 1 (🔴)'
  //       : 'Победил игрок 2 (🟡)';

  //   showDialog(
  //     barrierDismissible: false,
  //     context: context,
  //     builder: (_) => AlertDialog(
  //       title: const Text('Игра окончена'),
  //       content: Text(message),
  //       actions: [
  //         // TextButton(
  //         //   onPressed: () {
  //         //     Navigator.pop(context);
  //         //     setState(() {
  //         //       _gameController.reset();
  //         //     });
  //         //   },
  //         //   child: const Text('Играть снова'),
  //         // ),
  //         TextButton(
  //           onPressed: () => context.go('/'),
  //           child: const Text('Выход'),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<GameController>(
      // 2. Говорим FutureBuilder: дождись загрузки контроллера
      future: _loadGameController(),

      // 3. Получаем snapshot — в нём статус загрузки
      builder: (context, snapshot) {
        // Пока future выполняется — показываем loader
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Когда контроллер готов — достаём его
        _gameController = snapshot.data!;
        _currentBoard = _gameController.currentBoard;
        logger.info("GameController ${_gameController.currentGame.gameId}");

        return Scaffold(
          body: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text(
                      _gameController.gameOver
                          ? 'Игра окончена'
                          : 'Ход: ${_gameController.currentPlayer == CellState.player1 ? "🔴" : "🟡"}',
                      style: lightTheme.textTheme.headlineMedium,
                    ),
                  ),
                  Expanded(
                    child: BoardContainer(
                      theme: lightTheme,
                      child: BoardWidget(
                        winningCells: _gameController.winningCells,
                        currentBoard: _currentBoard,
                        onColumnTap: _handleColumnTap,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
