import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app_1/model/question_model.dart';
import 'package:quiz_app_1/questions/question_base_one.dart';
import 'package:quiz_app_1/screens/result_screen.dart';
import 'package:quiz_app_1/screens/sign_up_screen.dart';
import 'package:quiz_app_1/widgets/answer_card.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

FirebaseAuth _auth = FirebaseAuth.instance;
int? selectedAnswerIndex;
int questionIndex = 0;

int score = 0;

class _QuizScreenState extends State<QuizScreen> {
  void pickAnswer(int value) {
    selectedAnswerIndex = value;

    final question = questionBaseOne[questionIndex];
    if (selectedAnswerIndex == question.correctanswerIndex) {
      score++;
    }
    setState(() {});
  }

  void goToNextQuestion() {
    if (questionIndex < questionBaseOne.length - 1) {
      questionIndex++;
      selectedAnswerIndex = null;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    QuestionModel question = questionBaseOne[questionIndex];
    bool lastQuestion = questionIndex == questionBaseOne.length - 1;

    return Scaffold(
      backgroundColor: const Color.fromARGB(214, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        title: const Text('Questions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              // Diğer işlemler için kodlar
              _auth.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const SignUpScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              question.question,
              style: const TextStyle(fontSize: 21),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: question.options.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: selectedAnswerIndex == null
                      ? () => pickAnswer(index)
                      : null,
                  child: AnswerCard(
                    options: question.options[index],
                    isSelected: selectedAnswerIndex == index,
                    correctAnswerIndex: question.correctanswerIndex,
                    selectedAnswerIndex: selectedAnswerIndex,
                    currentIndex: index,
                  ),
                );
              },
            ),
            // Next Button

            lastQuestion
                ? ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ResultScreen(score: score),
                        ),
                      );
                    },
                    child: const Text("Finish"),
                  )
                : ElevatedButton(
                    onPressed: () {
                      goToNextQuestion();
                    },
                    child: const Text("Next"))
          ],
        ),
      ),
    );
  }
}
