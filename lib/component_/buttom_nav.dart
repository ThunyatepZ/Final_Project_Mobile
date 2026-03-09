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
          Navigator.pushReplacementNamed(context, "/learning-path");
        }
        if (index == 1) {
          Navigator.pushReplacementNamed(context, "/course");
        }
        if (index == 2) {
          Navigator.pushReplacementNamed(context, "/QA");
        }
        if (index == 3) {
          Navigator.pushReplacementNamed(context, "/profile");
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.route_outlined),
          label: "คอร์สเรียน",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.menu_book_outlined),
          label: "คลังข้อสอบ",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble_outline),
          label: "ผู้ช่วย",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: "โปรไฟล์",
        ),
      ],
    );
  }
}
