import 'package:app/AuthScreen.page.dart';
import 'package:flutter/material.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/auth",
      routes: {"/auth": (context) => const AuthScreen()},
    );
  }
}

void main() {
  runApp(const MyWidget());
}
