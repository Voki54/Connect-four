import 'dart:convert';
import 'package:connect_four/features/auth/token_storage.dart';
import 'package:http/http.dart' as http;
import 'statistics_response.dart';
import 'update_statistics_request.dart';

class StatisticsService {
  final String _baseUrl;
  final TokenStorage _tokenStorage;

  StatisticsService(this._baseUrl, this._tokenStorage);

  Future<StatisticsResponse> getStatistics() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/api/statistics'),
      headers: {
        'Authorization': 'Bearer ${await _tokenStorage.getAccessToken()}',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final map = json.decode(response.body) as Map<String, dynamic>;
      return StatisticsResponse.fromMap(map);
    } else {
      throw Exception('Failed to fetch statistics: ${response.statusCode}');
    }
  }

  Future<StatisticsResponse> updateStatistics(
    UpdateStatisticsRequest request,
  ) async {
    print("TOKEN ${_tokenStorage.getAccessToken()}");
    final response = await http.put(
      Uri.parse('$_baseUrl/api/statistics'),
      headers: {
        'Authorization': 'Bearer ${await _tokenStorage.getAccessToken()}',
        'Content-Type': 'application/json',
      },
      body: json.encode(request.toMap()),
    );

    if (response.statusCode == 200) {
      final map = json.decode(response.body) as Map<String, dynamic>;
      return StatisticsResponse.fromMap(map);
    } else {
      throw Exception('Failed to update statistics: ${response.statusCode}');
    }
  }
}
