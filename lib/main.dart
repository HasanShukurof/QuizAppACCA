import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app_1/firebase_options.dart';
import 'package:quiz_app_1/screens/quiz_screen.dart';
import 'package:quiz_app_1/screens/sign_up_screen.dart';
import 'package:quiz_app_1/widgets/bottom_nav_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const QuizApp());
}

class QuizApp extends StatefulWidget {
  const QuizApp({super.key});

  @override
  State<QuizApp> createState() => _QuizAppState();
}

FirebaseAuth _auth = FirebaseAuth.instance;

class _QuizAppState extends State<QuizApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _auth.currentUser != null ? const MyWidget() : const SignUpScreen(),
    );
  }
}
