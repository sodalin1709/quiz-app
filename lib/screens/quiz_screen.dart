import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/questions.dart'; // Import for the global questions list
import '../models/question_quiz.dart';
import '../models/test_result.dart';
import '../services/quiz_service.dart';
import '../services/auth_service.dart';
import 'quiz_result_screen.dart';

class QuizScreen extends StatefulWidget {
  final String category;

  const QuizScreen({required this.category, super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen>
    with SingleTickerProviderStateMixin {
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
    _timerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: _quizDurationInSeconds),
    );
    _timerController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _handleAnswer(null); // Time's up
      }
    });
    _loadQuestions();
  }

  @override
  void dispose() {
    _timerController.dispose();
    super.dispose();
  }

  void _loadQuestions() {
    _questions = listQuestions;
    setState(() {
      _isLoading = false;
    });
    if (_questions.isNotEmpty) {
      _startTimer();
    }
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

    Future.delayed(const Duration(seconds: 2), () {
      _nextQuestion();
    });
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

    for (int i = 0; i < _questions.length; i++) {
      QuestionQuiz originalQuestion = _questions[i];
      QuestionQuiz questionQuiz = QuestionQuiz(
        question: originalQuestion.question,
        options: originalQuestion.options,
        answer: originalQuestion.answer,
      );
      questionQuiz.customerAnswer = _selections[i];
      questionQuiz.index = i + 1;
      if (_selections[i] == originalQuestion.answer) {
        totalCorrectAnswers++;
      }
      summaryQuestions.add(questionQuiz);
    }

    TestResult result = TestResult(
      category: widget.category,
      score: totalCorrectAnswers,
      totalQuestions: _questions.length,
      completedAt: DateTime.now(),
      questions: summaryQuestions,
    );

    await QuizService.saveTestResult(result);

    if (AuthService.currentUser != null) {
      AuthService.currentUser!.totalTestsTaken++;
      AuthService.currentUser!.totalScore += totalCorrectAnswers * 10;
    }

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => QuizResultScreen(
          totalCorrectAnswers: totalCorrectAnswers,
          summaryQuestions: summaryQuestions,
          category: widget.category,
        ),
      ),
    );
  }

  void _exitQuiz() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Exit Quiz'),
          content: const Text('Are you sure you want to exit? Your progress will not be saved.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('Exit'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

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
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.topCenter,
                children: [
                  _buildQuestionCard(currentQuestion),
                  Positioned(top: -30, child: _buildTimer()),
                ],
              ),
              const SizedBox(height: 30),
              Expanded(
                child: ListView(
                  children: currentQuestion.options.map((option) {
                    return _buildAnswerOption(option, currentQuestion.answer!);
                  }).toList(),
                ),
              ),
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
          style: GoogleFonts.poppins(
            color: Colors.grey.shade600,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
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
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade300, width: 2),
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.close, color: Colors.black54, size: 20),
            onPressed: _exitQuiz,
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionCard(QuestionQuiz question) {
    return Container(
      width: double.infinity,
      height: 180,
      alignment: Alignment.center,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      decoration: BoxDecoration(
        color: const Color(0xFFE6E1FF),
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: Text(
        question.question ?? "",
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(
          color: const Color(0xFF0D1845),
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTimer() {
    return AnimatedBuilder(
      animation: _timerController,
      builder: (context, child) {
        int remainingSeconds =
            (_quizDurationInSeconds * (1 - _timerController.value)).round();
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
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
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0D1845),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAnswerOption(String option, String correctAnswer) {
    bool isSelected = _selectedAnswer == option;
    Color borderColor = Colors.grey.shade300;
    Color backgroundColor = Colors.white;
    Color textColor = Colors.black54;
    Widget? trailingIcon;

    if (_isAnswered) {
      if (option == correctAnswer) {
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
    } else if (isSelected) {
      borderColor = const Color.fromRGBO(106, 90, 224, 1);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: _isAnswered ? null : () => _handleAnswer(option),
        borderRadius: BorderRadius.circular(15.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(color: borderColor, width: 2),
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  option,
                  style: GoogleFonts.poppins(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (trailingIcon != null) trailingIcon,
              if (trailingIcon == null)
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

























// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../constants/questions.dart'; // Import for the global questions list
// import '../models/question_quiz.dart';
// import '../models/test_result.dart';
// import '../services/quiz_service.dart';
// import '../services/auth_service.dart';
// import 'quiz_result_screen.dart';

// class QuizScreen extends StatefulWidget {
//   final String category;

//   const QuizScreen({required this.category, super.key});

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

//   // Timer properties
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

//   void _loadQuestions() {
//     _questions = listQuestions;
//     setState(() {
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
//     if (_isAnswered) return; // Prevent multiple answers
//     _timerController.stop();
//     setState(() {
//       _selectedAnswer = answer;
//       _isAnswered = true;
//     });

//     Future.delayed(const Duration(seconds: 2), () {
//       _nextQuestion();
//     });
//   }

//   void _nextQuestion() {
//     _selections.add(_selectedAnswer);

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

//     for (int i = 0; i < _questions.length; i++) {
//       QuestionQuiz originalQuestion = _questions[i];
//       QuestionQuiz questionQuiz = QuestionQuiz(
//         question: originalQuestion.question,
//         options: originalQuestion.options,
//         answer: originalQuestion.answer,
//       );
//       questionQuiz.customerAnswer = _selections[i];
//       questionQuiz.index = i + 1;
//       if (_selections[i] == originalQuestion.answer) {
//         totalCorrectAnswers++;
//       }
//       summaryQuestions.add(questionQuiz);
//     }

//     TestResult result = TestResult(
//       category: widget.category,
//       score: totalCorrectAnswers,
//       totalQuestions: _questions.length,
//       completedAt: DateTime.now(),
//       questions: summaryQuestions,
//     );

//     await QuizService.saveTestResult(result);

//     if (AuthService.currentUser != null) {
//       AuthService.currentUser!.totalTestsTaken++;
//       AuthService.currentUser!.totalScore += totalCorrectAnswers * 10;
//     }

//     if (!mounted) return;

//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//         builder: (context) => QuizResultScreen(
//           totalCorrectAnswers: totalCorrectAnswers,
//           summaryQuestions: summaryQuestions,
//           category: widget.category,
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
//                 Navigator.of(context).pop(); // Close the dialog
//                 Navigator.of(context).pop(); // Exit the quiz screen
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
//       return const Scaffold(body: Center(child: CircularProgressIndicator()));
//     }

//     final QuestionQuiz currentQuestion = _questions[_questionIndex];

//     return Scaffold(
//       backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
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
//                     return _buildAnswerOption(option, currentQuestion.answer!);
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
//           style: GoogleFonts.poppins(
//             color: Colors.grey.shade600,
//             fontSize: 16,
//             fontWeight: FontWeight.w600,
//           ),
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
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             border: Border.all(color: Colors.grey.shade300, width: 2),
//           ),
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
//       decoration: BoxDecoration(
//         color: const Color(0xFFE6E1FF),
//         borderRadius: BorderRadius.circular(25.0),
//       ),
//       child: Text(
//         question.question ?? "",
//         textAlign: TextAlign.center,
//         style: GoogleFonts.poppins(
//           color: const Color(0xFF0D1845),
//           fontSize: 20,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//     );
//   }

//   Widget _buildTimer() {
//     return AnimatedBuilder(
//       animation: _timerController,
//       builder: (context, child) {
//         int remainingSeconds =
//             (_quizDurationInSeconds * (1 - _timerController.value)).round();
//         return Stack(
//           alignment: Alignment.center,
//           children: [
//             // White background for the timer
//             Container(
//               width: 60,
//               height: 60,
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 shape: BoxShape.circle,
//               ),
//             ),
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
//               style: GoogleFonts.poppins(
//                 fontSize: 22,
//                 fontWeight: FontWeight.bold,
//                 color: const Color(0xFF0D1845),
//               ),
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
//       if (option == correctAnswer) {
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
//                   style: GoogleFonts.poppins(
//                     color: textColor,
//                     fontSize: 16,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//               if (trailingIcon != null) trailingIcon,
//               if (trailingIcon == null)
//                 Container(
//                   width: 24,
//                   height: 24,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     border: Border.all(color: Colors.grey.shade400),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }














// import 'package:flutter/material.dart';
// import '../constants/questions.dart';
// import '../models/question_quiz.dart';
// import '../models/test_result.dart';
// import '../services/quiz_service.dart';
// import '../services/auth_service.dart';
// import '../widgets/answer_btn.dart';
// import 'quiz_result_screen.dart';

// class QuizScreen extends StatefulWidget {
//   final String category;

//   const QuizScreen({required this.category, super.key});

//   @override
//   State<QuizScreen> createState() => _QuizScreenState();
// }

// class _QuizScreenState extends State<QuizScreen> {
//   int questionIndex = 0;
//   List<String?> selections = [];
//   String? selectedAnswer;

//   void selectAnswer(String answer) {
//     setState(() {
//       selectedAnswer = answer;
//     });
//   }

//   void nextQuestion() {
//     if (selectedAnswer == null) return;

//     setState(() {
//       selections.add(selectedAnswer);
//       if (questionIndex < listQuestions.length - 1) {
//         questionIndex++;
//         selectedAnswer = null;
//       } else {
//         // If it's the last question, go directly to complete
//         _completeQuiz();
//       }
//     });
//   }

//   void previousQuestion() {
//     if (questionIndex > 0) {
//       setState(() {
//         questionIndex--;
//         // Restore the previous selection for a better user experience
//         selectedAnswer = selections.removeLast();
//       });
//     }
//   }

//   // MODIFIED: This method is now async to handle saving the test result
//   void _completeQuiz() async {
//     int totalCorrectAnswers = 0;
//     List<QuestionQuiz> summaryQuestions = [];

//     // The final answer for the last question needs to be added before calculating
//     if(selections.length < listQuestions.length) {
//         selections.add(selectedAnswer);
//     }

//     for (int i = 0; i < listQuestions.length; i++) {
//       QuestionQuiz originalQuestion = listQuestions[i];
//       QuestionQuiz questionQuiz = QuestionQuiz(
//         question: originalQuestion.question,
//         options: originalQuestion.options,
//         answer: originalQuestion.answer,
//       );
//       questionQuiz.customerAnswer = selections[i];
//       questionQuiz.index = i + 1;
//       if (selections[i] == originalQuestion.answer) {
//         totalCorrectAnswers++;
//       }
//       summaryQuestions.add(questionQuiz);
//     }

//     // Create the test result object
//     TestResult result = TestResult(
//       category: widget.category,
//       score: totalCorrectAnswers,
//       totalQuestions: listQuestions.length,
//       completedAt: DateTime.now(),
//       questions: summaryQuestions,
//     );
    
//     // AWAIT the save operation to ensure history is persisted
//     await QuizService.saveTestResult(result);

//     // Update user stats in memory
//     if (AuthService.currentUser != null) {
//       AuthService.currentUser!.totalTestsTaken++;
//       AuthService.currentUser!.totalScore += totalCorrectAnswers * 10;
//       // In a real app, you'd save the updated user profile here too
//     }
    
//     if (!mounted) return; // Good practice check

//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//         builder: (context) => QuizResultScreen(
//           totalCorrectAnswers: totalCorrectAnswers,
//           summaryQuestions: summaryQuestions,
//           category: widget.category,
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
//                 Navigator.of(context).pop(); // Close the dialog
//                 Navigator.of(context).pop(); // Exit the quiz screen
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
//     if (questionIndex >= listQuestions.length) {
//       // This case should not be hit with the new logic, but it's a safe fallback.
//       return const Scaffold(body: Center(child: CircularProgressIndicator()));
//     }

//     QuestionQuiz currentQuestion = listQuestions[questionIndex];

//     return Scaffold(
//       backgroundColor: const Color.fromRGBO(65, 65, 160, 1.0),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               // Header
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     "Question ${questionIndex + 1}/${listQuestions.length}",
//                     style: const TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                   IconButton(
//                     onPressed: _exitQuiz,
//                     icon: const Icon(Icons.close, color: Colors.white),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),
//               // Progress bar
//               LinearProgressIndicator(
//                 value: (questionIndex + 1) / listQuestions.length,
//                 backgroundColor: Colors.white30,
//                 valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
//               ),
//               const SizedBox(height: 30),
//               // Question container
//               Expanded(
//                 child: Container(
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(16.0),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(20.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           currentQuestion.question ?? "",
//                           style: const TextStyle(
//                             color: Colors.black,
//                             fontSize: 20,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                         const SizedBox(height: 30),
//                         Expanded(
//                           child: ListView.builder(
//                             itemCount: currentQuestion.options.length,
//                             itemBuilder: (context, index) {
//                               String option = currentQuestion.options[index];
//                               return AnswerBtn(
//                                 option,
//                                 () => selectAnswer(option),
//                                 isSelected: selectedAnswer == option,
//                               );
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               // Navigation buttons
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   ElevatedButton(
//                     onPressed: questionIndex > 0 ? previousQuestion : null,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.grey,
//                       padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
//                     ),
//                     child: const Text(
//                       'Back',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//                   ElevatedButton(
//                     onPressed: selectedAnswer != null ? nextQuestion : null,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: selectedAnswer != null ? Colors.green : Colors.grey,
//                       padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
//                     ),
//                     child: Text(
//                       questionIndex == listQuestions.length - 1 ? 'Finish' : 'Next',
//                       style: const TextStyle(color: Colors.white),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }