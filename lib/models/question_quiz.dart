// models/question_quiz.dart
class QuestionQuiz {
  int? index;
  String? question;
  List<String> options = [];
  String? answer;
  String? customerAnswer;

  QuestionQuiz({this.question, required this.options, this.answer});

  // MODIFIED: Added index and customerAnswer
  QuestionQuiz.fromJson(Map<String, dynamic> json) {
    index = json['index'];
    question = json['question'];
    options = json['options'].cast<String>();
    answer = json['answer'];
    customerAnswer = json['customerAnswer'];
  }

  // MODIFIED: Added index and customerAnswer
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['index'] = index;
    data['question'] = question;
    data['options'] = options;
    data['answer'] = answer;
    data['customerAnswer'] = customerAnswer;
    return data;
  }
}













// // models/question_quiz.dart
// class QuestionQuiz {
//   int? index;
//   String? question;
//   List<String> options = [];
//   String? answer;
//   String? customerAnswer;

//   QuestionQuiz({this.question, required this.options, this.answer});

//   QuestionQuiz.fromJson(Map<String, dynamic> json) {
//     question = json['question'];
//     options = json['options'].cast<String>();
//     answer = json['answer'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = Map<String, dynamic>();
//     data['question'] = this.question;
//     data['options'] = this.options;
//     data['answer'] = this.answer;
//     return data;
//   }
// }




// import 'dart:convert';

// import 'package:flutter/services.dart';

// class QuestionQuiz {
//   int? index;
//   String? question;
//   List<String> options = [];
//   String? answer;
//   String? customerAnwser;

//   QuestionQuiz({this.question, required this.options, this.answer});

//   QuestionQuiz.fromJson(Map<String, dynamic> json) {
//     question = json['question'];
//     options = json['options'].cast<String>();
//     answer = json['answer'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = Map<String, dynamic>();
//     data['question'] = this.question;
//     data['options'] = this.options;
//     data['answer'] = this.answer;
//     return data;
//   }

//   static Future<List<QuestionQuiz>> loadData() async {
//     String strQuestions = await rootBundle.loadString(
//       'assets/data/questions.json',
//     );
    
//     List<dynamic> questions = jsonDecode(strQuestions);

//     List<QuestionQuiz> respQuestions =
//         questions.map((q) => QuestionQuiz.fromJson(q)).toList();

//     return respQuestions;
//   }
// }
