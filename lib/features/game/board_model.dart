import 'dart:convert';
import 'cell_states.dart';
import '../core/game_constants.dart';

class Board {
  final int rows;
  final int columns;
  late List<List<CellState>> grid;

  Board({
    this.rows = GameConstants.defaultRows,
    this.columns = GameConstants.defaultColumns,
  }) {
    grid = List.generate(
      rows,
      (_) => List.generate(columns, (_) => CellState.empty),
    );
  }

  

  /// Adding a chip to the column. Returns the row index or -1 if the column is full.
  int dropToken(int column, CellState player) {
    for (int row = rows - 1; row >= 0; row--) {
      if (grid[row][column] == CellState.empty) {
        grid[row][column] = player;
        return row;
      }
    }
    return -1;
  }

  /// Сериализация доски в строку (например для хранения в CurrentGame)
  String serialize() {
    final map = grid.map((r) => r.map((c) => c.index).toList()).toList();
    return jsonEncode(map);
  }

  /// Десериализация доски из строки
  static Board deserialize(String data) {
    final list = (jsonDecode(data) as List)
        .map((r) => (r as List).map((c) => CellState.values[c]).toList())
        .toList();
    final board = Board(rows: list.length, columns: list[0].length);
    board.grid = list;
    return board;
  }

  /// Checking if the playing field is fully filled.
  bool get isFull =>
      grid.every((row) => row.every((cell) => cell != CellState.empty));
}
