// models/user.dart
import 'dart:convert';

class User {
  String name;
  String email;
  int age;
  String school;
  String gender;
  int totalTestsTaken;
  int totalScore;
  int leagueRanking;
  String? profilePicture;

  User({
    required this.name,
    required this.email,
    required this.age,
    required this.school,
    required this.gender,
    this.totalTestsTaken = 0,
    this.totalScore = 0,
    this.leagueRanking = 0,
    this.profilePicture,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'age': age,
      'school': school,
      'gender': gender,
      'totalTestsTaken': totalTestsTaken,
      'totalScore': totalScore,
      'leagueRanking': leagueRanking,
      'profilePicture': profilePicture,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      email: json['email'],
      age: json['age'] ?? 18, // Provide default age
      school: json['school'],
      gender: json['gender'],
      totalTestsTaken: json['totalTestsTaken'] ?? 0,
      totalScore: json['totalScore'] ?? 0,
      leagueRanking: json['leagueRanking'] ?? 0,
      profilePicture: json['profilePicture'],
    );
  }
}