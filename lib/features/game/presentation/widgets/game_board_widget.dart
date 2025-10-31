import 'package:flutter/material.dart';
import '../../logic/game_controller.dart';
import 'cell_widget.dart';

class GameBoardWidget extends StatelessWidget {
  final GameController controller;
  final Function(int column) onColumnTap;

  const GameBoardWidget({
    super.key,
    required this.controller,
    required this.onColumnTap,
  });

  @override
  Widget build(BuildContext context) {
    final board = controller.board;

    return AspectRatio(
      aspectRatio: board.columns / board.rows,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int row = 0; row < board.rows; row++)
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int col = 0; col < board.columns; col++)
                    Expanded(
                      child: CellWidget(
                        state: board.grid[row][col],
                        onTap: () => onColumnTap(col),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
