class UpdateStatisticsRequest {
  final int totalGames;
  final int winsPlayer1;
  final int winsPlayer2;
  final int draws;
  // final String syncId;

  UpdateStatisticsRequest({
    required this.totalGames,
    required this.winsPlayer1,
    required this.winsPlayer2,
    required this.draws,
    // required this.syncId,
  });

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
