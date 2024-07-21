import 'package:flutter/material.dart';
import 'package:quiz_app_1/screens/message_screen.dart';
import 'package:quiz_app_1/screens/quiz_screen.dart';
import 'package:quiz_app_1/screens/result_screen.dart';
import 'package:quiz_app_1/screens/users_screen.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  var myCurrentIndex = 0;
  final pages = const [
    QuizScreen(),
    MessageScreen(),
    ResultScreen(score: 0),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: myCurrentIndex,
          onTap: (int index) {
            setState(() {
              myCurrentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Quiz"),
            BottomNavigationBarItem(icon: Icon(Icons.message), label: "Chat"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          ]),
      body: pages[myCurrentIndex],
    );
    ;
  }
}
