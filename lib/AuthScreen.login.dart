import 'package:app/Homepage.dart';
import 'package:flutter/material.dart';

class AuthScreenLogin extends StatelessWidget {
  const AuthScreenLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          ),
                        ),
                      ),
                      onPressed: () {},
                      child: Text("Login"),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.blue,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                      ),
                      onPressed: () {},
                      child: Text("Register"),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 30, right: 30, bottom: 30),
              child: Column(
                spacing: 10,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("username"),
                  ),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "example@email.com",
                      border: OutlineInputBorder(),
                      fillColor: Color.fromARGB(255, 218, 218, 218),
                      filled: true,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("password"),
                  ),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "********",
                      border: OutlineInputBorder(),
                      fillColor: Color.fromARGB(255, 218, 218, 218),
                      filled: true,
                    ),
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.blue),
                      foregroundColor: WidgetStatePropertyAll(Colors.white),
                      minimumSize: WidgetStatePropertyAll(
                        Size(double.infinity, 50),
                      ),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Homepage()));
                    },
                    child: Text("Confirm"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
