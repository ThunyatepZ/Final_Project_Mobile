class CourseModel {
  String id;
  String courseName;
  String courseID;
  String courseNameEn;
  String credits;
  String description;
  String imageUrl;
  List<String> topics;

  CourseModel({
    this.id = "",
    required this.courseName,
    required this.courseID,
    this.courseNameEn = "",
    this.credits = "3",
    this.description = "",
    this.imageUrl = "",
    this.topics = const [],
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'] ?? '',
      courseID: json['courseID'] ?? '',
      courseName: json['courseName'] ?? '',
      courseNameEn: json['courseNameEn'] ?? '',
      credits: json['credits'] ?? '3',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      topics: json['topics'] != null ? List<String>.from(json['topics']) : [],
    );
  }
}
