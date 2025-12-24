import 'package:connect_four/features/core/ui/theme.dart';
import 'package:flutter/material.dart';
import '../cell_states.dart';

class CellWidget extends StatefulWidget {
  final CellState state;
  final VoidCallback onTap;
  final bool isWinning;

  // const CellWidget({super.key, required this.state, required this.onTap});

  const CellWidget({
    super.key,
    required this.state,
    required this.onTap,
    this.isWinning = false,
  });

  @override
  State<CellWidget> createState() => _CellWidgetState();
}

class _CellWidgetState extends State<CellWidget> {
  late bool _hasChip;
  late Color _chipColor;

  @override
  void initState() {
    super.initState();
    _updateState(widget.state);
  }

  @override
  void didUpdateWidget(CellWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state != widget.state) {
      setState(() {
        _updateState(widget.state);
      });
    }
  }

  void _updateState(CellState state) {
    _hasChip = state != CellState.empty;
    _chipColor = _getColor(state);
  }

  Color _getColor(CellState state) {
    switch (state) {
      case CellState.player1:
        return Colors.red;
      case CellState.player2:
        return Colors.yellow;
      case CellState.empty:
        return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: 50,
        height: 50,
        margin: const EdgeInsets.fromLTRB(7, 3, 7, 3),
        decoration: BoxDecoration(
          border: Border.all(color: lightTheme.dividerColor, width: 3),
          shape: BoxShape.circle,
        ),
        child: ClipOval(
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInBack,
                opacity: _hasChip ? 0 : 1,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: lightTheme.dividerColor,
                    shape: BoxShape.circle,
                  ),
                  // ),
                ),
              ),

              Positioned(
                left: 2,
                top: 2,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: lightTheme.scaffoldBackgroundColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              AnimatedScale(
                scale: _hasChip ? 1 : 0,
                duration: const Duration(milliseconds: 1000),
                curve: Curves.easeOutBack,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: _chipColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              AnimatedOpacity(
                duration: const Duration(milliseconds: 800),
                opacity: _hasChip ? 1 : 0,
                child: AnimatedScale(
                  scale: _hasChip ? 1 : 0,
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeOutBack,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(115, 77, 84, 81),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),

              AnimatedScale(
                scale: _hasChip ? 1 : 0,
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOutBack,
                child: Transform.translate(
                  offset: _hasChip ? const Offset(4, 4) : Offset.zero,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: _chipColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
