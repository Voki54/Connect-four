// import 'package:uuid/uuid.dart';

// class PendingStatistics {
//   final int statId;
//   final int userId;
//   final int totalGames;
//   final int winsPlayer1;
//   final int winsPlayer2;
//   final int draws;
//   final String syncId;
//   // final DateTime? lastSync;

//   factory PendingStatistics.defaultValues({
//     required int statId,
//     required int userId,
//   }) {
//     return PendingStatistics(
//       statId: statId,
//       userId: userId,
//       totalGames: 0,
//       winsPlayer1: 0,
//       winsPlayer2: 0,
//       draws: 0,
//       syncId: Uuid().v4(),
//     );
//   }

//   PendingStatistics({
//     required this.statId,
//     required this.userId,
//     required this.totalGames,
//     required this.winsPlayer1,
//     required this.winsPlayer2,
//     required this.draws,
//     required this.syncId,
//     // this.lastSync,
//   });

//   PendingStatistics copyWith({
//     int? totalGames,
//     int? winsPlayer1,
//     int? winsPlayer2,
//     int? draws,
//     String? syncId,
//     // DateTime? lastSync,
//   }) {
//     return PendingStatistics(
//       statId: statId,
//       userId: userId,
//       totalGames: totalGames ?? this.totalGames,
//       winsPlayer1: winsPlayer1 ?? this.winsPlayer1,
//       winsPlayer2: winsPlayer2 ?? this.winsPlayer2,
//       draws: draws ?? this.draws,
//       syncId: syncId ?? this.syncId,
//       // lastSync: lastSync ?? this.lastSync,
//     );
//   }

//   Map<String, dynamic> toMap() => {
//     'stat_id': statId,
//     'user_id': userId,
//     'total_games': totalGames,
//     'wins_player1': winsPlayer1,
//     'wins_player2': winsPlayer2,
//     'draws': draws,
//     'sync_id': syncId,
//     // 'last_sync': lastSync?.millisecondsSinceEpoch,
//   };

//   factory PendingStatistics.fromMap(Map<String, dynamic> map) {
//     return PendingStatistics(
//       statId: map['stat_id'],
//       userId: map['user_id'],
//       totalGames: (map['total_games'] as int?) ?? 0,
//       winsPlayer1: (map['wins_player1'] as int?) ?? 0,
//       winsPlayer2: (map['wins_player2'] as int?) ?? 0,
//       draws: (map['draws'] as int?) ?? 0,
//       syncId: (map['sync_id'] as String?) ?? Uuid().v4(),
//       // lastSync: map['last_sync'] != null
//       //     ? DateTime.fromMillisecondsSinceEpoch(map['last_sync'])
//       //     : null,
//     );

//     // lastSync = DateTime.now().toUtc();
//   }
// }
