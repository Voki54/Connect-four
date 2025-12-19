// import '../../core/local_database.dart';
// import 'snapshot_statistics_model.dart';

// class SnapshotStatisticsDao {
//   final AppDatabase _appDatabase;

//   SnapshotStatisticsDao(this._appDatabase);

//   Future<SnapshotStatistics?> getByUser(int userId) async {
//     final db = await _appDatabase.db;
//     final result = await db.query(
//       'ServerStatisticsSnapshot',
//       where: 'user_id = ?',
//       whereArgs: [userId],
//       limit: 1,
//     );
//     if (result.isEmpty) return null;
//     return SnapshotStatistics.fromMap(result.first);
//   }

//   // Future<int> createEmpty(int userId) async {
//   //   final db = await _appDatabase.db;
//   //   return await db.insert('StatisticsLocal', {
//   //     'user_id': userId,
//   //     'total_Games': 0,
//   //     'wins_player1': 0,
//   //     'wins_player2': 0,
//   //     'draws': 0,
//   //     'last_sync': null,
//   //   });
//   // }

//   Future<void> update(SnapshotStatistics stats) async {
//     final db = await _appDatabase.db;
//     await db.update(
//       'ServerStatisticsSnapshot',
//       stats.toMap(),
//       where: 'stat_id = ?',
//       whereArgs: [stats.statId],
//     );
//   }
// }
