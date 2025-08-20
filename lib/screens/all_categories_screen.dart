import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/quiz_category.dart';
import '../services/quiz_service.dart';
import 'quiz_screen.dart';

class AllCategoriesScreen extends StatelessWidget {
  const AllCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = QuizService.getQuizCategories();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 247, 250, 255),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 247, 250, 255),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black54),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Discover',
          style: GoogleFonts.poppins(
            color: const Color(0xFF333333),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black54, size: 28),
            onPressed: () {
              // Handle search action
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20.0),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return _buildCategoryListItem(context, category);
        },
      ),
    );
  }

  // Helper widget for each item in the list
  Widget _buildCategoryListItem(BuildContext context, QuizCategory category) {
    const String description = "A fun quiz to help you be well prepare for the upcoming national exam.";

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuizScreen(category: category.name),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            // MODIFIED: Changed shadow to be consistent with other screens
            BoxShadow(
              color: const Color.fromRGBO(106, 90, 224, 1).withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Image on the left
                Container(
                  width: 100,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(category.image),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(106, 90, 224, 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${category.questionCount} Qs',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Text details on the right
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          category.name,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF333333),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          description,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}







// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../models/quiz_category.dart';
// import '../services/quiz_service.dart';
// import 'quiz_screen.dart';

// class AllCategoriesScreen extends StatelessWidget {
//   const AllCategoriesScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final categories = QuizService.getQuizCategories();

//     return Scaffold(
//       backgroundColor: const Color(0xFFF4F6F8),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFFF4F6F8),
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: Colors.black54),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         title: Text(
//           'Discover',
//           style: GoogleFonts.poppins(
//             color: const Color(0xFF333333),
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.search, color: Colors.black54, size: 28),
//             onPressed: () {
//               // Handle search action
//             },
//           ),
//         ],
//       ),
//       body: ListView.builder(
//         padding: const EdgeInsets.all(20.0),
//         itemCount: categories.length,
//         itemBuilder: (context, index) {
//           final category = categories[index];
//           return _buildCategoryListItem(context, category);
//         },
//       ),
//     );
//   }

//   // Helper widget for each item in the list
//   Widget _buildCategoryListItem(BuildContext context, QuizCategory category) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => QuizScreen(category: category.name),
//           ),
//         );
//       },
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 16),
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.1),
//               spreadRadius: 1,
//               blurRadius: 5,
//               offset: const Offset(0, 3),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             // Image on the left
//             Container(
//               width: 80,
//               height: 80,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(12),
//                 image: DecorationImage(
//                   image: AssetImage(category.image),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               child: Stack(
//                 children: [
//                   Positioned(
//                     bottom: 4,
//                     right: 4,
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 6, vertical: 2),
//                       decoration: BoxDecoration(
//                         color: Colors.blue,
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: Text(
//                         '${category.questionCount} Qs',
//                         style: GoogleFonts.poppins(
//                           color: Colors.white,
//                           fontSize: 10,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(width: 16),
//             // Text details on the right
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     category.name,
//                     style: GoogleFonts.poppins(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: const Color(0xFF333333),
//                     ),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     // You can add more details to your model if needed
//                     '${(category.questionCount * 1.5).toStringAsFixed(1)}k plays',
//                     style: GoogleFonts.poppins(
//                       fontSize: 12,
//                       color: Colors.black54,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
