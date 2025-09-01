// // models/home_page_data.dart
// import 'quiz_category.dart';

// class HomePageData {
//   final List<QuizCategory> categories;
//   // Using Map<String, dynamic> for promotions for simplicity
//   final List<Map<String, dynamic>> promotions;

//   HomePageData({
//     required this.categories,
//     required this.promotions,
//   });

//   factory HomePageData.fromJson(Map<String, dynamic> json) {
//     final List<dynamic> categoryList = json['categories'] ?? [];
//     final List<dynamic> promotionList = json['promotions'] ?? [];

//     return HomePageData(
//       categories: categoryList.map((c) => QuizCategory.fromJson(c)).toList(),
//       promotions: List<Map<String, dynamic>>.from(promotionList),
//     );
//   }
// }