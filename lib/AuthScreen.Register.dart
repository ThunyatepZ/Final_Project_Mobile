import 'package:flutter/material.dart';

class AuthScreenRegister extends StatelessWidget {
  const AuthScreenRegister({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Container(
              padding: EdgeInsets.all(10),

              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.book, color: Colors.white),
            ),
            Text(
              "Smart Recomendation",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text("AI Powered Learning", style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
