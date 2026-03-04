import 'package:app/Model/course.model.dart';

class CourseProduct {
  final cousrsProduct = [
    CourseModel(
      courseName: "อัลกอริทึม",
      courseID: "CS201",
      courseNameEn: "Algorithms",
      credits: "3",
      description: "เรียนรู้ Search, Sort, Recursion และ Dynamic Programming",
      imageUrl: "",
      topics: [
        "Binary Search",
        "Merge Sort",
        "Quick Sort",
        "Recursion",
        "Dynamic Programming",
      ],
    ),
    CourseModel(
      courseName: "โครงสร้างข้อมูล",
      courseID: "CS102",
      courseNameEn: "Data Structure",
      credits: "3",
      description: "Array, Linked List, Stack, Queue, Tree, Graph",
      imageUrl: "",
      topics: ["Array", "Linked List", "Stack", "Queue", "Tree", "Graph"],
    ),
    CourseModel(
      courseName: "ฐานข้อมูล",
      courseID: "CS301",
      courseNameEn: "Database",
      credits: "3",
      description: "SQL, Normalization, Indexing, Transaction",
      imageUrl: "",
      topics: ["SQL", "ER Diagram", "Normalization", "Indexing", "Transaction"],
    ),
    CourseModel(
      courseName: "การพัฒนาโปรแกรมประยุกต์เคลื่อนที่",
      courseID: "040613421",
      courseNameEn: "Mobile Application Development",
      credits: "3",
      description: "เรียนรู้การพัฒนาโปรแกรมประยุกต์เคลื่อนที่",
      imageUrl: "",
      topics: ["Flutter", "Dart", "Widget", "State Management", "Firebase"],
    ),
  ];
}
