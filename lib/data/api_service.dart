import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static String baseUrl = "http://10.0.2.2:3000/api";

  static void useProd() {
    baseUrl = "https://devlogpro-api.onrender.com/api";
  }

  static void useLocalhost() {
    baseUrl = "http://10.0.2.2:3000/api";
  }

  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    final res = await http.post(
      Uri.parse("$baseUrl/auth/login"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);

      if (data['token'] == null) {
        throw Exception("Invalid login response");
      }

      return data;
    } else {
      final err = jsonDecode(res.body);
      throw Exception(err['message'] ?? "Login failed");
    }
  }

  static Future<Map<String, dynamic>> signup(
      String name, String email, String password) async {
    final res = await http.post(
      Uri.parse("$baseUrl/auth/register"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "name": name,
        "email": email,
        "password": password,
      }),
    );

    if (res.statusCode == 200 || res.statusCode == 201) {
      return jsonDecode(res.body);
    } else {
      throw Exception("Signup failed: ${res.body}");
    }
  }

  static Future<List<dynamic>> getProjects(String userId) async {
    final res = await http.get(
      Uri.parse("$baseUrl/projects/user/$userId"),
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      throw Exception("Failed to fetch projects: ${res.body}");
    }
  }

  static Future<void> logTime({
    required String userId,
    required String projectId,
    required String stack,
    required double hours,
    String? description,
  }) async {
    final res = await http.post(
      Uri.parse("$baseUrl/logs"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "userId": userId,
        "projectId": projectId,
        "stack": stack,
        "hours": hours,
        "description": description ?? "",
      }),
    );

    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception("Failed to log time: ${res.body}");
    }
  }

  static Future<Map<String, dynamic>> getWeeklyReport(String userId) async {
    final res = await http.get(
      Uri.parse("$baseUrl/reports/weekly/$userId"),
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      throw Exception("Failed to fetch weekly report: ${res.body}");
    }
  }

  static Future<List<Map<String, dynamic>>> getLogsByProject({
    required String projectId,
    String? userId,
  }) async {
    final res = await http.get(
      Uri.parse(
        "$baseUrl/logs/project/$projectId${userId != null ? '?userId=$userId' : ''}",
      ),
    );

    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => Map<String, dynamic>.from(e)).toList();
    } else {
      throw Exception("Failed to fetch logs: ${res.body}");
    }
  }

  static Future<List<dynamic>> listSessions() async {
    return [];
  }

  static Future<Map<String, dynamic>> getCurrentUser() async {
    return {
      "name": "Shabana Khan",
      "email": "shabana.khan@company.com",
    };
  }

  static Future<Map<String, dynamic>> getPreferences() async {
    return {
      "theme": "light",
    };
  }

  static Future<void> updatePreferences(Map<String, String> prefs) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  static Future<void> deleteSession() async {
    await Future.delayed(const Duration(milliseconds: 300));
  }
}
