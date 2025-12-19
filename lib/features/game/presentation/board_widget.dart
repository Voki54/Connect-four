import 'package:flutter/material.dart';
import '../board_model.dart';
import 'cell_widget.dart';
import '../../core/logger.dart';

class BoardWidget extends StatelessWidget {
  // final GameController controller;
  final Board currentBoard;
  final Function(int column) onColumnTap;

  const BoardWidget({
    super.key,
    required this.currentBoard,
    // required this.controller,
    required this.onColumnTap,
  });

  @override
  Widget build(BuildContext context) {
    // final board = Board.deserialize(controller.currentGame.boardState);
    return AspectRatio(
      aspectRatio: currentBoard.columns / currentBoard.rows,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int row = 0; row < currentBoard.rows; row++)
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int col = 0; col < currentBoard.columns; col++)
                    Expanded(
                      child: CellWidget(
                        state: currentBoard.grid[row][col],
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
