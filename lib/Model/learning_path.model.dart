import 'package:flutter/material.dart';

class LearningPathModel {
  final String id;
  final String title;
  final String description;
  final List<LessonModel> lessons;
  double progress;
  bool isEnrolled;
  int completedCourses;
  final Color color;
  final IconData icon;

  LearningPathModel({
    required this.id,
    required this.title,
    required this.description,
    required this.lessons,
    required this.color,
    required this.icon,
    this.progress = 0.0,
    this.isEnrolled = false,
    this.completedCourses = 0,
  });

  factory LearningPathModel.fromJson(Map<String, dynamic> json) {
    return LearningPathModel(
      id: json['id'].toString(),
      title: json['title'],
      description: json['description'] ?? '',
      lessons: (json['lessons'] as List)
          .map((e) => LessonModel.fromJson(e))
          .toList(),
      progress: (json['progress'] ?? 0.0).toDouble(),
      isEnrolled: json['isEnrolled'] ?? false,
      completedCourses: json['completedCourses'] ?? 0,
      color: json['color'] ?? Colors.blueAccent,
      icon: json['icon'] ?? Icons.book_rounded,
    );
  }
}

class LessonModel {
  final String title;
  final String content;
  final String? codeSnippet;
  bool isCompleted;

  LessonModel({
    required this.title,
    required this.content,
    this.codeSnippet,
    this.isCompleted = false,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      title: json['title'],
      content: json['content'] ?? '',
      codeSnippet: json['codeSnippet'],
      isCompleted: json['isCompleted'] ?? false,
    );
  }
}
