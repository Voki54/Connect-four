import 'user_dao.dart';
import 'user_model.dart';

class UserRepository {
  final UserDao _dao;

  UserRepository(this._dao);

  Future<UserLocal?> loadUser() => _dao.getUser();

  Future<void> saveUser(UserLocal user) async {
    final existing = await _dao.getUser();
    if (existing == null) {
      await _dao.createUser(user);
    } else {
      await _dao.updateUser(user); // TODO: подправить (тут было copy)
    }
  }

  Future<void> clearUser() => _dao.deleteUser();
}
