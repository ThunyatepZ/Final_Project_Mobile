import 'package:app/Homepage.dart';
import 'package:flutter/material.dart';

class Coursepage extends StatefulWidget {
  const Coursepage({super.key});

  @override
  State<Coursepage> createState() => _CoursepageState();
}

class _CoursepageState extends State<Coursepage> {
  final List<String> courses = ["อัลกอริทึม", "โครงสร้างข้อมูล", "ฐานข้อมูล", "ระบบปฏิบัติการ"];
  final List<String> coursesid = ["CS201 • Algorithms", "CS102 • Data Structures", "CS301 • Database Systems", "CS302 • Operating Systems"];
  final List<String> decription = ["เรียนรู้ Search, Sort, Recursion และ Dynamic Programming","Array, Linked List, Stack, Queue, Tree, Graph","SQL, Normalization, Indexing, Transaction","Process, Thread, Memory Management, File System"];
  final List<String> icons = ["🧮", "📊", "💾", "🖥️"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text("Course Page"),
      ),
      bottomNavigationBar: Container(
        height: 60,
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(Icons.home_outlined),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Homepage()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.book_outlined),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Coursepage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
