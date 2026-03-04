class CourseModel {
  String courseName;
  String courseID;
  String courseProgress;
  String difficulty;
  String credits;
  String description;
  List<String> tags;
  double progressValue;

  CourseModel({
    required this.courseName,
    required this.courseID,
    required this.courseProgress,
    this.difficulty = "ปานกลาง",
    this.credits = "3",
    this.description = "",
    this.tags = const [],
    this.progressValue = 0.0,
  });
}
