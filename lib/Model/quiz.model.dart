class QuizModel {
  final String id;
  final String title;
  final String description;
  final String author;
  final String createdAt;

  QuizModel({
    required this.id,
    required this.title,
    required this.description,
    required this.author,
    required this.createdAt,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      author: json['author'] ?? 'ไม่ระบุ',
      createdAt: json['created_at'],
    );
  }
}

class QuestionModel {
  final String id;
  final String questionText;
  final List<String> options;
  final String correctAnswer;
  final String explanation;

  QuestionModel({
    required this.id,
    required this.questionText,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'] ?? '',
      questionText: json['question_text'],
      options: List<String>.from(json['options']),
      correctAnswer: json['correct_answer'],
      explanation: json['explanation'] ?? '',
    );
  }
}

class QuizAttemptModel {
  final String attemptId;
  final String quizId;
  final String quizTitle;
  final int score;
  final int totalQuestions;
  final String completedAt;

  QuizAttemptModel({
    required this.attemptId,
    required this.quizId,
    required this.quizTitle,
    required this.score,
    required this.totalQuestions,
    required this.completedAt,
  });

  factory QuizAttemptModel.fromJson(Map<String, dynamic> json) {
    return QuizAttemptModel(
      attemptId: json['attempt_id'],
      quizId: json['quiz_id'],
      quizTitle: json['quiz_title'],
      score: json['score'],
      totalQuestions: json['total_questions'],
      completedAt: json['completed_at'],
    );
  }
}
