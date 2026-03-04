import 'package:app/AuthScreen.login.dart';
import 'package:app/Homepage.dart';
import 'package:app/QA.page.dart';
import 'package:flutter/material.dart';
import 'package:app/Profile.page.dart';
import 'Course.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/auth",
      routes: {
        "/auth": (context) => const AuthScreenLogin(),
        "/profile": (context) => const ProfilePage(),
        "/home": (context) => const Homepage(),
        "/course": (context) => const Coursepage(),
        "/QA": (context) => const QApage(),
      },
    );
  }
}

void main() {
  runApp(const MyWidget());
}
