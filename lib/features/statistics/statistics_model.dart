class StatisticsLocal {
  final int totalGames;
  final int winsPlayer1;
  final int winsPlayer2;
  final int draws;
  // final DateTime? lastSync;

  StatisticsLocal({
    this.totalGames = 0,
    this.winsPlayer1 = 0,
    this.winsPlayer2 = 0,
    this.draws = 0,
    // this.lastSync,
  });

  StatisticsLocal copyWith({
    int? totalGames,
    int? winsPlayer1,
    int? winsPlayer2,
    int? draws,
    // DateTime? lastSync,
  }) {
    return StatisticsLocal(
      totalGames: totalGames ?? this.totalGames,
      winsPlayer1: winsPlayer1 ?? this.winsPlayer1,
      winsPlayer2: winsPlayer2 ?? this.winsPlayer2,
      draws: draws ?? this.draws,
      // lastSync: lastSync ?? this.lastSync,
    );
  }

  Map<String, dynamic> toMap() => {
    'total_games': totalGames,
    'wins_player1': winsPlayer1,
    'wins_player2': winsPlayer2,
    'draws': draws,
    // 'last_sync': lastSync?.millisecondsSinceEpoch,
  };

  factory StatisticsLocal.fromMap(Map<String, dynamic> map) {
    return StatisticsLocal(
      totalGames: (map['total_games'] as int?) ?? 0,
      winsPlayer1: (map['wins_player1'] as int?) ?? 0,
      winsPlayer2: (map['wins_player2'] as int?) ?? 0,
      draws: (map['draws'] as int?) ?? 0,
      // lastSync: map['last_sync'] != null
      //     ? DateTime.fromMillisecondsSinceEpoch(map['last_sync'])
      //     : null,
    );
  }
}