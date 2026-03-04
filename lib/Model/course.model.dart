class CourseModel {
  String courseName;
  String courseID;
  String courseNameEn;
  String credits;
  String description;
  String imageUrl;
  List<String> topics;

  CourseModel({
    required this.courseName,
    required this.courseID,
    this.courseNameEn = "",
    this.credits = "3",
    this.description = "",
    this.imageUrl = "",
    this.topics = const [],
  });
}
