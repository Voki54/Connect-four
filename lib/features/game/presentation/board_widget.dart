import 'package:connect_four/features/game/win_cell.dart';
import 'package:flutter/material.dart';
import '../board_model.dart';
import 'cell_widget.dart';

class BoardWidget extends StatelessWidget {
  final List<WinCell> winningCells;
  final Board currentBoard;
  final Function(int column) onColumnTap;

  const BoardWidget({
    super.key,
    required this.currentBoard,
    required this.onColumnTap,
    required this.winningCells,
  });

bool _isWinningCell(int row, int col) {
  return winningCells.any(
    (cell) => cell.row == row && cell.col == col,
  );
}


  @override
  Widget build(BuildContext context) {
    return Center(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int row = 0; row < currentBoard.rows; row++)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (int col = 0; col < currentBoard.columns; col++)
                    CellWidget(
                      key: ValueKey('cell-$row-$col'),
                      state: currentBoard.grid[row][col],
                      onTap: () => onColumnTap(col),
                      isWinning: _isWinningCell(row, col),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}