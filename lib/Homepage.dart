import 'package:app/Course.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final List<String> courses = ["อัลกอริทึม", "โครงสร้างข้อมูล"];
  final List<String> coursesid = ["CS201 • 8/12 บท", "CS102 • 3/10 บท"];
  final List<String> icons = ["🧮", "📊"];
  final List<double> progress = [8/12, 3/10]; // คำนวณเป็น progress percentage

  //finishcourse
  final List<String> finishcourses = ["ฐานข้อมูล", "ระบบปฏิบัติการ"];
  final List<String> finishcoursespoint = ["3", "3"];
  final List<String> finishicons = ["💾", "🖥️"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(40),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "สวัสดี👋",
                      style: TextStyle(fontSize: 16, color: const Color.fromARGB(255, 83, 83, 83), fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "สมชาย ใจดี",
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 6),
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 231, 231, 231),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.local_fire_department_outlined, color: Colors.orangeAccent),
                          SizedBox(width: 8),
                          Text("7", style: TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 6),
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 231, 231, 231),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.lightbulb_outlined, color: Colors.blueAccent),
                          SizedBox(width: 8),
                          Text("2450", style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold)),
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
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.circular(20)
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
                        backgroundColor: const Color.fromARGB(255, 231, 231, 231),
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
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
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 5,
                  children: [
                    Column(
                      children: [
                        Text("Learning Path", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        Text("เรียนไปแล้ว 1/3 วิชา", style: TextStyle(fontSize: 16, color: const Color.fromARGB(255, 128, 128, 128))),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal:  0, vertical: 10),
                        width:180,
                        height: 25,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 183, 210, 255),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text("CS วิทยาการคอมพิวเตอร์", style: TextStyle(color: Colors.blueAccent)),
                        ),
                    )
                  ],
                ),
              )
            ],),
          ),

          //course preview - "เรียนต่อ" section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("เรียนต่อ", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Coursepage()));
                  },
                  child: Row(
                    children: [
                      Text("ดูทั้งหมด", style: TextStyle(fontSize: 16, color: Colors.blueAccent)),
                      Container(
                        padding: EdgeInsets.all(8),
                        child: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.blueAccent),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),

          //course list
            Expanded(
              child: ListView.builder(
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Coursepage()));
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            Text(icons[index], style: TextStyle(fontSize: 32)),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(courses[index], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                  Text(coursesid[index], style: TextStyle(fontSize: 14, color: Colors.grey)),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => Coursepage()));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                padding: EdgeInsets.all(10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 4,
                              ),
                              child: Icon(Icons.play_arrow_outlined, color: Colors.white, size: 22),
                            ),
                          ],),
                          SizedBox(height: 12),
                          Text("เรียนต่อจากบทที่แล้ว", style: TextStyle(fontSize: 12, color: Colors.grey)),
                          SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: progress[index],
                              minHeight: 6,
                              backgroundColor: Colors.grey[300],
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text("${(progress[index] * 100).toStringAsFixed(0)}% เสร็จสิ้น", 
                            style: TextStyle(fontSize: 12, color: Colors.blueAccent, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            //finish corse list
              Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("เรียนจบแล้ว ✅", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: finishcourses.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Coursepage()));
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Text(finishicons[index], style: TextStyle(fontSize: 32)),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(finishcourses[index], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                    Text("เรียนจบแล้ว ${finishcoursespoint[index]} หน่วยกิจ", style: TextStyle(fontSize: 14, color: Colors.green)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            )

            
        ],
      ),
    );
  }
}