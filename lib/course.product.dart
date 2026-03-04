import 'package:app/Model/course.model.dart';

class CourseProduct {
  final cousrsProduct = [
    CourseModel(
      courseName: "อัลกอริทึม",
      courseID: "CS201",
      courseProgress: "10/12",
      difficulty: "ปานกลาง",
      credits: "3",
      description: "เรียนรู้ Search, Sort, Recursion และ Dynamic Programming",
      tags: ["Binary Search", "Merge Sort", "Quick Sort", "+3"],
      progressValue: 0.6,
    ),
    CourseModel(
      courseName: "โครงสร้างข้อมูล",
      courseID: "CS102",
      courseProgress: "12/12",
      difficulty: "เบื้องต้น",
      credits: "3",
      description: "Array, Linked List, Stack, Queue, Tree, Graph",
      tags: ["Array", "Linked List", "Stack", "+3"],
      progressValue: 0.9,
    ),
    CourseModel(
      courseName: "ฐานข้อมูล",
      courseID: "CS301",
      courseProgress: "12/12",
      difficulty: "ปานกลาง",
      credits: "3",
      description: "SQL, Normalization, Indexing, Transaction",
      tags: ["SQL", "ER Diagram", "Normalization", "+3"],
      progressValue: 0.2,
    ),
  ];
}
