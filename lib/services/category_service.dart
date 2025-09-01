// services/category_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quiz_category.dart';
import 'auth_service.dart';

class CategoryService {
  static const String _baseUrl = 'https://quiz-api.camtech-dev.online';

  static Future<List<QuizCategory>> getCategories() async {
    final token = await AuthService.getToken();
    if (token == null) {
      print('CategoryService Error: Auth token is null.');
      return [];
    }

    final url = Uri.parse('$_baseUrl/api/category/list');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      // --- ADD THESE TWO LINES FOR DEBUGGING ---
      print('Category List Status Code: ${response.statusCode}');
      print('Category List Response Body: ${response.body}');
      // -----------------------------------------

      if (response.statusCode == 200) {
        final List<dynamic> categoryList = jsonDecode(response.body);
        return categoryList.map((json) => QuizCategory.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('Error fetching categories: $e');
      return [];
    }
  }
}