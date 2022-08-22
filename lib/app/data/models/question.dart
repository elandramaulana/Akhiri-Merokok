class Quest1 {
  final String question1;
  final String answer1;

  Quest1({required this.question1, required this.answer1});

  factory Quest1.fromMap(Map data) {
    return Quest1(question1: data['question1'], answer1: data['']);
  }

  Map<String, dynamic> toJson() => {
        "question1": question1,
        "answer1": answer1,
      };
}
