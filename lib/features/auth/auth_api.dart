import 'dart:convert';
import 'package:connect_four/features/auth/token_storage.dart';
import 'package:http/http.dart' as http;
import 'auth_models.dart';

class AuthApi {
  final String _baseUrl;
  final TokenStorage _tokenStorage;

  AuthApi(this._baseUrl, this._tokenStorage);

  Future<JwtResponse> login(LoginRequest request) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      return JwtResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Login failed: ${response.body}');
    }
  }

  Future<JwtResponse> register(RegisterRequest request) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 201) {
      return JwtResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Registration failed: ${response.body}');
    }
  }

  Future<JwtResponse> refreshToken(RefreshTokenRequest request) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/refresh'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      return JwtResponse.fromJson(jsonDecode(response.body));
    }

    if (response.statusCode == 401 || response.statusCode == 403) {
      throw RefreshTokenExpiredException();
    }

    throw Exception('Token refresh failed: ${response.statusCode}');

    // final response = await http.post(
    //   Uri.parse('$_baseUrl/auth/refresh'),
    //   headers: {'Content-Type': 'application/json'},
    //   body: jsonEncode(request.toJson()),
    // );

    // if (response.statusCode == 200) {
    //   return JwtResponse.fromJson(jsonDecode(response.body));
    // } else {
    //   throw Exception('Token refresh failed: ${response.body}');
    // }
  }

  Future<int> logout() async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/logout'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${await _tokenStorage.getAccessToken()}',
      },
    );

    return response.statusCode;
  }

  // Future<void> logout() async {
  //   final response = await http.post(
  //     Uri.parse('$_baseUrl/auth/logout'),
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Bearer ${await _tokenStorage.getAccessToken()}',
  //     },
  //   );

  //   if (response.statusCode != 204) {
  //     throw Exception('Logout failed: ${response.body}');
  //   }
  // }
}

class RefreshTokenExpiredException implements Exception {}
