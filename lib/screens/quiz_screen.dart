// screens/quiz_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/question_quiz.dart';
import '../models/test_result.dart';
import '../providers/language_provider.dart';
import '../services/quiz_service.dart';
import '../services/report_service.dart';
import 'quiz_result_screen.dart';

class QuizScreen extends StatefulWidget {
  final int categoryId;
  final String categoryName;

  const QuizScreen({
    required this.categoryId,
    required this.categoryName,
    super.key,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with SingleTickerProviderStateMixin {
  late List<QuestionQuiz> _questions;
  int _questionIndex = 0;
  String? _selectedAnswer;
  bool _isAnswered = false;
  final List<String?> _selections = [];
  bool _isLoading = true;

  late AnimationController _timerController;
  static const int _quizDurationInSeconds = 30;

  @override
  void initState() {
    super.initState();
    _timerController = AnimationController(vsync: this, duration: const Duration(seconds: _quizDurationInSeconds));
    _timerController.addStatusListener((status) {
      if (status == AnimationStatus.completed) _handleAnswer(null);
    });
    _loadQuestions();
  }

  @override
  void dispose() {
    _timerController.dispose();
    super.dispose();
  }

  Future<void> _loadQuestions() async {
    final fetchedQuestions = await QuizService.getQuestions(widget.categoryId);
    if (!mounted) return;
    setState(() {
      _questions = fetchedQuestions;
      _isLoading = false;
    });
    if (_questions.isNotEmpty) _startTimer();
  }

  void _startTimer() {
    _timerController.reset();
    _timerController.forward();
  }

  void _handleAnswer(String? answer) {
    if (_isAnswered) return;
    _timerController.stop();
    _selections.add(answer);
    setState(() {
      _selectedAnswer = answer;
      _isAnswered = true;
    });
    Future.delayed(const Duration(seconds: 2), () => _nextQuestion());
  }

  void _nextQuestion() {
    if (_questionIndex < _questions.length - 1) {
      setState(() {
        _questionIndex++;
        _selectedAnswer = null;
        _isAnswered = false;
      });
      _startTimer();
    } else {
      _completeQuiz();
    }
  }

  void _completeQuiz() async {
    int totalCorrectAnswers = 0;
    List<QuestionQuiz> summaryQuestions = [];
    final int totalQuestions = _questions.length;

    for (int i = 0; i < totalQuestions; i++) {
      QuestionQuiz originalQuestion = _questions[i];
      originalQuestion.customerAnswer = _selections[i];
      originalQuestion.index = i + 1;

      String normalizedSelection = (_selections[i] ?? "").replaceAll("u00b0", "°");
      String normalizedAnswer = (originalQuestion.answer ?? "").replaceAll("u00b0", "°");

      if (normalizedSelection.isNotEmpty && normalizedSelection == normalizedAnswer) {
        totalCorrectAnswers++;
      }
      summaryQuestions.add(originalQuestion);
    }

    await ReportService.submitReport(score: totalCorrectAnswers * 10, totalQuestion: totalQuestions, totalCorrect: totalCorrectAnswers, categoryEn: widget.categoryName);

    final result = TestResult(category: widget.categoryName, categoryId: widget.categoryId, score: totalCorrectAnswers, totalQuestions: totalQuestions, completedAt: DateTime.now(), questions: summaryQuestions);
    await QuizService.saveTestResult(result);

    if (!mounted) return;

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => QuizResultScreen(totalCorrectAnswers: totalCorrectAnswers, summaryQuestions: summaryQuestions, category: widget.categoryName, categoryId: widget.categoryId)));
  }

  void _exitQuiz() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Exit Quiz'),
        content: const Text('Are you sure you want to exit? Your progress will not be saved.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
          TextButton(onPressed: () { Navigator.of(context).pop(); Navigator.of(context).pop(); }, child: const Text('Exit')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Listen for language changes to rebuild the UI with the correct text
    final languageProvider = Provider.of<LanguageProvider>(context);

    if (_isLoading) return Scaffold(appBar: AppBar(title: Text(widget.categoryName)), body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [const CircularProgressIndicator(), const SizedBox(height: 16), Text("Loading Questions...", style: GoogleFonts.poppins())])));
    if (_questions.isEmpty) return Scaffold(appBar: AppBar(title: Text(widget.categoryName)), body: Center(child: Text('No questions found for this category.', style: GoogleFonts.poppins())));

    final QuestionQuiz currentQuestion = _questions[_questionIndex];

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 247, 250, 255),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 80),
              Stack(clipBehavior: Clip.none, alignment: Alignment.topCenter, children: [_buildQuestionCard(currentQuestion), Positioned(top: -30, child: _buildTimer())]),
              const SizedBox(height: 30),
              Expanded(
                child: ListView(
                  children: currentQuestion.getOptions(context).map((option) {
                    final displayOption = option.replaceAll("u00b0", "°");
                    final correctAnswerInCurrentLang = currentQuestion.answer!.replaceAll("u00b0", "°");
                    return _buildAnswerOption(displayOption, correctAnswerInCurrentLang, currentQuestion.getOptions(context));
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionCard(QuestionQuiz question) {
    return Container(
      width: double.infinity,
      height: 180,
      alignment: Alignment.center,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      decoration: BoxDecoration(color: const Color(0xFFE6E1FF), borderRadius: BorderRadius.circular(25.0)),
      child: Text(question.getQuestion(context), textAlign: TextAlign.center, style: GoogleFonts.poppins(color: const Color(0xFF0D1845), fontSize: 20, fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildAnswerOption(String option, String correctAnswer, List<String> allOptions) {
    bool isSelected = _selectedAnswer == option;
    Color borderColor = Colors.grey.shade300;
    Color backgroundColor = Colors.white;
    Color textColor = Colors.black54;
    Widget? trailingIcon;

    if (_isAnswered) {
      final normalizedCorrectAnswer = correctAnswer.replaceAll("u00b0", "°");
      if (option == normalizedCorrectAnswer) {
        backgroundColor = const Color(0xFFE6E1FF);
        borderColor = const Color.fromRGBO(106, 90, 224, 1);
        textColor = const Color.fromRGBO(106, 90, 224, 1);
        trailingIcon = const Icon(Icons.check_circle, color: Color.fromRGBO(106, 90, 224, 1));
      } else if (isSelected) {
        backgroundColor = const Color(0xFFFFEBEB);
        borderColor = Colors.red;
        textColor = Colors.red;
        trailingIcon = const Icon(Icons.cancel, color: Colors.red);
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: _isAnswered ? null : () => _handleAnswer(option),
        borderRadius: BorderRadius.circular(15.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(color: backgroundColor, border: Border.all(color: borderColor, width: 2), borderRadius: BorderRadius.circular(15.0)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(option, style: GoogleFonts.poppins(color: textColor, fontSize: 16, fontWeight: FontWeight.w500))),
              if (trailingIcon != null) trailingIcon,
              if (trailingIcon == null) Container(width: 24, height: 24, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.grey.shade400))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "${_questionIndex + 1}/${_questions.length}",
          style: GoogleFonts.poppins(color: Colors.grey.shade600, fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: (_questionIndex + 1) / _questions.length,
              minHeight: 10,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(Color.fromRGBO(106, 90, 224, 1)),
            ),
          ),
        ),
        const SizedBox(width: 24),
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.grey.shade300, width: 2)),
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.close, color: Colors.black54, size: 20),
            onPressed: _exitQuiz,
          ),
        ),
      ],
    );
  }

  Widget _buildTimer() {
    return AnimatedBuilder(
      animation: _timerController,
      builder: (context, child) {
        int remainingSeconds = (_quizDurationInSeconds * (1 - _timerController.value)).round();
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(width: 60, height: 60, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
            SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(
                value: _timerController.value,
                strokeWidth: 6,
                backgroundColor: Colors.grey.shade300,
                valueColor: const AlwaysStoppedAnimation<Color>(Color.fromRGBO(106, 90, 224, 1)),
              ),
            ),
            Text(
              '$remainingSeconds',
              style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: const Color(0xFF0D1845)),
            ),
          ],
        );
      },
    );
  }
}




// // screens/quiz_screen.dart
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../models/question_quiz.dart';
// import '../models/test_result.dart';
// import '../services/quiz_service.dart';
// import '../services/report_service.dart'; // Import the new ReportService
// import 'quiz_result_screen.dart';

// class QuizScreen extends StatefulWidget {
//   final int categoryId;
//   final String categoryName;

//   const QuizScreen({
//     required this.categoryId,
//     required this.categoryName,
//     super.key,
//   });

//   @override
//   State<QuizScreen> createState() => _QuizScreenState();
// }

// class _QuizScreenState extends State<QuizScreen>
//     with SingleTickerProviderStateMixin {
//   late List<QuestionQuiz> _questions;
//   int _questionIndex = 0;
//   String? _selectedAnswer;
//   bool _isAnswered = false;
//   final List<String?> _selections = [];
//   bool _isLoading = true;

//   late AnimationController _timerController;
//   static const int _quizDurationInSeconds = 30;

//   @override
//   void initState() {
//     super.initState();
//     _timerController = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: _quizDurationInSeconds),
//     );
//     _timerController.addStatusListener((status) {
//       if (status == AnimationStatus.completed) {
//         _handleAnswer(null); // Time's up
//       }
//     });
//     _loadQuestions();
//   }

//   @override
//   void dispose() {
//     _timerController.dispose();
//     super.dispose();
//   }

//   Future<void> _loadQuestions() async {
//     final fetchedQuestions = await QuizService.getQuestions(widget.categoryId);
//     if (!mounted) return;

//     setState(() {
//       _questions = fetchedQuestions;
//       _isLoading = false;
//     });

//     if (_questions.isNotEmpty) {
//       _startTimer();
//     }
//   }

//   void _startTimer() {
//     _timerController.reset();
//     _timerController.forward();
//   }

//   void _handleAnswer(String? answer) {
//     if (_isAnswered) return;
//     _timerController.stop();
//     _selections.add(answer);
//     setState(() {
//       _selectedAnswer = answer;
//       _isAnswered = true;
//     });
//     Future.delayed(const Duration(seconds: 2), () {
//       _nextQuestion();
//     });
//   }

//   void _nextQuestion() {
//     if (_questionIndex < _questions.length - 1) {
//       setState(() {
//         _questionIndex++;
//         _selectedAnswer = null;
//         _isAnswered = false;
//       });
//       _startTimer();
//     } else {
//       _completeQuiz();
//     }
//   }

//   void _completeQuiz() async {
//     int totalCorrectAnswers = 0;
//     List<QuestionQuiz> summaryQuestions = [];
//     final int totalQuestions = _questions.length;

//     for (int i = 0; i < totalQuestions; i++) {
//       QuestionQuiz originalQuestion = _questions[i];
//       QuestionQuiz questionSummary = QuestionQuiz(
//         question: originalQuestion.question,
//         options: originalQuestion.options,
//         answer: originalQuestion.answer,
//       );
//       questionSummary.customerAnswer = _selections[i];
//       questionSummary.index = i + 1;

//       String normalizedSelection = (_selections[i] ?? "").replaceAll("u00b0", "°");
//       String normalizedAnswer = (originalQuestion.answer ?? "").replaceAll("u00b0", "°");

//       if (normalizedSelection.isNotEmpty && normalizedSelection == normalizedAnswer) {
//         totalCorrectAnswers++;
//       }
//       summaryQuestions.add(questionSummary);
//     }

//     // Submit the final score and report to the API
//     final int finalScore = totalCorrectAnswers * 10; // Or your own scoring logic
//     await ReportService.submitReport(
//       score: finalScore,
//       totalQuestion: totalQuestions,
//       totalCorrect: totalCorrectAnswers,
//       categoryEn: widget.categoryName,
//     );

//     // Save the result locally for the Test History screen
//     final result = TestResult(
//       category: widget.categoryName,
//       categoryId: widget.categoryId,
//       score: totalCorrectAnswers,
//       totalQuestions: totalQuestions,
//       completedAt: DateTime.now(),
//       questions: summaryQuestions,
//     );
//     await QuizService.saveTestResult(result);

//     if (!mounted) return;

//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//         builder: (context) => QuizResultScreen(
//           totalCorrectAnswers: totalCorrectAnswers,
//           summaryQuestions: summaryQuestions,
//           category: widget.categoryName,
//           categoryId: widget.categoryId,
//         ),
//       ),
//     );
//   }

//   void _exitQuiz() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Exit Quiz'),
//           content: const Text('Are you sure you want to exit? Your progress will not be saved.'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: const Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 Navigator.of(context).pop();
//               },
//               child: const Text('Exit'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_isLoading) {
//       return Scaffold(
//         appBar: AppBar(title: Text(widget.categoryName)),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const CircularProgressIndicator(),
//               const SizedBox(height: 16),
//               Text("Loading Questions...", style: GoogleFonts.poppins()),
//             ],
//           ),
//         ),
//       );
//     }
    
//     if (_questions.isEmpty) {
//         return Scaffold(
//         appBar: AppBar(title: Text(widget.categoryName)),
//         body: Center(
//           child: Text(
//             'No questions found for this category.',
//             style: GoogleFonts.poppins(),
//           ),
//         ),
//       );
//     }

//     final QuestionQuiz currentQuestion = _questions[_questionIndex];

//     return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 247, 250, 255),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildHeader(),
//               const SizedBox(height: 80),
//               Stack(
//                 clipBehavior: Clip.none,
//                 alignment: Alignment.topCenter,
//                 children: [
//                   _buildQuestionCard(currentQuestion),
//                   Positioned(top: -30, child: _buildTimer()),
//                 ],
//               ),
//               const SizedBox(height: 30),
//               Expanded(
//                 child: ListView(
//                   children: currentQuestion.options.map((option) {
//                     final displayOption = option.replaceAll("u00b0", "°");
//                     return _buildAnswerOption(displayOption, currentQuestion.answer!);
//                   }).toList(),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
  
//   Widget _buildHeader() {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Text(
//           "${_questionIndex + 1}/${_questions.length}",
//           style: GoogleFonts.poppins(color: Colors.grey.shade600, fontSize: 16, fontWeight: FontWeight.w600),
//         ),
//         const SizedBox(width: 8),
//         Expanded(
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(10),
//             child: LinearProgressIndicator(
//               value: (_questionIndex + 1) / _questions.length,
//               minHeight: 10,
//               backgroundColor: Colors.grey.shade200,
//               valueColor: const AlwaysStoppedAnimation<Color>(Color.fromRGBO(106, 90, 224, 1)),
//             ),
//           ),
//         ),
//         const SizedBox(width: 24),
//         Container(
//           height: 40,
//           width: 40,
//           decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.grey.shade300, width: 2)),
//           child: IconButton(
//             padding: EdgeInsets.zero,
//             icon: const Icon(Icons.close, color: Colors.black54, size: 20),
//             onPressed: _exitQuiz,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildQuestionCard(QuestionQuiz question) {
//     return Container(
//       width: double.infinity,
//       height: 180,
//       alignment: Alignment.center,
//       padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
//       decoration: BoxDecoration(color: const Color(0xFFE6E1FF), borderRadius: BorderRadius.circular(25.0)),
//       child: Text(
//         question.question ?? "",
//         textAlign: TextAlign.center,
//         style: GoogleFonts.poppins(color: const Color(0xFF0D1845), fontSize: 20, fontWeight: FontWeight.w600),
//       ),
//     );
//   }

//   Widget _buildTimer() {
//     return AnimatedBuilder(
//       animation: _timerController,
//       builder: (context, child) {
//         int remainingSeconds = (_quizDurationInSeconds * (1 - _timerController.value)).round();
//         return Stack(
//           alignment: Alignment.center,
//           children: [
//             Container(width: 60, height: 60, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
//             SizedBox(
//               width: 60,
//               height: 60,
//               child: CircularProgressIndicator(
//                 value: _timerController.value,
//                 strokeWidth: 6,
//                 backgroundColor: Colors.grey.shade300,
//                 valueColor: const AlwaysStoppedAnimation<Color>(Color.fromRGBO(106, 90, 224, 1)),
//               ),
//             ),
//             Text(
//               '$remainingSeconds',
//               style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: const Color(0xFF0D1845)),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Widget _buildAnswerOption(String option, String correctAnswer) {
//     bool isSelected = _selectedAnswer == option;
//     Color borderColor = Colors.grey.shade300;
//     Color backgroundColor = Colors.white;
//     Color textColor = Colors.black54;
//     Widget? trailingIcon;

//     if (_isAnswered) {
//       // Normalize the correct answer for display comparison
//       final normalizedCorrectAnswer = correctAnswer.replaceAll("u00b0", "°");
//       if (option == normalizedCorrectAnswer) {
//         backgroundColor = const Color(0xFFE6E1FF);
//         borderColor = const Color.fromRGBO(106, 90, 224, 1);
//         textColor = const Color.fromRGBO(106, 90, 224, 1);
//         trailingIcon = const Icon(Icons.check_circle, color: Color.fromRGBO(106, 90, 224, 1));
//       } else if (isSelected) {
//         backgroundColor = const Color(0xFFFFEBEB);
//         borderColor = Colors.red;
//         textColor = Colors.red;
//         trailingIcon = const Icon(Icons.cancel, color: Colors.red);
//       }
//     } else if (isSelected) {
//       borderColor = const Color.fromRGBO(106, 90, 224, 1);
//     }

//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: InkWell(
//         onTap: _isAnswered ? null : () => _handleAnswer(option),
//         borderRadius: BorderRadius.circular(15.0),
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//           decoration: BoxDecoration(
//             color: backgroundColor,
//             border: Border.all(color: borderColor, width: 2),
//             borderRadius: BorderRadius.circular(15.0),
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Expanded(
//                 child: Text(
//                   option,
//                   style: GoogleFonts.poppins(color: textColor, fontSize: 16, fontWeight: FontWeight.w500),
//                 ),
//               ),
//               if (trailingIcon != null) trailingIcon,
//               if (trailingIcon == null)
//                 Container(
//                   width: 24,
//                   height: 24,
//                   decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.grey.shade400)),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }