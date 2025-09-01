// screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../services/category_service.dart';
import '../models/quiz_category.dart';
import 'quiz_screen.dart';
import 'all_categories_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<QuizCategory>> _categoriesFuture;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = CategoryService.getCategories();
  }

  @override
  Widget build(BuildContext context) {
    // This line makes the screen listen for language changes,
    // causing a rebuild when the language is toggled.
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 247, 250, 255),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildFindFriendsBanner(context),
              const SizedBox(height: 24),
              _buildDiscoverSection(context),
              const SizedBox(height: 24),
              _buildPromotionSection(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 40, height: 40,
                    decoration: const BoxDecoration(shape: BoxShape.circle, color: Color.fromRGBO(106, 90, 224, 1)),
                    child: const Center(child: Text('Q', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold))),
                  ),
                  const SizedBox(width: 12),
                  Text('Quizzy', style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: const Color(0xFF333333))),
                ],
              ),
              Row(
                children: [
                  // --- FIX STARTS HERE ---
                  GestureDetector(
                    onTap: () {
                      Provider.of<LanguageProvider>(context, listen: false).toggleLanguage();
                    },
                    child: Container(
                      width: 42,
                      height: 32,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0), // Rounded border
                        image: DecorationImage(
                          image: AssetImage(languageProvider.currentFlag),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  // --- FIX ENDS HERE ---
                  const SizedBox(width: 16),
                  const CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage('assets/avatar.png'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFindFriendsBanner(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: const Color.fromRGBO(106, 90, 224, 1), borderRadius: BorderRadius.circular(20)),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Play quiz together with your friends now!', style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.white.withOpacity(0.25), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0),
                    child: Text('Find Friends', style: GoogleFonts.poppins(color: Colors.white)),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Image.asset('assets/friend.png', width: 100, height: 80, errorBuilder: (context, error, stackTrace) => const Icon(Icons.people, color: Colors.white, size: 60)),
          ],
        ),
      ),
    );
  }

  Widget _buildDiscoverSection(BuildContext context) {
    return FutureBuilder<List<QuizCategory>>(
      future: _categoriesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(height: 220, child: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return SizedBox(height: 220, child: Center(child: Text('Could not load categories.', style: GoogleFonts.poppins())));
        }

        final categories = snapshot.data!;
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Quiz Categories', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF333333))),
                  TextButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AllCategoriesScreen())),
                    child: Text('View all', style: GoogleFonts.poppins(color: const Color.fromRGBO(106, 90, 224, 1), fontWeight: FontWeight.w600)),
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
                itemBuilder: (context, index) => _buildCategoryCard(context, categories[index]),
                padding: const EdgeInsets.symmetric(horizontal: 20),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCategoryCard(BuildContext context, QuizCategory category) {
    return Container(
      margin: const EdgeInsets.only(right: 16, bottom: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [BoxShadow(color: const Color.fromRGBO(106, 90, 224, 1).withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => QuizScreen(
                categoryId: category.id,
                categoryName: category.nameEn,
              ),
            ));
          },
          child: SizedBox(
            width: 160,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 120,
                  decoration: BoxDecoration(image: DecorationImage(image: NetworkImage(category.iconUrl), fit: BoxFit.cover, onError: (e, s) {})),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                  child: Text(
                    category.getName(context),
                    style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: const Color(0xFF333333)),
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

  Widget _buildPromotionSection() {
    final List<Map<String, String>> promotions = [
      {'title': 'Discount Course for Math Preparation!', 'image': 'assets/math.jpg'},
      {'title': 'Learn History with Fun Quizzes!', 'image': 'assets/history.jpg'},
      {'title': 'Discount Course for Math Preparation!', 'image': 'assets/math.jpg'},
      {'title': 'Learn History with Fun Quizzes!', 'image': 'assets/history.jpg'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text('Promotion', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF333333))),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: promotions.length,
            itemBuilder: (context, index) => _buildPromoCard(promotions[index]['title']!, promotions[index]['image']!),
          ),
        ),
      ],
    );
  }

  Widget _buildPromoCard(String title, String imagePath) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover, colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.darken), onError: (error, stackTrace) {}),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// // screens/home_screen.dart
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../services/category_service.dart';
// import '../models/quiz_category.dart';
// import 'quiz_screen.dart';
// import 'all_categories_screen.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   // This future will hold the state of our API call for categories
//   late Future<List<QuizCategory>> _categoriesFuture;

//   @override
//   void initState() {
//     super.initState();
//     // Fetch the categories when the screen is first built
//     _categoriesFuture = CategoryService.getCategories();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 247, 250, 255),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildHeader(),
//               const SizedBox(height: 24),
//               _buildFindFriendsBanner(context),
//               const SizedBox(height: 24),
              
//               // This section is now dynamic and handles loading/error states
//               _buildDiscoverSection(context),

//               const SizedBox(height: 24),
              
//               // This section uses static placeholder data
//               _buildPromotionSection(),
//               const SizedBox(height: 24),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

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

//   Widget _buildFindFriendsBanner(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20.0),
//       child: Container(
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           color: const Color.fromRGBO(106, 90, 224, 1),
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

//   Widget _buildDiscoverSection(BuildContext context) {
//     return FutureBuilder<List<QuizCategory>>(
//       future: _categoriesFuture,
//       builder: (context, snapshot) {
//         // Handle loading state
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const SizedBox(
//             height: 190,
//             child: Center(child: CircularProgressIndicator()),
//           );
//         }

//         // Handle error state
//         if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
//           return SizedBox(
//             height: 190,
//             child: Center(
//               child: Text(
//                 'Could not load categories.',
//                 style: GoogleFonts.poppins(),
//               ),
//             ),
//           );
//         }

//         final categories = snapshot.data!;
//         return Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Quiz Categories',
//                     style: GoogleFonts.poppins(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: const Color(0xFF333333),
//                     ),
//                   ),
//                   TextButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const AllCategoriesScreen(),
//                         ),
//                       );
//                     },
//                     child: Text(
//                       'View all',
//                       style: GoogleFonts.poppins(
//                           color: const Color.fromRGBO(106, 90, 224, 1),
//                           fontWeight: FontWeight.w600),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 16),
//             SizedBox(
//               height: 190,
//               child: ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: categories.length > 5 ? 5 : categories.length,
//                 itemBuilder: (context, index) {
//                   final category = categories[index];
//                   return _buildCategoryCard(context, category);
//                 },
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
  
//   Widget _buildCategoryCard(BuildContext context, QuizCategory category) {
//     return Container(
//       margin: const EdgeInsets.only(right: 16, bottom: 5),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16.0),
//         boxShadow: [
//           BoxShadow(
//             color: const Color.fromRGBO(106, 90, 224, 1).withOpacity(0.1),
//             blurRadius: 10,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(16.0),
//         child: InkWell(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => QuizScreen(
//                   categoryId: category.id,
//                   categoryName: category.nameEn,
//                 ),
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
//                       image: NetworkImage(category.iconUrl),
//                       fit: BoxFit.cover,
//                       onError: (e, s) {}, // Silently handle image load errors
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
//                   child: Text(
//                     category.nameEn,
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

//   Widget _buildPromotionSection() {
//     // Using static placeholder data as the API does not provide it.
//     final List<Map<String, String>> promotions = [
//       {'title': 'Discount Course for Math Preparation!', 'image': 'assets/math.jpg'},
//       {'title': 'Learn History with Fun Quizzes!', 'image': 'assets/history.jpg'},
//       {'title': 'Expand your Knowledge with our Books Collection!', 'image': 'assets/general_knowledge.jpg'},
//       {'title': 'MBTI Test with special price!', 'image': 'assets/personality_test.jpg'},
//     ];

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
//           child: ListView.builder(
//             scrollDirection: Axis.horizontal,
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             itemCount: promotions.length,
//             itemBuilder: (context, index) {
//               return _buildPromoCard(
//                 promotions[index]['title']!,
//                 promotions[index]['image']!,
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }

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