// screens/test_history_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../services/quiz_service.dart';
import '../models/test_result.dart';
import 'test_detail_screen.dart';

class TestHistoryScreen extends StatefulWidget {
  const TestHistoryScreen({super.key});

  @override
  State<TestHistoryScreen> createState() => _TestHistoryScreenState();
}

class _TestHistoryScreenState extends State<TestHistoryScreen> {
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    // Data is now read synchronously from the static list in QuizService,
    // which was populated from SharedPreferences when the app started.
    final List<TestResult> fullHistory = QuizService.testHistory;

    // Dynamically get categories from the loaded test history
    final List<String> categories = [
      'All',
      ...fullHistory.map((test) => test.category).toSet().toList()
    ];

    final List<TestResult> filteredHistory = _selectedCategory == 'All'
        ? fullHistory
        : fullHistory.where((test) => test.category == _selectedCategory).toList();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 247, 250, 255),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 247, 250, 255),
        elevation: 0,
        title: Text(
          'Test History',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
      body: Column(
        children: [
          // Build the filter dropdown only if there's history to filter
          if (fullHistory.isNotEmpty) _buildFilterDropdown(categories),
          
          // Display the correct view based on history content
          Expanded(
            child: fullHistory.isEmpty
                ? _buildEmptyState()
                : filteredHistory.isEmpty
                    ? _buildEmptyState(isFiltered: true)
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                        itemCount: filteredHistory.length,
                        itemBuilder: (context, index) {
                          TestResult test = filteredHistory[index];
                          return _buildHistoryCard(context, test);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown(List<String> categories) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: _selectedCategory,
            isExpanded: true,
            icon: const Icon(Icons.filter_list, color: Colors.black54),
            borderRadius: BorderRadius.circular(12),
            items: categories.map((String category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Text(
                  category,
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                // Check if the new value is actually in the list before setting state
                if (categories.contains(newValue)) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                }
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState({bool isFiltered = false}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history_toggle_off_outlined,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            isFiltered ? 'No History for this Category' : 'No Test History',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isFiltered ? 'Try selecting another category.' : 'Complete a quiz to see your results here.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(BuildContext context, TestResult test) {
    double percentageValue = test.totalQuestions > 0 ? (test.score / test.totalQuestions) : 0.0;
    int percentageInt = (percentageValue * 100).toInt();
    
    Color progressColor;
    if (percentageInt <= 30) {
      progressColor = Colors.red;
    } else if (percentageInt <= 65) {
      progressColor = Colors.orange;
    } else {
      progressColor = const Color.fromRGBO(106, 90, 224, 1);
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TestDetailScreen(testResult: test),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color.fromRGBO(106, 90, 224, 1).withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            SizedBox(
              width: 50,
              height: 50,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CircularProgressIndicator(
                    value: percentageValue,
                    strokeWidth: 5,
                    backgroundColor: progressColor.withOpacity(0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                  ),
                  Center(
                    child: Text(
                      '$percentageInt%',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: progressColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    test.category,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Score: ${test.score}/${test.totalQuestions}',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Completed: ${DateFormat.yMMMd().format(test.completedAt)}',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
          ],
        ),
      ),
    );
  }
}








// // screens/test_history_screen.dart
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart'; // For date formatting
// import '../services/quiz_service.dart';
// import '../models/test_result.dart';
// import 'test_detail_screen.dart';

// class TestHistoryScreen extends StatefulWidget {
//   const TestHistoryScreen({super.key});

//   @override
//   State<TestHistoryScreen> createState() => _TestHistoryScreenState();
// }

// class _TestHistoryScreenState extends State<TestHistoryScreen> {
//   String _selectedCategory = 'All';

//   @override
//   Widget build(BuildContext context) {
//     // Dynamically get categories from the test history
//     final List<String> categories = [
//       'All',
//       ...QuizService.testHistory.map((test) => test.category).toSet().toList()
//     ];

//     final List<TestResult> filteredHistory = _selectedCategory == 'All'
//         ? QuizService.testHistory
//         : QuizService.testHistory
//             .where((test) => test.category == _selectedCategory)
//             .toList();

//     return Scaffold(
//       backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
//       appBar: AppBar(
//         backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
//         elevation: 0,
//         title: Text(
//           'Test History',
//           style: GoogleFonts.poppins(
//             fontSize: 22,
//             fontWeight: FontWeight.bold,
//             color: Colors.black87,
//           ),
//         ),
//         actions: [
//           // Styled Filter Dropdown
//           Padding(
//             padding: const EdgeInsets.only(right: 12.0),
//             child: Container(
//               width: 150,
//               padding: const EdgeInsets.symmetric(horizontal: 12),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(color: Colors.grey.shade300),
//               ),
//               child: DropdownButtonHideUnderline(
//                 // MODIFIED: Added styling to the dropdown menu
//                 child: DropdownButton<String>(
//                   value: _selectedCategory,
//                   isExpanded: true,
//                   icon: const Icon(Icons.filter_list, color: Colors.black54),
//                   borderRadius: BorderRadius.circular(12),
//                   elevation: 4,
//                   dropdownColor: Colors.white,
//                   items: categories.map((String category) {
//                     return DropdownMenuItem<String>(
//                       value: category,
//                       child: Text(
//                         category,
//                         style: GoogleFonts.poppins(
//                           fontSize: 14,
//                           color: Colors.black87,
//                         ),
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     );
//                   }).toList(),
//                   onChanged: (String? newValue) {
//                     setState(() {
//                       _selectedCategory = newValue!;
//                     });
//                   },
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: filteredHistory.isEmpty
//           ? _buildEmptyState()
//           : ListView.builder(
//               // Increased top padding for more space
//               padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
//               itemCount: filteredHistory.length,
//               itemBuilder: (context, index) {
//                 TestResult test = filteredHistory[index];
//                 return _buildHistoryCard(context, test);
//               },
//             ),
//     );
//   }

//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.history_toggle_off_outlined,
//             size: 80,
//             color: Colors.grey.shade400,
//           ),
//           const SizedBox(height: 16),
//           Text(
//             'No Test History',
//             style: GoogleFonts.poppins(
//               fontSize: 18,
//               fontWeight: FontWeight.w600,
//               color: Colors.grey.shade600,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'Complete a quiz to see your results here.',
//             style: GoogleFonts.poppins(
//               fontSize: 14,
//               color: Colors.grey.shade500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildHistoryCard(BuildContext context, TestResult test) {
//     double percentageValue = (test.score / test.totalQuestions);
//     int percentageInt = (percentageValue * 100).toInt();
    
//     Color progressColor;
//     if (percentageInt <= 30) {
//       progressColor = Colors.red;
//     } else if (percentageInt <= 65) {
//       progressColor = const Color.fromARGB(255, 234, 215, 47);
//     } else {
//       progressColor = const Color.fromRGBO(106, 90, 224, 1);
//     }

//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => TestDetailScreen(testResult: test),
//           ),
//         );
//       },
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 16),
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.1),
//               spreadRadius: 1,
//               blurRadius: 10,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             // Circular Progress Indicator for Score
//             SizedBox(
//               width: 50,
//               height: 50,
//               child: Stack(
//                 fit: StackFit.expand,
//                 children: [
//                   CircularProgressIndicator(
//                     value: percentageValue,
//                     strokeWidth: 5,
//                     backgroundColor: progressColor.withOpacity(0.2),
//                     valueColor: AlwaysStoppedAnimation<Color>(progressColor),
//                   ),
//                   Center(
//                     child: Text(
//                       '$percentageInt%',
//                       style: GoogleFonts.poppins(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 14,
//                         color: progressColor,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(width: 16),
//             // Test Details
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     test.category,
//                     style: GoogleFonts.poppins(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                       color: Colors.black87,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     'Score: ${test.score}/${test.totalQuestions}',
//                     style: GoogleFonts.poppins(
//                       fontSize: 14,
//                       color: Colors.grey.shade700,
//                     ),
//                   ),
//                   const SizedBox(height: 2),
//                   Text(
//                     'Completed: ${DateFormat.yMMMd().format(test.completedAt)}',
//                     style: GoogleFonts.poppins(
//                       fontSize: 12,
//                       color: Colors.grey.shade500,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
//           ],
//         ),
//       ),
//     );
//   }
// }
