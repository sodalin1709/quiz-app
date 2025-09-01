// // services/home_page_service.dart
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../models/home_page_data.dart';
// import 'auth_service.dart';

// class HomePageService {
//   // TODO: Replace with your actual base URL
//   static const String _baseUrl = 'https://quiz-api.camtech-dev.online';

//   static Future<HomePageData?> getHomePageData() async {
//     final token = await AuthService.getToken();
//     if (token == null) return null;

//     final url = Uri.parse('$_baseUrl/api/home-page');
//     try {
//       final response = await http.get(
//         url,
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//       );

//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);
//         // Assuming the actual data is nested under a 'data' key in the response
//         return HomePageData.fromJson(responseData['data']);
//       }
//       return null;
//     } catch (e) {
//       print('Error fetching home page data: $e');
//       return null;
//     }
//   }
// }