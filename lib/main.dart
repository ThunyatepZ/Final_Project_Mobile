import 'package:app/AuthScreen.login.dart';
import 'package:flutter/material.dart';
import 'package:app/AuthScreen.Register.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/auth",
      routes: {
        "/auth": (context) => const AuthScreenLogin(),
        "/register": (context) => const AuthScreenRegister(),
      },
    );
  }
}

void main() {
  runApp(const MyWidget());
}
