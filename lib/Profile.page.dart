import 'package:app/component_/buttom_nav.dart';
import 'package:flutter/material.dart';
import 'package:app/component_/theme.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 3),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "โปรไฟล์",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              //profile card
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).shadowColor.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              //profile pic
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      "https://cdn-icons-png.flaticon.com/512/149/149071.png",
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "ชื่อ นามสกุล",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            "อีเมล@gmail.com",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //end profile card

            //statistic card
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  //Xp รวม
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).shadowColor.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),

                      //data XP รวม
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            "2450",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "XP รวม",
                            style: TextStyle(fontSize: 13, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),

                  //strak
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).shadowColor.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      //data Streak รวม
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            "7",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.orangeAccent,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Streak รวม",
                            style: TextStyle(fontSize: 13, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),

                  //วิชา
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).shadowColor.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      //data วิชา รวม
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            "3",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.green
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "วิชาเรียน",
                            style: TextStyle(fontSize: 13, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //end static card

            //list view setting
            Column(
              children: [
                Container(
                  margin: EdgeInsets.all(25),
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).shadowColor.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),

                  //listview setting
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.notifications_outlined, color: Colors.grey),
                        title: Text("การแจ้งเตือน", style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color)),
                        trailing: Icon(Icons.arrow_forward_ios_outlined, size: 16),
                      ),
                      Divider(color: Theme.of(context).dividerColor),
                      ListTile(
                        leading: Icon(Icons.privacy_tip_outlined, color: Colors.grey),
                        title: Text("ความเป็นส่วนตัว", style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color)),
                        trailing: Icon(Icons.arrow_forward_ios_outlined, size: 16),
                      ),
                      Divider(color: Theme.of(context).dividerColor),
                      ListTile(
                        leading: Icon(Icons.dark_mode_outlined, color: Colors.grey),
                        title: Text("ธีม", style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color)),
                        trailing: Icon(Icons.arrow_forward_ios_outlined, size: 16),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => Themepage())),
                      ),
                      Divider(color: Theme.of(context).dividerColor),
                      ListTile(
                        leading: Icon(Icons.info_outline, color: Colors.grey),
                        title: Text("ช่วยเหลือ", style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color)),
                        trailing: Icon(Icons.arrow_forward_ios_outlined, size: 16),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
