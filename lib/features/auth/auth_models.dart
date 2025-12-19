class LoginRequest {
  final String email;
  final String password;

  LoginRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
      };
}

class RegisterRequest {
  final String email;
  final String password;

  RegisterRequest({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
      };
}

class RefreshTokenRequest {
  final String refreshToken;

  RefreshTokenRequest({required this.refreshToken});

  Map<String, dynamic> toJson() => {
        'refreshToken': refreshToken,
      };
}

class JwtResponse {
  final String accessToken;
  final String refreshToken;

  JwtResponse({required this.accessToken, required this.refreshToken});

  factory JwtResponse.fromJson(Map<String, dynamic> json) => JwtResponse(
        accessToken: json['accessToken'],
        refreshToken: json['refreshToken'],
      );
}
