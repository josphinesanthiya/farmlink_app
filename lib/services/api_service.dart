import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:8081/api';

  static String? token;

  static Map<String, String> get headers {
    final headers = {
      'Content-Type': 'application/json',
    };

    if (token != null && token!.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  // =========================
  // LOGIN
  // =========================

  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (data['token'] != null) {
        token = data['token'];
      }

      return Map<String, dynamic>.from(data);
    }

    throw Exception(
      data is String ? data : 'Login failed',
    );
  }

  // =========================
  // REGISTER
  // =========================

  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'role': role,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return Map<String, dynamic>.from(data);
    }

    throw Exception(
      data is String ? data : 'Registration failed',
    );
  }

  // =========================
  // PROFILE
  // =========================

  static Future<Map<String, dynamic>> getProfile() async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/profile'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return Map<String, dynamic>.from(
        jsonDecode(response.body),
      );
    }

    throw Exception('Failed to load profile');
  }

  // =========================
  // LOCATION
  // =========================

  static Future<Map<String, dynamic>> updateLocation({
    required double latitude,
    required double longitude,
    String? location,
  }) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/users/location'),
      headers: headers,
      body: jsonEncode({
        'latitude': latitude,
        'longitude': longitude,
        'location': location,
      }),
    );

    if (response.statusCode == 200) {
      return Map<String, dynamic>.from(
        jsonDecode(response.body),
      );
    }

    throw Exception('Failed to update location');
  }

  static Future<List<dynamic>> getNearbyUsers({
    required String role,
    required double latitude,
    required double longitude,
    double radius = 20,
  }) async {
    final uri = Uri.parse(
      '$baseUrl/users/nearby'
      '?role=$role'
      '&latitude=$latitude'
      '&longitude=$longitude'
      '&radius=$radius',
    );

    final response = await http.get(
      uri,
      headers: headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    }

    throw Exception('Failed to find nearby users');
  }

  // =========================
  // CROPS
  // =========================

  static Future<List<dynamic>> getCrops() async {
    final response = await http.get(
      Uri.parse('$baseUrl/crops'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    }

    throw Exception('Failed to load crops');
  }

  static Future<List<dynamic>> getMyCrops() async {
    final response = await http.get(
      Uri.parse('$baseUrl/crops/my'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    }

    throw Exception('Failed to load your crops');
  }

  static Future<List<dynamic>> searchCrops(String name) async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/crops/search?name=${Uri.encodeComponent(name)}',
      ),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    }

    throw Exception('Failed to search crops');
  }

  // =========================
  // POSTS
  // =========================

  static Future<List<dynamic>> getPosts() async {
    final response = await http.get(
      Uri.parse('$baseUrl/posts'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    }

    throw Exception('Failed to load posts');
  }

  // =========================
  // NOTIFICATIONS
  // =========================

  static Future<List<dynamic>> getNotifications() async {
    final response = await http.get(
      Uri.parse('$baseUrl/notifications'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    }

    throw Exception('Failed to load notifications');
  }

  static Future<int> getUnreadNotificationCount() async {
    final response = await http.get(
      Uri.parse('$baseUrl/notifications/unread/count'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return int.parse(response.body);
    }

    throw Exception('Failed to load notification count');
  }

  // =========================
  // PAYMENTS
  // =========================

  static Future<List<dynamic>> getMyPayments() async {
    final response = await http.get(
      Uri.parse('$baseUrl/payments/my'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    }

    throw Exception('Failed to load payments');
  }

  // =========================
  // LOGOUT
  // =========================

  static void logout() {
    token = null;
  }
}