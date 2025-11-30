import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'logger.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._internal();
  Database? _db;

  AppDatabase._internal();

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _init();
    return _db!;
  }

  Future<Database> _init() async {
    final path = join(await getDatabasesPath(), 'connect_four.db');
    logger.info("DB init now");
    logger.info("DB path - $path");
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE UserLocal (
        local_id INTEGER PRIMARY KEY AUTOINCREMENT,
        auth_id TEXT,
        is_guest INTEGER,
        token TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE StatisticsLocal (
        stat_id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        total_games INTEGER NOT NULL,
        wins_player1 INTEGER NOT NULL,
        wins_player2 INTEGER NOT NULL,
        draws INTEGER NOT NULL,
        last_sync INTEGER,
        FOREIGN KEY(user_id) REFERENCES UserLocal(local_id)
      );
    ''');

    await db.execute('''
      CREATE TABLE Settings (
        setting_id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        language TEXT,
        volume INTEGER,
        theme TEXT,
        FOREIGN KEY(user_id) REFERENCES UserLocal(local_id)
      );
    ''');

    await db.execute('''
      CREATE TABLE CurrentGame (
        game_id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        rows INTEGER,
        columns INTEGER,
        color_player1 INTEGER,
        color_player2 INTEGER,
        time_limit INTEGER,
        board_state TEXT,
        current_player INTEGER,
        FOREIGN KEY(user_id) REFERENCES UserLocal(local_id)
      );
    ''');
    logger.info("DB created!");
  }
}
