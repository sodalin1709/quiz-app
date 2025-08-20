// screens/quiz_result_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/question_quiz.dart';
import 'main_screen.dart'; // Import MainScreen
import 'quiz_screen.dart';

class QuizResultScreen extends StatelessWidget {
  final int totalCorrectAnswers;
  final List<QuestionQuiz> summaryQuestions;
  final String category;

  const QuizResultScreen({
    required this.totalCorrectAnswers,
    required this.summaryQuestions,
    required this.category,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double percentage = (totalCorrectAnswers / summaryQuestions.length) * 100;
    const Color primaryColor = Color.fromRGBO(106, 90, 224, 1);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 247, 250, 255),
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            _buildHeader(context, percentage, primaryColor),
            // Body Section (Scrollable)
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Review Answers',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Review List
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: summaryQuestions.length,
                        itemBuilder: (context, index) {
                          final sq = summaryQuestions[index];
                          bool isCorrect = sq.answer == sq.customerAnswer;
                          return _buildReviewCard(sq, isCorrect);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Footer with Buttons
            _buildFooterButtons(context, primaryColor),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, double percentage, Color primaryColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30.0),
          bottomRight: Radius.circular(30.0),
        ),
      ),
      child: Column(
        children: [
          Text(
            'Congratulations!',
            style: GoogleFonts.poppins(
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'You have completed the quiz.',
            style: GoogleFonts.poppins(
              fontSize: 16.0,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildScoreCard("Score", "${(totalCorrectAnswers * 10)}"),
              const SizedBox(width: 20),
              _buildScoreCard("Correct", "$totalCorrectAnswers/${summaryQuestions.length}"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScoreCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
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
      ),
    );
  }

  // MODIFIED: Updated BoxShadow for consistency
  Widget _buildReviewCard(QuestionQuiz sq, bool isCorrect) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(106, 90, 224, 1).withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                isCorrect ? Icons.check_circle : Icons.cancel,
                color: isCorrect ? Colors.green : Colors.red,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "Q${sq.index}: ${sq.question}",
                  style: GoogleFonts.poppins(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildAnswerReview("Your Answer:", sq.customerAnswer ?? "Not answered", isCorrect),
          if (!isCorrect) ...[
            const SizedBox(height: 8),
            _buildAnswerReview("Correct Answer:", sq.answer!, true),
          ],
        ],
      ),
    );
  }

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

  Widget _buildFooterButtons(BuildContext context, Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const MainScreen()),
                  (Route<dynamic> route) => false,
                );
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(color: primaryColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Back to Home',
                style: GoogleFonts.poppins(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: primaryColor,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizScreen(category: category),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: Text(
                'Take Again',
                style: GoogleFonts.poppins(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
