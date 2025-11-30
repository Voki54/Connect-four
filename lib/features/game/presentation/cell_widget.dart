import 'package:flutter/material.dart';
import '../cell_states.dart';
// import '../../core/logger.dart';

class CellWidget extends StatelessWidget {
  final CellState state;
  final VoidCallback onTap;

  const CellWidget({
    super.key,
    required this.state,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color color = Colors.white;
    switch (state) {
      case CellState.player1:
        color = Colors.red;
      case CellState.player2:
        color = Colors.yellow;
      case CellState.empty:
    }

// logger.info("CellWidget");

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.blue.shade700,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
