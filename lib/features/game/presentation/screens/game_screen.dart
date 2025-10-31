import 'package:flutter/material.dart';
import '../../logic/game_controller.dart';
import '../../models/cell.dart';
import '../widgets/game_board_widget.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameController controller;

  @override
  void initState() {
    super.initState();
    controller = GameController(rows: 6, columns: 7);
  }

  void _handleColumnTap(int column) {
    setState(() {
      controller.makeMove(column);
    });

    if (controller.gameOver) {
      _showEndDialog();
    }
  }

  void _showEndDialog() {
    final message = controller.winner == null
        ? 'Ничья!'
        : controller.winner == CellState.player1
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
          //       controller.reset();
          //     });
          //   },
          //   child: const Text('Играть снова'),
          // ),
          TextButton(
            onPressed: () => controller.onExitGamePressed(context),
            child: const Text('Выход'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade900,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                controller.gameOver
                    ? 'Игра окончена'
                    : 'Ход: ${controller.currentPlayer == CellState.player1 ? "🔴" : "🟡"}',
                style: const TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
            Expanded(
              child: Center(
                child: GameBoardWidget(
                  controller: controller,
                  onColumnTap: _handleColumnTap,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
