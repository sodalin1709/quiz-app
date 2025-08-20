import 'package:flutter/material.dart';

class QuizCategory {
  final String name;
  final IconData icon; // We can keep this for fallback or other uses
  final String image; // To hold the asset path for the image
  final int questionCount;

  const QuizCategory({
    required this.name,
    required this.icon,
    required this.image,
    required this.questionCount,
  });
}