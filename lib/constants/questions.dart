import '../models/question_quiz.dart';
List<Map<String, dynamic>> rawQuestions = [
  {
    "question": "Which ocean is the deepest in the world? Q1",
    "options": ["Atlantic", "Indian", "Pacific", "Arctic"],
    "answer": "Pacific",
  },
  {
    "question": "Who painted the Mona Lisa? Q2",
    "options": [
      "Vincent van Gogh",
      "Pablo Picasso",
      "Leonardo da Vinci",
      "Michelangelo",
    ],
    "answer": "Leonardo da Vinci",
  },
  {
    "question": "Who discovered gravity after seeing an apple fall? Q3",
    "options": [
      "Albert Einstein",
      "Isaac Newton",
      "Galileo Galilei",
      "Nikola Tesla",
    ],
    "answer": "Isaac Newton",
  },
  {
    "question": "Who discovered gravity after seeing an apple fall? Q4",
    "options": [
      "Albert Einstein",
      "Isaac Newton",
      "Galileo Galilei",
      "Nikola Tesla",
    ],
    "answer": "Isaac Newton",
  },
  {
    "question": "Who wrote Romeo and Juliet? Q5",
    "options": [
      "William Shakespeare",
      "Charles Dickens",
      "Mark Twain",
      "Jane Austen",
    ],
    "answer": "William Shakespeare",
  },
  {
    "question": "In which year did the Titanic sink? Q6",
    "options": ["1905", "1912", "1920", "1898"],
    "answer": "1912",
  },
  {
    "question": "What is the hardest natural substance on Earth? Q7",
    "options": ["Diamond", "Gold", "Iron", "Quartz"],
    "answer": "Diamond",
  },
  {
    "question": "Who wrote Romeo and Juliet? Q8",
    "options": [
      "William Shakespeare",
      "Charles Dickens",
      "Mark Twain",
      "Jane Austen",
    ],
    "answer": "William Shakespeare",
  },
  {
    "question": "Which language has the most native speakers in the world? Q9",
    "options": ["English", "Mandarin Chinese", "Spanish", "Hindi"],
    "answer": "Mandarin Chinese",
  },
  {
    "question": "What is the largest planet in our solar system? Q10",
    "options": ["Earth", "Jupiter", "Saturn", "Mars"],
    "answer": "Jupiter",
  },
  {
    "question": "Who painted the Mona Lisa? Q11",
    "options": [
      "Vincent van Gogh",
      "Pablo Picasso",
      "Leonardo da Vinci",
      "Michelangelo",
    ],
    "answer": "Leonardo da Vinci",
  },
];

List<QuestionQuiz> listQuestions = rawQuestions.map((q) {
  return QuestionQuiz.fromJson(q);
}).toList();



// import 'package:camtech_assessment_test/models/question_quiz.dart';

// List<Map<String, dynamic>> rawQuestions = [
//   {
//     "question": "Which ocean is the deepest in the world? (Q1)",
//     "options": ["Atlantic", "Indian", "Pacific", "Arctic"],
//     "answer": "Pacific",
//   },
//   {
//     "question": "Who painted the Mona Lisa? (Q2)",
//     "options": [
//       "Vincent van Gogh",
//       "Pablo Picasso",
//       "Leonardo da Vinci",
//       "Michelangelo",
//     ],
//     "answer": "Leonardo da Vinci",
//   },
//   {
//     "question": "Who discovered gravity after seeing an apple fall? (Q3)",
//     "options": [
//       "Albert Einstein",
//       "Isaac Newton",
//       "Galileo Galilei",
//       "Nikola Tesla",
//     ],
//     "answer": "Isaac Newton",
//   },
//   {
//     "question": "Who discovered gravity after seeing an apple fall? (Q4)",
//     "options": [
//       "Albert Einstein",
//       "Isaac Newton",
//       "Galileo Galilei",
//       "Nikola Tesla",
//     ],
//     "answer": "Isaac Newton",
//   },
//   {
//     "question": "Who wrote Romeo and Juliet? (Q5)",
//     "options": [
//       "William Shakespeare",
//       "Charles Dickens",
//       "Mark Twain",
//       "Jane Austen",
//     ],
//     "answer": "William Shakespeare",
//   },
//   {
//     "question": "In which year did the Titanic sink? (Q6)",
//     "options": ["1905", "1912", "1920", "1898"],
//     "answer": "1912",
//   },
//   {
//     "question": "What is the hardest natural substance on Earth? (Q7)",
//     "options": ["Diamond", "Gold", "Iron", "Quartz"],
//     "answer": "Diamond",
//   },
//   {
//     "question": "Who wrote Romeo and Juliet? (Q8)",
//     "options": [
//       "William Shakespeare",
//       "Charles Dickens",
//       "Mark Twain",
//       "Jane Austen",
//     ],
//     "answer": "William Shakespeare",
//   },
//   {
//     "question":
//         "Which language has the most native speakers in the world? (Q9)",
//     "options": ["English", "Mandarin Chinese", "Spanish", "Hindi"],
//     "answer": "Mandarin Chinese",
//   },
//   {
//     "question": "What is the largest planet in our solar system? (Q10)",
//     "options": ["Earth", "Jupiter", "Saturn", "Mars"],
//     "answer": "Jupiter",
//   },
//   {
//     "question": "Who painted the Mona Lisa? (Q11)",
//     "options": [
//       "Vincent van Gogh",
//       "Pablo Picasso",
//       "Leonardo da Vinci",
//       "Michelangelo",
//     ],
//     "answer": "Leonardo da Vinci",
//   },
//   {
//     "question": "Which ocean is the deepest in the world? (Q12)",
//     "options": ["Atlantic", "Indian", "Pacific", "Arctic"],
//     "answer": "Pacific",
//   },
//   {
//     "question": "What is the smallest country in the world? (Q13)",
//     "options": ["Vatican City", "Monaco", "Nauru", "San Marino"],
//     "answer": "Vatican City",
//   },
//   {
//     "question": "Who discovered gravity after seeing an apple fall? (Q14)",
//     "options": [
//       "Albert Einstein",
//       "Isaac Newton",
//       "Galileo Galilei",
//       "Nikola Tesla",
//     ],
//     "answer": "Isaac Newton",
//   },
//   {
//     "question": "What is the capital of Australia? (Q15)",
//     "options": ["Sydney", "Melbourne", "Brisbane", "Canberra"],
//     "answer": "Canberra",
//   },
//   {
//     "question": "Which gas do plants absorb from the atmosphere? (Q16)",
//     "options": ["Oxygen", "Nitrogen", "Carbon dioxide", "Helium"],
//     "answer": "Carbon dioxide",
//   },
//   {
//     "question": "What currency is used in Japan? (Q17)",
//     "options": ["Won", "Dollar", "Yen", "Yuan"],
//     "answer": "Yen",
//   },
//   {
//     "question": "Which country is known as the Land of the Rising Sun? (Q18)",
//     "options": ["China", "Japan", "South Korea", "Thailand"],
//     "answer": "Japan",
//   },
//   {
//     "question": "What is the largest planet in our solar system? (Q19)",
//     "options": ["Earth", "Jupiter", "Saturn", "Mars"],
//     "answer": "Jupiter",
//   },
//   {
//     "question": "What is the largest planet in our solar system? (Q20)",
//     "options": ["Earth", "Jupiter", "Saturn", "Mars"],
//     "answer": "Jupiter",
//   },
//   {
//     "question": "How many bones are in the adult human body? (Q21)",
//     "options": ["198", "206", "211", "224"],
//     "answer": "206",
//   },
//   {
//     "question": "Who painted the Mona Lisa? (Q22)",
//     "options": [
//       "Vincent van Gogh",
//       "Pablo Picasso",
//       "Leonardo da Vinci",
//       "Michelangelo",
//     ],
//     "answer": "Leonardo da Vinci",
//   },
//   {
//     "question": "What is the hardest natural substance on Earth? (Q23)",
//     "options": ["Diamond", "Gold", "Iron", "Quartz"],
//     "answer": "Diamond",
//   },
//   {
//     "question": "How many bones are in the adult human body? (Q24)",
//     "options": ["198", "206", "211", "224"],
//     "answer": "206",
//   },
//   {
//     "question": "In which year did the Titanic sink? (Q25)",
//     "options": ["1905", "1912", "1920", "1898"],
//     "answer": "1912",
//   },
//   {
//     "question": "Who painted the Mona Lisa? (Q26)",
//     "options": [
//       "Vincent van Gogh",
//       "Pablo Picasso",
//       "Leonardo da Vinci",
//       "Michelangelo",
//     ],
//     "answer": "Leonardo da Vinci",
//   },
//   {
//     "question": "What is the largest planet in our solar system? (Q27)",
//     "options": ["Earth", "Jupiter", "Saturn", "Mars"],
//     "answer": "Jupiter",
//   },
//   {
//     "question": "What is the capital of Australia? (Q28)",
//     "options": ["Sydney", "Melbourne", "Brisbane", "Canberra"],
//     "answer": "Canberra",
//   },
//   {
//     "question": "Which ocean is the deepest in the world? (Q29)",
//     "options": ["Atlantic", "Indian", "Pacific", "Arctic"],
//     "answer": "Pacific",
//   },
//   {
//     "question": "Which country is known as the Land of the Rising Sun? (Q30)",
//     "options": ["China", "Japan", "South Korea", "Thailand"],
//     "answer": "Japan",
//   },
//   {
//     "question": "What is the largest planet in our solar system? (Q31)",
//     "options": ["Earth", "Jupiter", "Saturn", "Mars"],
//     "answer": "Jupiter",
//   },
//   {
//     "question": "What is the capital of Australia? (Q32)",
//     "options": ["Sydney", "Melbourne", "Brisbane", "Canberra"],
//     "answer": "Canberra",
//   },
//   {
//     "question": "Who wrote Romeo and Juliet? (Q33)",
//     "options": [
//       "William Shakespeare",
//       "Charles Dickens",
//       "Mark Twain",
//       "Jane Austen",
//     ],
//     "answer": "William Shakespeare",
//   },
// ];

// List<QuestionQuiz> listQuestions =
//     rawQuestions.map((q) {
//       return QuestionQuiz.fromJson(q);
//     }).toList();
