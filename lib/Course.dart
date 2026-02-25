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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: Text("วิชาเรียนทั้งหมด", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: courses.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(children: [
                    Text(icons[index], style: TextStyle(fontSize: 32)),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(courses[index], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text(coursesid[index], style: TextStyle(fontSize: 14, color: Colors.grey)),
                          Text(decription[index], style: TextStyle(fontSize: 12, color: Colors.grey), overflow: TextOverflow.ellipsis, maxLines: 2),
                        ],
                      ),
                    )
                  ],)
                );
              },
            ),
          ),
        ],
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => Homepage()));
              },
            ),
            IconButton(
              icon: Icon(Icons.book_outlined),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Coursepage()));
              },
            ),
          ],
        ),
      ),
    );
  }
}