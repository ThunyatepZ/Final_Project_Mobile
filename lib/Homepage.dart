import 'package:app/AuthScreen.login.dart';
import 'package:app/Course.dart';
import 'package:app/Detail.page.dart';
import 'package:flutter/material.dart';
import 'package:app/products/course.product.dart';
import 'package:app/component_/buttom_nav.dart';
import 'package:app/Profile.page.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final courseProduct = CourseProduct();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 0),
      backgroundColor: const Color.fromARGB(255, 255, 252, 252),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 10, left: 40, right: 40),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "สวัสดี👋",
                      style: TextStyle(
                        fontSize: 16,
                        color: const Color.fromARGB(255, 83, 83, 83),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "user ***",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 6),
                      padding: EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 231, 231, 231),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.local_fire_department_outlined,
                            color: Colors.orangeAccent,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "7",
                            style: TextStyle(
                              color: Colors.orangeAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 6),
                      padding: EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 231, 231, 231),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.lightbulb_outlined,
                            color: Colors.blueAccent,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "2450",
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          //dashbord
          Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 140,
                  height: 140,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: CircularProgressIndicator(
                          value: 0.65,
                          strokeWidth: 15,
                          backgroundColor: const Color.fromARGB(
                            255,
                            231,
                            231,
                            231,
                          ),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.blueAccent,
                          ),
                        ),
                      ),
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "65%",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 5,
                    children: [
                      Column(
                        children: [
                          Text(
                            "Learnify",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 0,
                          vertical: 10,
                        ),
                        width: 180,
                        height: 25,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 183, 210, 255),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            "CS วิทยาการคอมพิวเตอร์",
                            style: TextStyle(color: Colors.blueAccent),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          //course
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "เรียนต่อ",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Coursepage()),
                    );
                  },
                  child: Row(
                    children: [
                      Text(
                        "ดูทั้งหมด",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blueAccent,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 20),
              itemCount: courseProduct.cousrsProduct.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPage(
                            course: courseProduct.cousrsProduct[index],
                          ),
                        ),
                      );
                    },
                    title: Text(
                      "Course ${courseProduct.cousrsProduct[index].courseName}",
                    ),
                    subtitle: Text(
                      "${courseProduct.cousrsProduct[index].courseID}",
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                    leading: Icon(Icons.book),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
