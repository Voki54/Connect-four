import '../user/user_dao.dart';
import 'current_game_model.dart';
import '../core/logger.dart';
import '../core/local_database.dart';

class CurrentGameDao {
  final AppDatabase _appDatabase;
  final UserDao _userDao;

  CurrentGameDao(this._appDatabase, this._userDao);

  Future<CurrentGameLocal?> getByUser() async {
    final user = await _userDao.getUser();
    if (user == null) return null;
    final db = await _appDatabase.db;
    final result = await db.query(
      'CurrentGame',
      where: 'user_id = ?',
      whereArgs: [user.localId],
      limit: 1,
    );

    if (result.isEmpty) return null;
    return CurrentGameLocal.fromMap(result.first);
  }

Future<CurrentGameLocal> create({
  required int rows,
  required int columns,
  required int colorPlayer1,
  required int colorPlayer2,
  required String boardState,
  int? timeLimit,
}) async {
  final user = await _userDao.getUser();

  if (user == null) {
    throw Exception('No user was detected when creating the game!');
  }
  
  final db = await _appDatabase.db;

  final newGame = CurrentGameLocal(
    gameId: null,
    userId: user.localId!,
    rows: rows,
    columns: columns,
    colorPlayer1: colorPlayer1,
    colorPlayer2: colorPlayer2,
    timeLimit: timeLimit,
    boardState: boardState,
    currentPlayer: 1,
  );

  final insertedId = await db.insert('CurrentGame', newGame.toMap());
  
  // Возвращаем обновленную сущность с установленным ID
  return CurrentGameLocal(
    gameId: insertedId,
    userId: newGame.userId,
    rows: newGame.rows,
    columns: newGame.columns,
    colorPlayer1: newGame.colorPlayer1,
    colorPlayer2: newGame.colorPlayer2,
    timeLimit: newGame.timeLimit,
    boardState: newGame.boardState,
    currentPlayer: newGame.currentPlayer,
  );
}

  Future<void> update(CurrentGameLocal game) async {
    logger.info("come to update in CurrentGameDao");
    final database = await _appDatabase.db;
    logger.info("db open? - ${database.isOpen}");
    await database.update(
      'CurrentGame',
      game.toMap(),
      where: 'game_id = ?',
      whereArgs: [game.gameId],
    );
  }

  Future<void> delete(int gameId) async {
    final database = await _appDatabase.db;
    await database.delete(
      'CurrentGame',
      where: 'game_id = ?',
      whereArgs: [gameId],
    );
  }
}
