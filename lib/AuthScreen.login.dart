import 'dart:io';
import 'dart:convert';
import 'package:app/Model/user.model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthScreenLogin extends StatefulWidget {
  const AuthScreenLogin({super.key});

  @override
  State<AuthScreenLogin> createState() => _AuthScreenLoginState();
}

class _AuthScreenLoginState extends State<AuthScreenLogin> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  UserModel? currentUser;
  final storage = const FlutterSecureStorage();
  bool isLoading = false;
  bool isRegistering = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final String? token = await storage.read(key: 'jwt_token');
    if (token == null || token.isEmpty) return;

    setState(() => isLoading = true);
    try {
      final String baseUrl = Platform.isAndroid
          ? 'http://10.0.2.2:8000'
          : 'http://127.0.0.1:8000';
      final response = await http.get(
        Uri.parse('$baseUrl/api/v1/auth/me'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          if (mounted) {
            Navigator.pushReplacementNamed(context, '/course');
            return;
          }
        }
      }
      // ลบ Token ทิ้งถ้าตรวจสอบไม่ผ่าน (แปลว่า Token หมดอายุ หรือไม่ถูกต้อง)
      await storage.delete(key: 'jwt_token');
    } catch (e) {
      debugPrint("Check login status error: $e");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    emailController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> register() async {
    final email = emailController.text.trim();
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (email.isEmpty || username.isEmpty || password.isEmpty) {
      _showError('กรุณากรอกข้อมูลให้ครบทุกช่อง');
      return;
    }

    if (password != confirmPassword) {
      _showError('รหัสผ่านไม่ตรงกัน');
      return;
    }

    setState(() => isRegistering = true);

    try {
      final String baseUrl = Platform.isAndroid
          ? 'http://10.0.2.2:8000'
          : 'http://127.0.0.1:8000';

      final response = await http.post(
        Uri.parse('$baseUrl/api/v1/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'username': username,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == 'success') {
        _showError('สมัครสมาชิกสำเร็จ กรุณาเข้าสู่ระบบ');
        setState(() {
          isLogin = true;
          passwordController.clear();
          confirmPasswordController.clear();
        });
      } else {
        _showError(
          'Registration Failed: ${_extractErrorMessage(data, response.body)}',
        );
      }
    } catch (e) {
      _showError('Error: $e');
    } finally {
      if (mounted) setState(() => isRegistering = false);
    }
  }

  Future<void> login() async {
    setState(() => isLoading = true);

    try {
      final String baseUrl = Platform.isAndroid
          ? 'http://10.0.2.2:8000'
          : 'http://127.0.0.1:8000';

      final response = await http.post(
        Uri.parse('$baseUrl/api/v1/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': emailController.text.trim(),
          'password': passwordController.text.trim(),
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == 'success') {
        await storage.write(key: 'jwt_token', value: data['access_token']);

        if (mounted) {
          Navigator.pushReplacementNamed(context, '/course');
        }
      } else {
        _showError(
          'Login Failed: ${_extractErrorMessage(data, response.body)}',
        );
      }
    } catch (e) {
      _showError('Error: $e');
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  String _extractErrorMessage(dynamic data, String fallbackRawBody) {
    if (data is Map<String, dynamic>) {
      if (data['message'] != null) return data['message'].toString();
      if (data['detail'] != null) {
        return data['detail'] is List
            ? data['detail'][0]['msg'].toString()
            : data['detail'].toString();
      }
    }
    return fallbackRawBody;
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

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
              _buildHeader(),
              _buildToggleTabs(),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30, bottom: 30),
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

  // --- ส่วนของ UI Components ย่อย ---

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.book, color: Colors.white, size: 40),
        ),
        const SizedBox(height: 10),
        const Text(
          "Learnify",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const Text("AI Powered Learning", style: TextStyle(fontSize: 18)),
      ],
    );
  }

  Widget _buildToggleTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: const Color(0xFFF0F2F5),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              alignment: isLogin ? Alignment.centerLeft : Alignment.centerRight,
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
                _buildTabButton("เข้าสู่ระบบ", true),
                _buildTabButton("สมัครสมาชิก", false),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String title, bool isLoginTab) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            isLogin = isLoginTab;
          });
        },
        child: Container(
          color: Colors.transparent,
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              color: isLogin == isLoginTab ? Colors.white : Colors.grey[600],
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Column(
      key: const ValueKey("login"),
      children: [
        _buildTextField("email", "example@email.com", emailController),
        _buildTextField(
          "password",
          "********",
          passwordController,
          isPassword: true,
        ),
        const Align(
          alignment: Alignment.centerRight,
          child: Text("Forgot Password?", style: TextStyle(color: Colors.blue)),
        ),
        const SizedBox(height: 15),
        _buildSubmitButton(
          "Confirm",
          isLoading ? null : login,
          isLoading: isLoading,
        ),
      ],
    );
  }

  Widget _buildRegisterForm() {
    return Column(
      key: const ValueKey("register"),
      children: [
        _buildTextField("email", "example@email.com", emailController),
        _buildTextField("username", "myuser", usernameController),
        _buildTextField(
          "password",
          "********",
          passwordController,
          isPassword: true,
        ),
        _buildTextField(
          "confirm password",
          "********",
          confirmPasswordController,
          isPassword: true,
        ),
        const SizedBox(height: 15),
        _buildSubmitButton(
          "Register",
          isRegistering ? null : register,
          isLoading: isRegistering,
        ),
      ],
    );
  }

  // --- ส่วนของ Widget ย่อยที่ใช้ซ้ำซ้อน ---

  Widget _buildTextField(
    String label,
    String hint,
    TextEditingController? controller, {
    bool isPassword = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          const SizedBox(height: 5),
          TextField(
            controller: controller,
            obscureText: isPassword,
            decoration: InputDecoration(
              hintText: hint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              fillColor: const Color.fromARGB(255, 238, 238, 238),
              filled: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(
    String text,
    VoidCallback? onPressed, {
    bool isLoading = false,
  }) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: const WidgetStatePropertyAll(Colors.blue),
        foregroundColor: const WidgetStatePropertyAll(Colors.white),
        minimumSize: const WidgetStatePropertyAll(Size(double.infinity, 50)),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
      onPressed: onPressed,
      child: isLoading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : Text(text),
    );
  }
}
