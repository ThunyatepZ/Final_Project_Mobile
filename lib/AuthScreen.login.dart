import 'package:app/Homepage.dart';
import 'package:app/Model/authusermodel.dart';
import 'package:flutter/material.dart';

class AuthScreenLogin extends StatefulWidget {
  const AuthScreenLogin({super.key});

  @override
  State<AuthScreenLogin> createState() => _AuthScreenLoginState();
}

class _AuthScreenLoginState extends State<AuthScreenLogin> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  AuthModel authModel = AuthModel();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void login() {}

  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.book, color: Colors.white, size: 40),
              ),
              SizedBox(height: 10),
              Text(
                "Smart Recomendation",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text("AI Powered Learning", style: TextStyle(fontSize: 18)),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F2F5),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Stack(
                    children: [
                      AnimatedAlign(
                        alignment: isLogin
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        child: FractionallySizedBox(
                          widthFactor: 0.5,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF007BFF), Color(0xFF00C6FF)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isLogin = true;
                                });
                              },
                              child: Container(
                                color: Colors.transparent,
                                alignment: Alignment.center,
                                child: Text(
                                  "เข้าสู่ระบบ",
                                  style: TextStyle(
                                    color: isLogin
                                        ? Colors.white
                                        : Colors.grey[600],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isLogin = false;
                                });
                              },
                              child: Container(
                                color: Colors.transparent,
                                alignment: Alignment.center,
                                child: Text(
                                  "สมัครสมาชิก",
                                  style: TextStyle(
                                    color: !isLogin
                                        ? Colors.white
                                        : Colors.grey[600],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(left: 30, right: 30, bottom: 30),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: isLogin ? _buildLoginForm() : _buildRegisterForm(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Column(
      key: ValueKey("login"),
      spacing: 10,
      children: [
        Align(alignment: Alignment.centerLeft, child: Text("username")),
        TextField(
          controller: usernameController,
          decoration: InputDecoration(
            hintText: "myuser",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            fillColor: Color.fromARGB(255, 238, 238, 238),
            filled: true,
          ),
        ),
        Align(alignment: Alignment.centerLeft, child: Text("password")),
        TextField(
          obscureText: true,
          decoration: InputDecoration(
            hintText: "********",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            fillColor: Color.fromARGB(255, 238, 238, 238),
            filled: true,
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Text("Forgot Password?", style: TextStyle(color: Colors.blue)),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.blue),
            foregroundColor: WidgetStatePropertyAll(Colors.white),
            minimumSize: WidgetStatePropertyAll(Size(double.infinity, 50)),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          onPressed: () {
            authModel.username = usernameController.text;
            authModel.password = passwordController.text;
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Homepage()),
            );
          },
          child: Text("Confirm"),
        ),
      ],
    );
  }

  Widget _buildRegisterForm() {
    return Column(
      key: ValueKey("register"),
      spacing: 10,
      children: [
        Align(alignment: Alignment.centerLeft, child: Text("email")),
        TextField(
          controller: emailController,
          decoration: InputDecoration(
            hintText: "example@email.com",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            fillColor: Color.fromARGB(255, 238, 238, 238),
            filled: true,
          ),
        ),
        Align(alignment: Alignment.centerLeft, child: Text("username")),
        TextField(
          controller: usernameController,
          decoration: InputDecoration(
            hintText: "myuser",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            fillColor: Color.fromARGB(255, 238, 238, 238),
            filled: true,
          ),
        ),
        Align(alignment: Alignment.centerLeft, child: Text("password")),
        TextField(
          controller: passwordController,
          obscureText: true,
          decoration: InputDecoration(
            hintText: "********",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            fillColor: Color.fromARGB(255, 238, 238, 238),
            filled: true,
          ),
        ),
        Align(alignment: Alignment.centerLeft, child: Text("confirm password")),
        TextField(
          obscureText: true,
          decoration: InputDecoration(
            hintText: "********",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            fillColor: Color.fromARGB(255, 238, 238, 238),
            filled: true,
          ),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.blue),
            foregroundColor: WidgetStatePropertyAll(Colors.white),
            minimumSize: WidgetStatePropertyAll(Size(double.infinity, 50)),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          onPressed: () {
            setState(() {
              isLogin = true;
            });
          },
          child: Text("Register"),
        ),
      ],
    );
  }
}
