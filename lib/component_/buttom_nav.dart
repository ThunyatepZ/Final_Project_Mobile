import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        if (index == currentIndex) return; // 👈 กันกดซ้ำ

        if (index == 0) {
          Navigator.pushReplacementNamed(context, "/home");
        }
        if (index == 1) {
          Navigator.pushReplacementNamed(context, "/course");
        }
        if (index == 3) {
          Navigator.pushReplacementNamed(context, "/profile");
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: "หน้าหลัก",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.menu_book_outlined),
          label: "วิชาเรียน",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.emoji_events_outlined),
          label: "ผลคะแนน",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: "โปรไฟล์",
        ),
      ],
    );
  }
}
