class StatisticsResponse {
  final int totalGames;
  final int winsPlayer1;
  final int winsPlayer2;
  final int draws;
  // final String syncId; // если syncId есть на сервере

  StatisticsResponse({
    required this.totalGames,
    required this.winsPlayer1,
    required this.winsPlayer2,
    required this.draws,
    // required this.syncId,
  });

  factory StatisticsResponse.fromMap(Map<String, dynamic> map) {
    return StatisticsResponse(
      totalGames: map['totalGames'] as int? ?? 0,
      winsPlayer1: map['winsPlayer1'] as int? ?? 0,
      winsPlayer2: map['winsPlayer2'] as int? ?? 0,
      draws: map['draws'] as int? ?? 0,
      // syncId: map['syncId'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalGames': totalGames,
      'winsPlayer1': winsPlayer1,
      'winsPlayer2': winsPlayer2,
      'draws': draws,
      // 'syncId': syncId,
    };
  }
}
