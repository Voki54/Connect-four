import 'user_model.dart';
import 'user_repository.dart';

class UserController {
  final UserRepository _repository;

  UserLocal? _currentUser;
  UserLocal get user => _currentUser!;

  UserController(this._repository);

  Future<void> loadUser() async {
    _currentUser = await _repository.loadUser();
    if (_currentUser == null) await createGuest();
  }

  Future<void> createGuest() async {
    final guest = UserLocal(
      localId: 0,
      authId: null,
      isGuest: true,
      token: null,
    );
    await _repository.saveUser(guest);
    _currentUser = guest;
  }

// TODO добавить логи авторизации гостя, чтобы статистика гостя не терялась
  Future<void> login(String authId, String token) async {
    final user = UserLocal(
      localId: 0,
      authId: authId,
      isGuest: false,
      token: token,
    );

    await _repository.saveUser(user);
    _currentUser = user;
  }

  Future<void> logout() async {
    await _repository.clearUser();
    _currentUser = null;
  }
}
