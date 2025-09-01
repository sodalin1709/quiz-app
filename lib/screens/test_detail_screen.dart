// screens/test_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../models/test_result.dart';
import '../models/question_quiz.dart';

class TestDetailScreen extends StatelessWidget {
  final TestResult testResult;

  const TestDetailScreen({required this.testResult, super.key});

  @override
  Widget build(BuildContext context) {
    // Listen for language changes to rebuild the screen
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 247, 250, 255),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 247, 250, 255),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black54),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Test Details', style: GoogleFonts.poppins(color: Colors.black87, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context, testResult),
            _buildQuestionList(context, testResult),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionList(BuildContext context, TestResult testResult) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Questions & Answers', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: testResult.questions.length,
            itemBuilder: (context, index) {
              final question = testResult.questions[index];
              final normalizedSelection = (question.customerAnswer ?? "").replaceAll("u00b0", "°");
              final normalizedAnswer = (question.answer ?? "").replaceAll("u00b0", "°");
              final isCorrect = normalizedSelection.isNotEmpty && normalizedSelection == normalizedAnswer;
              return _buildReviewCard(context, question, isCorrect);
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildReviewCard(BuildContext context, QuestionQuiz question, bool isCorrect) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [BoxShadow(color: const Color.fromRGBO(106, 90, 224, 1).withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(isCorrect ? Icons.check_circle : Icons.cancel, color: isCorrect ? Colors.green : Colors.red, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "Q${question.index}: ${question.getQuestion(context)}", // Use getter for correct language
                  style: GoogleFonts.poppins(fontSize: 16.0, fontWeight: FontWeight.w600, color: Colors.black87),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildAnswerReview("Your Answer:", question.customerAnswer ?? "Not answered", isCorrect),
          if (!isCorrect) ...[
            const SizedBox(height: 8),
            _buildAnswerReview("Correct Answer:", question.answer!, true),
          ],
        ],
      ),
    );
  }

  // Header widget displaying the test summary
  Widget _buildHeader(BuildContext context, TestResult testResult) {
    const Color primaryColor = Color.fromRGBO(106, 90, 224, 1);

    return Container(
      margin: const EdgeInsets.all(20.0),
      padding: const EdgeInsets.all(20.0),
      width: double.infinity,
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            testResult.category,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Completed on ${DateFormat.yMMMd().format(testResult.completedAt)}',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildScoreCard("Score", "${testResult.score * 10}"),
              _buildScoreCard("Correct", "${testResult.score}/${testResult.totalQuestions}"),
            ],
          ),
        ],
      ),
    );
  }

  // Reusable widget for displaying score details
  Widget _buildScoreCard(String title, String value) {
    return Column(
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            color: Colors.white.withOpacity(0.8),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // Reusable widget for displaying an answer
  Widget _buildAnswerReview(String title, String answer, bool isCorrect) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isCorrect ? Colors.green.shade50 : Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: RichText(
        text: TextSpan(
          style: GoogleFonts.poppins(fontSize: 14.0, color: Colors.black87),
          children: [
            TextSpan(
              text: title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: ' $answer'),
          ],
        ),
      ),
    );
  }
}




// // screens/test_detail_screen.dart
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';
// import '../models/test_result.dart';
// import '../models/question_quiz.dart'; // Ensure QuestionQuiz is imported

// class TestDetailScreen extends StatelessWidget {
//   final TestResult testResult;

//   const TestDetailScreen({required this.testResult, super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 247, 250, 255),
//       appBar: AppBar(
//         backgroundColor: const Color.fromARGB(255, 247, 250, 255),
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: Colors.black54),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         title: Text(
//           'Test Details',
//           style: GoogleFonts.poppins(
//             color: Colors.black87,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             // Header with test summary
//             _buildHeader(context, testResult),
//             // List of questions and answers
//             _buildQuestionList(testResult),
//           ],
//         ),
//       ),
//     );
//   }

//   // Header widget displaying the test summary
//   Widget _buildHeader(BuildContext context, TestResult testResult) {
//     const Color primaryColor = Color.fromRGBO(106, 90, 224, 1);

//     return Container(
//       margin: const EdgeInsets.all(20.0),
//       padding: const EdgeInsets.all(20.0),
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: primaryColor,
//         borderRadius: BorderRadius.circular(20.0),
//         boxShadow: [
//           BoxShadow(
//             color: primaryColor.withOpacity(0.3),
//             blurRadius: 10,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Text(
//             testResult.category,
//             textAlign: TextAlign.center,
//             style: GoogleFonts.poppins(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'Completed on ${DateFormat.yMMMd().format(testResult.completedAt)}',
//             style: GoogleFonts.poppins(
//               fontSize: 14,
//               color: Colors.white.withOpacity(0.8),
//             ),
//           ),
//           const SizedBox(height: 20),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               _buildScoreCard("Score", "${testResult.score * 10}"),
//               _buildScoreCard("Correct", "${testResult.score}/${testResult.totalQuestions}"),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   // Reusable widget for displaying score details
//   Widget _buildScoreCard(String title, String value) {
//     return Column(
//       children: [
//         Text(
//           title,
//           style: GoogleFonts.poppins(
//             color: Colors.white.withOpacity(0.8),
//             fontSize: 14,
//           ),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           value,
//           style: GoogleFonts.poppins(
//             color: Colors.white,
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ],
//     );
//   }

//   // Widget for displaying the list of questions
//   Widget _buildQuestionList(TestResult testResult) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 20.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Questions & Answers',
//             style: GoogleFonts.poppins(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: Colors.black87,
//             ),
//           ),
//           const SizedBox(height: 16),
//           ListView.builder(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemCount: testResult.questions.length,
//             itemBuilder: (context, index) {
//               final question = testResult.questions[index];
//               final isCorrect = question.answer == question.customerAnswer;
//               return _buildReviewCard(question, isCorrect);
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   // MODIFIED: Updated BoxShadow for consistency
//   Widget _buildReviewCard(QuestionQuiz question, bool isCorrect) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12.0),
//         boxShadow: [
//           BoxShadow(
//             color: const Color.fromRGBO(106, 90, 224, 1).withOpacity(0.1),
//             blurRadius: 10,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Icon(
//                 isCorrect ? Icons.check_circle : Icons.cancel,
//                 color: isCorrect ? Colors.green : Colors.red,
//                 size: 24,
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Text(
//                   "Q${question.index}: ${question.question}",
//                   style: GoogleFonts.poppins(
//                     fontSize: 16.0,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.black87,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           _buildAnswerReview("Your Answer:", question.customerAnswer ?? "Not answered", isCorrect),
//           if (!isCorrect) ...[
//             const SizedBox(height: 8),
//             _buildAnswerReview("Correct Answer:", question.answer!, true),
//           ],
//         ],
//       ),
//     );
//   }

//   // Reusable widget for displaying an answer
//   Widget _buildAnswerReview(String title, String answer, bool isCorrect) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: isCorrect ? Colors.green.shade50 : Colors.red.shade50,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: RichText(
//         text: TextSpan(
//           style: GoogleFonts.poppins(fontSize: 14.0, color: Colors.black87),
//           children: [
//             TextSpan(
//               text: title,
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//             TextSpan(text: ' $answer'),
//           ],
//         ),
//       ),
//     );
//   }
// }

