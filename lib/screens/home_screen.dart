// screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/quiz_service.dart';
import '../models/quiz_category.dart';
import 'quiz_screen.dart';
import 'all_categories_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 247, 250, 255),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header with Logo, Name, and Icons
              _buildHeader(),
              const SizedBox(height: 24),

              // 2. "Find Friends" Banner
              _buildFindFriendsBanner(context),
              const SizedBox(height: 24),

              // 3. "Discover" Section for Quiz Categories
              _buildDiscoverSection(context),

              const SizedBox(height: 24),

              // 4. "Promotion" Section
              _buildPromotionSection(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // Helper Widget for the Header
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromRGBO(106, 90, 224, 1),
                ),
                child: const Center(
                  child: Text(
                    'Q',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Quizzy',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF333333),
                ),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none_outlined,
                    color: Colors.black54, size: 28),
                onPressed: () {},
              ),
              const SizedBox(width: 8),
              const CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage('assets/avatar.png'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper Widget for the "Find Friends" Banner
  Widget _buildFindFriendsBanner(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(106, 90, 224, 1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Play quiz together with your friends now!',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.25),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Find Friends',
                      style: GoogleFonts.poppins(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Image.asset(
              'assets/friend.png',
              width: 100,
              height: 80,
              errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.people,
                  color: Colors.white,
                  size: 60),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widget for the "Discover" (Categories) Section
  Widget _buildDiscoverSection(BuildContext context) {
    final categories = QuizService.getQuizCategories();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Quiz Categories',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF333333),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AllCategoriesScreen(),
                    ),
                  );
                },
                child: Text(
                  'View all',
                  style: GoogleFonts.poppins(
                      color: const Color.fromRGBO(106, 90, 224, 1),
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 190,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length > 5 ? 5 : categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return _buildCategoryCard(context, category);
            },
            padding: const EdgeInsets.symmetric(horizontal: 20),
          ),
        ),
      ],
    );
  }

  // MODIFIED: Updated BoxShadow for consistency
  Widget _buildCategoryCard(BuildContext context, QuizCategory category) {
    return Container(
      margin: const EdgeInsets.only(right: 16, bottom: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(106, 90, 224, 1).withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => QuizScreen(category: category.name),
              ),
            );
          },
          child: SizedBox(
            width: 160,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 120,
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
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${category.questionCount} Qs',
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                  child: Text(
                    category.name,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF333333),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper Widget for the Promotion Section
  Widget _buildPromotionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            'Promotion',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF333333),
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 150,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              _buildPromoCard(
                  'Discount Course for Math Preparation!', 'assets/math.jpg'),
              _buildPromoCard(
                  'Learn History with Fun Quizzes!', 'assets/math.jpg'),
              _buildPromoCard(
                  'Boost Your English Vocabulary!', 'assets/math.jpg'),
            ],
          ),
        ),
      ],
    );
  }

  // Individual card for a promotion
  Widget _buildPromoCard(String title, String imagePath) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.3),
            BlendMode.darken,
          ),
          onError: (error, stackTrace) {},
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}























// // screens/home_screen.dart
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../services/quiz_service.dart';
// import '../models/quiz_category.dart';
// import 'quiz_screen.dart';
// import 'all_categories_screen.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // 1. Header with Logo, Name, and Icons
//               _buildHeader(),
//               const SizedBox(height: 24),

//               // 2. "Find Friends" Banner
//               _buildFindFriendsBanner(context),
//               const SizedBox(height: 24),

//               // 3. "Discover" Section for Quiz Categories
//               _buildDiscoverSection(context),

//               // <<< MODIFICATION 1: Removed the extra spacer from here
//               const SizedBox(height: 24), // Reverted to original consistent spacing

//               // 4. "Promotion" Section
//               _buildPromotionSection(),
//               const SizedBox(height: 24),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // Helper Widget for the Header
//   Widget _buildHeader() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Row(
//             children: [
//               Container(
//                 width: 40,
//                 height: 40,
//                 decoration: const BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: Color.fromRGBO(106, 90, 224, 1),
//                 ),
//                 child: const Center(
//                   child: Text(
//                     'Q',
//                     style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Text(
//                 'Quizzy',
//                 style: GoogleFonts.poppins(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                   color: const Color(0xFF333333),
//                 ),
//               ),
//             ],
//           ),
//           Row(
//             children: [
//               IconButton(
//                 icon: const Icon(Icons.notifications_none_outlined,
//                     color: Colors.black54, size: 28),
//                 onPressed: () {},
//               ),
//               const SizedBox(width: 8),
//               const CircleAvatar(
//                 radius: 20,
//                 backgroundImage: AssetImage('assets/avatar.png'),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   // Helper Widget for the "Find Friends" Banner
//   Widget _buildFindFriendsBanner(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20.0),
//       child: Container(
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           color: const Color(0xFF6A5AE0),
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Row(
//           children: [
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Play quiz together with your friends now!',
//                     style: GoogleFonts.poppins(
//                       color: Colors.white,
//                       fontSize: 18,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   ElevatedButton(
//                     onPressed: () {},
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.white.withOpacity(0.25),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       elevation: 0,
//                     ),
//                     child: Text(
//                       'Find Friends',
//                       style: GoogleFonts.poppins(color: Colors.white),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(width: 10),
//             Image.asset(
//               'assets/friend.png',
//               width: 100,
//               height: 80,
//               errorBuilder: (context, error, stackTrace) => const Icon(
//                   Icons.people,
//                   color: Colors.white,
//                   size: 60),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Helper Widget for the "Discover" (Categories) Section
//   Widget _buildDiscoverSection(BuildContext context) {
//     final categories = QuizService.getQuizCategories();
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Quiz Categories',
//                 style: GoogleFonts.poppins(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: const Color(0xFF333333),
//                 ),
//               ),
//               TextButton(
//                 // <<< 2. MODIFY this onPressed callback
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const AllCategoriesScreen(),
//                     ),
//                   );
//                 },
//                 child: Text(
//                   'View all',
//                   style: GoogleFonts.poppins(
//                       color: const Color.fromRGBO(106, 90, 224, 1),
//                       fontWeight: FontWeight.w600),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 16),
//         SizedBox(
//           height: 190,
//           child: ListView.builder(
//             scrollDirection: Axis.horizontal,
//             // Show a limited number of categories on the home screen
//             itemCount: categories.length > 5 ? 5 : categories.length,
//             itemBuilder: (context, index) {
//               final category = categories[index];
//               return _buildCategoryCard(context, category);
//             },
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//           ),
//         ),
//       ],
//     );
//   }


//   // Individual card for a category
//    Widget _buildCategoryCard(BuildContext context, QuizCategory category) {
//     return Container(
//       margin: const EdgeInsets.only(right: 16, bottom: 4),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16.0),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 1,
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(16.0),
//         child: InkWell(
//           onTap: () {
//             print("Tapped on category from home screen: ${category.name}");
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => QuizScreen(category: category.name),
//               ),
//             );
//           },
//           child: SizedBox(
//             width: 160,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   height: 120,
//                   decoration: BoxDecoration(
//                     image: DecorationImage(
//                       image: AssetImage(category.image),
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                   child: Stack(
//                     children: [
//                       Positioned(
//                         bottom: 8,
//                         right: 8,
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 8, vertical: 4),
//                           decoration: BoxDecoration(
//                             color: const Color.fromRGBO(106, 90, 224, 1),
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Text(
//                             '${category.questionCount} Qs',
//                             style: GoogleFonts.poppins(
//                                 color: Colors.white,
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.w500),
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
//                   child: Text(
//                     category.name,
//                     style: GoogleFonts.poppins(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                       color: const Color(0xFF333333),
//                     ),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // Helper Widget for the Promotion Section
//   Widget _buildPromotionSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20.0),
//           child: Text(
//             'Promotion',
//             style: GoogleFonts.poppins(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: const Color(0xFF333333),
//             ),
//           ),
//         ),
//         const SizedBox(height: 16),
//         SizedBox(
//           height: 150,
//           child: ListView(
//             scrollDirection: Axis.horizontal,
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             children: [
//               _buildPromoCard(
//                   'Discount Course for Math Preparation!', 'assets/math.jpg'),
//               _buildPromoCard(
//                   'Learn History with Fun Quizzes!', 'assets/math.jpg'),
//               _buildPromoCard(
//                   'Boost Your English Vocabulary!', 'assets/math.jpg'),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   // Individual card for a promotion
//   Widget _buildPromoCard(String title, String imagePath) {
//     return Container(
//       width: 280,
//       margin: const EdgeInsets.only(right: 16),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(16),
//         image: DecorationImage(
//           image: AssetImage(imagePath),
//           fit: BoxFit.cover,
//           colorFilter: ColorFilter.mode(
//             Colors.black.withOpacity(0.3),
//             BlendMode.darken,
//           ),
//           onError: (error, stackTrace) {},
//         ),
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.end,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             title,
//             style: GoogleFonts.poppins(
//               color: Colors.white,
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }