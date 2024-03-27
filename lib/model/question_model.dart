class QuestionModel {
  final String question;
  final List<String> options;
  final int correctanswerIndex;

  QuestionModel(
      {required this.question,
      required this.options,
      required this.correctanswerIndex});
}
