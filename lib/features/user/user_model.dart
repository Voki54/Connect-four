class UserLocal {
  final int localId;
  final String? authId;
  final bool isGuest;
  final String? token;

  UserLocal({
    required this.localId,
    this.authId,
    required this.isGuest,
    this.token,
  });

  UserLocal copyWith({
    String? authId,
    bool? isGuest,
    String? token,
  }) {
    return UserLocal(
      localId: localId,
      authId: authId ?? this.authId,
      isGuest: isGuest ?? this.isGuest,
      token: token ?? this.token,
    );
  }

  factory UserLocal.fromMap(Map<String, dynamic> map) {
    return UserLocal(
      localId: map['local_id'],
      authId: map['auth_id'] as String?,
      isGuest: map['is_guest'] == 1,
      token: map['token'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'local_id': localId,
      'auth_id': authId,
      'is_guest': isGuest ? 1 : 0,
      'token': token,
    };
  }
}
