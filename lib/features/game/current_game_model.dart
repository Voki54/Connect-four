class CurrentGameLocal {
  final int? gameId;
  final int userId;
  final int rows;
  final int columns;
  final int colorPlayer1;
  final int colorPlayer2;
  final int? timeLimit; // секунд
  final String boardState; // сериализованное состояние доски JSON
  final int currentPlayer; // 1 или 2

  CurrentGameLocal({
    required this.gameId,
    required this.userId,
    required this.rows,
    required this.columns,
    required this.colorPlayer1,
    required this.colorPlayer2,
    this.timeLimit,
    required this.boardState,
    required this.currentPlayer,
  });

  Map<String, dynamic> toMap() => {
    'game_id': gameId,
    'user_id': userId,
    'rows': rows,
    'columns': columns,
    'color_player1': colorPlayer1,
    'color_player2': colorPlayer2,
    'time_limit': timeLimit,
    'board_state': boardState,
    'current_player': currentPlayer,
  };

  factory CurrentGameLocal.fromMap(Map<String, dynamic> map) {
    return CurrentGameLocal(
      gameId: map['game_id'],
      userId: map['user_id'],
      rows: map['rows'],
      columns: map['columns'],
      colorPlayer1: map['color_player1'],
      colorPlayer2: map['color_player2'],
      timeLimit: map['time_limit'],
      boardState: map['board_state'],
      currentPlayer: map['current_player'],
    );
  }

  CurrentGameLocal copyWith({
    int? rows,
    int? columns,
    int? colorPlayer1,
    int? colorPlayer2,
    int? timeLimit,
    String? boardState,
    int? currentPlayer,
  }) {
    return CurrentGameLocal(
      gameId: gameId,
      userId: userId,
      rows: rows ?? this.rows,
      columns: columns ?? this.columns,
      colorPlayer1: colorPlayer1 ?? this.colorPlayer1,
      colorPlayer2: colorPlayer2 ?? this.colorPlayer2,
      timeLimit: timeLimit ?? this.timeLimit,
      boardState: boardState ?? this.boardState,
      currentPlayer: currentPlayer ?? this.currentPlayer,
    );
  }
}
