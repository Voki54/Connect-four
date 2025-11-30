import '../core/local_database.dart';
import 'user_model.dart';

class UserDao {
  final AppDatabase _appDatabase;

  UserDao(this._appDatabase);

  Future<int> createUser(UserLocal user) async {
    final db = await _appDatabase.db;
    return await db.insert('UserLocal', user.toMap());
  }

// TODO: добавить флаг последнего пользователя, чтобы загружать его
  Future<UserLocal?> getUser() async {
    final db = await _appDatabase.db;
    final result = await db.query('UserLocal', limit: 1);

    if (result.isEmpty) return null;
    return UserLocal.fromMap(result.first);
  }

  Future<int> updateUser(UserLocal user) async {
    final db = await _appDatabase.db;

    return db.update(
      'UserLocal',
      user.toMap(),
      where: 'local_id = ?',
      whereArgs: [user.localId],
    );
  }

  Future<int> deleteUser() async {
    final db = await _appDatabase.db;
    return db.delete('UserLocal');
  }
}
