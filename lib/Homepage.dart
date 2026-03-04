import 'package:app/AuthScreen.login.dart';
import 'package:app/Course.dart';
import 'package:flutter/material.dart';
import 'package:app/course.product.dart';
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
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
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
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
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
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                        BoxShadow(
                          color : Theme.of(context).shadowColor,
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
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
                            // color: Colors.white,
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
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text(
                                "Learning Path",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color : Theme.of(context).textTheme.titleMedium!.color,
                                ),
                              ),
                              Text(
                                "เรียนไปแล้ว 1/3 วิชา",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: const Color.fromARGB(255, 128, 128, 128),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
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
                                style: TextStyle(color: const Color.fromARGB(255, 22, 87, 139)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            //course preview - "เรียนต่อ" section
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

            // course list
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              itemCount: courseProduct.cousrsProduct.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).cardColor,
                    boxShadow: [
                      BoxShadow(
                        color : Theme.of(context).shadowColor,
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListTile(
                    title: Text(
                      "Course ${courseProduct.cousrsProduct[index].courseName}",
                    ),
                    subtitle: Text(
                      "${courseProduct.cousrsProduct[index].courseID} * ${courseProduct.cousrsProduct[index].courseProgress}",
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                    leading: Icon(Icons.book, color: const Color.fromARGB(255, 93, 93, 93)),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
