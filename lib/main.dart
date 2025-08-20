// main.dart
import 'package:flutter/material.dart';
import 'screens/auth/login_screen.dart';
import 'screens/main_screen.dart';
import 'services/auth_service.dart';
import 'services/quiz_service.dart'; 
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load user session first
  await AuthService.tryAutoLogin();
  
  // 2. Load test history right after
  await QuizService.loadHistory();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: AuthService.currentUser != null
          ? const MainScreen()
          : const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}