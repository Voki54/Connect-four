import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../game_controller.dart';
import '../cell_states.dart';
import 'board_widget.dart';
import '../../core/logger.dart';
import '../board_model.dart';

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
    final success = await _gameController.makeMove(column);
    
    if (success && mounted) {
      setState(() {
        _currentBoard = _gameController.currentBoard; // Обновляем состояние
      });
    }

    if (_gameController.gameOver) {
      _showEndDialog();
    }
  }

  void _showEndDialog() {
    _gameController.saveStatistics();

    final message = _gameController.winner == null
        ? 'Ничья!'
        : _gameController.winner == CellState.player1
        ? 'Победил игрок 1 (🔴)'
        : 'Победил игрок 2 (🟡)';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Игра окончена'),
        content: Text(message),
        actions: [
          // TextButton(
          //   onPressed: () {
          //     Navigator.pop(context);
          //     setState(() {
          //       _gameController.reset();
          //     });
          //   },
          //   child: const Text('Играть снова'),
          // ),
          TextButton(
            onPressed: () => _gameController.onExitGamePressed(context),
            child: const Text('Выход'),
          ),
        ],
      ),
    );
  }

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
          backgroundColor: Colors.indigo.shade900,
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    _gameController.gameOver
                        ? 'Игра окончена'
                        : 'Ход: ${_gameController.currentPlayer == CellState.player1 ? "🔴" : "🟡"}',
                    style: const TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: BoardWidget(
                      currentBoard: _currentBoard,
                      onColumnTap: _handleColumnTap,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
