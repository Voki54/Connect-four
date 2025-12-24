class UserLocal {
  final int? localId;
  final String? authId;
  final bool isGuest;
  final bool isCurrent;
  final String? token;
  final int totalGames;
  final int winsPlayer1;
  final int winsPlayer2;
  final int draws;
  // final DateTime? lastSyncStats;

  UserLocal({
    required this.localId,
    this.authId,
    required this.isGuest,
    required this.isCurrent,
    this.token,
    required this.totalGames,
    required this.winsPlayer1,
    required this.winsPlayer2,
    required this.draws,
    // this.lastSyncStats,
  });

  UserLocal copyWith({
    String? authId,
    bool? isGuest,
    bool? isCurrent,
    String? token,
    int? totalGames,
    int? winsPlayer1,
    int? winsPlayer2,
    int? draws,
    // DateTime? lastSyncStats,
  }) {
    return UserLocal(
      localId: localId,
      authId: authId ?? this.authId,
      isGuest: isGuest ?? this.isGuest,
      isCurrent: isCurrent ?? this.isCurrent,
      token: token ?? this.token,
      totalGames: totalGames ?? this.totalGames,
      winsPlayer1: winsPlayer1 ?? this.winsPlayer1,
      winsPlayer2: winsPlayer2 ?? this.winsPlayer2,
      draws: draws ?? this.draws,
      // lastSyncStats: lastSyncStats ?? this.lastSyncStats,
    );
  }

  factory UserLocal.fromMap(Map<String, dynamic> map) {
    return UserLocal(
      localId: map['local_id'],
      authId: map['auth_id'] as String?,
      isGuest: map['is_guest'] == 1,
      isCurrent: map['is_current'] == 1,
      token: map['token'] as String?,
      totalGames: (map['total_games'] as int?) ?? 0,
      winsPlayer1: (map['wins_player1'] as int?) ?? 0,
      winsPlayer2: (map['wins_player2'] as int?) ?? 0,
      draws: (map['draws'] as int?) ?? 0,
      // lastSyncStats: map['last_sync_stats'] != null
      //     ? DateTime.fromMillisecondsSinceEpoch(map['last_sync_stats'])
      //     : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'local_id': localId,
      'auth_id': authId,
      'is_guest': isGuest ? 1 : 0,
      'is_current': isCurrent ? 1 : 0,
      'token': token,
      'total_games': totalGames,
      'wins_player1': winsPlayer1,
      'wins_player2': winsPlayer2,
      'draws': draws,
      // 'last_sync_stats': lastSyncStats?.millisecondsSinceEpoch,
    };
  }
}
