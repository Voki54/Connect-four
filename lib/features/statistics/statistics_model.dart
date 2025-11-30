class StatisticsLocal {
  final int statId;
  final int userId;
  final int totalGames;
  final int winsPlayer1;
  final int winsPlayer2;
  final int draws;
  final DateTime? lastSync;

  StatisticsLocal({
    required this.statId,
    required this.userId,
    required this.totalGames,
    required this.winsPlayer1,
    required this.winsPlayer2,
    required this.draws,
    this.lastSync,
  });

  StatisticsLocal copyWith({
    int? totalGames,
    int? winsPlayer1,
    int? winsPlayer2,
    int? draws,
    DateTime? lastSync,
  }) {
    return StatisticsLocal(
      statId: statId,
      userId: userId,
      totalGames: totalGames ?? this.totalGames,
      winsPlayer1: winsPlayer1 ?? this.winsPlayer1,
      winsPlayer2: winsPlayer2 ?? this.winsPlayer2,
      draws: draws ?? this.draws,
      lastSync: lastSync ?? this.lastSync,
    );
  }

  Map<String, dynamic> toMap() => {
    'stat_id': statId,
    'user_id': userId,
    'total_Games': totalGames,
    'wins_player1': winsPlayer1,
    'wins_player2': winsPlayer2,
    'draws': draws,
    'last_sync': lastSync?.millisecondsSinceEpoch,
  };

  factory StatisticsLocal.fromMap(Map<String, dynamic> map) {
    return StatisticsLocal(
      statId: map['stat_id'],
      userId: map['user_id'],
      totalGames: (map['total_Games'] as int?) ?? 0,
      winsPlayer1: (map['wins_player1'] as int?) ?? 0,
      winsPlayer2: (map['wins_player2'] as int?) ?? 0,
      draws: (map['draws'] as int?) ?? 0,
      lastSync: map['last_sync'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['last_sync'])
          : null,
    );

      // Map<String, dynamic> toJson() => {
  //       'totalGames': totalGames,
  //       'player1Wins': player1Wins,
  //       'player2Wins': player2Wins,
  //       'draws': draws,
  //     };

  // factory GameStatistics.fromJson(Map<String, dynamic> json) {
  //   return GameStatistics(
  //     totalGames: json['totalGames'] ?? 0,
  //     player1Wins: json['player1Wins'] ?? 0,
  //     player2Wins: json['player2Wins'] ?? 0,
  //     draws: json['draws'] ?? 0,
  //   );
  // }
  }
}
