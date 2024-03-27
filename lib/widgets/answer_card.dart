import 'package:flutter/material.dart';

class AnswerCard extends StatelessWidget {
  const AnswerCard({
    super.key,
    required this.options,
    required this.isSelected,
    required this.correctAnswerIndex,
    required this.selectedAnswerIndex,
    required this.currentIndex,
  });

  final String options;
  final bool isSelected;
  final int? correctAnswerIndex;
  final int? selectedAnswerIndex;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    bool isCorrectedAnswer = currentIndex == correctAnswerIndex;
    bool isWrongAnswer = !isCorrectedAnswer && isSelected;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: selectedAnswerIndex != null
          ? Container(
              height: 70,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color.fromARGB(66, 179, 178, 178),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: isCorrectedAnswer
                        ? const Color.fromARGB(255, 2, 136, 6)
                        : isWrongAnswer
                            ? Colors.red
                            : Colors.black),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(options),
                  ),
                  const SizedBox(height: 10),
                  isCorrectedAnswer
                      ? buildCorrectIcon()
                      : isWrongAnswer
                          ? buildWrongIcon()
                          : const SizedBox.shrink(),
                ],
              ),
            )
          : Container(
              height: 70,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: const Color.fromARGB(66, 179, 178, 178),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black)),
              child: Row(
                children: [
                  Expanded(
                    child: Text(options),
                  ),
                ],
              ),
            ),
    );
  }
}

buildCorrectIcon() {
  return const CircleAvatar(
    backgroundColor: Colors.green,
    radius: 15,
    child: Icon(
      Icons.check,
      color: Colors.white,
    ),
  );
}

buildWrongIcon() {
  return const CircleAvatar(
    backgroundColor: Colors.red,
    radius: 15,
    child: Icon(
      Icons.close,
      color: Colors.white,
    ),
  );
}
