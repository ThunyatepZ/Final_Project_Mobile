import 'dart:convert';
import 'dart:io';

import 'package:app/component_/buttom_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final storage = const FlutterSecureStorage();
  String? username;
  String? email;
  bool isLoadingProfile = true;
  List<dynamic> historyCourses = [];

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    final token = await storage.read(key: 'jwt_token');
    final url = Platform.isAndroid
        ? 'http://10.0.2.2:8000'
        : 'http://127.0.0.1:8000';

    final res = await http.get(
      Uri.parse('$url/api/v1/auth/me'),
      headers: {'Authorization': 'Bearer $token'},
    );

    final historyRes = await http.get(
      Uri.parse('$url/api/v1/auth/history'),
      headers: {'Authorization': 'Bearer $token'},
    );

    setState(() {
      username = jsonDecode(res.body)['username'];
      email = jsonDecode(res.body)['email'];

      final historyData = jsonDecode(historyRes.body);
      if (historyData['status'] == 'success') {
        historyCourses = historyData['history'] ?? [];
      }

      isLoadingProfile = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.0),
          child: Text(
            "โปรไฟล์",
            style: TextStyle(
              color: Color(0xFF1E293B),
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: false,
      ),
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 2),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            // Profile Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 15,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF00A2FF), Color(0xFF02BBFF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.center,
                    child: isLoadingProfile
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            username != null && username!.isNotEmpty
                                ? username![0].toUpperCase()
                                : "U",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          username ??
                              (isLoadingProfile
                                  ? "กำลังโหลด..."
                                  : "ไม่ทราบชื่อ"),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          email ??
                              (isLoadingProfile
                                  ? "กำลังโหลด..."
                                  : "ไม่ทราบอีเมล"),
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // History Section
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "วิชาเรียนที่สนใจ",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
            ),
            const SizedBox(height: 12),
            if (isLoadingProfile)
              const CircularProgressIndicator()
            else if (historyCourses.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 15,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Text(
                  "ยังไม่มีวิชาเรียนที่สนใจ",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              )
            else
              ...historyCourses.map((course) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 15,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFF00B4FF).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.menu_book_rounded,
                          color: Color(0xFF00B4FF),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              course['courseName'] ?? "ไม่ทราบชื่อวิชา",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              course['courseID'] ?? "-",
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            const SizedBox(height: 12),

            // Menu List
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 15,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildMenuItem(
                    Icons.notifications_none_rounded,
                    "การแจ้งเตือน",
                    true,
                    () => _showSnackBar("ตั้งค่าการแจ้งเตือน (เร็วๆ นี้)"),
                  ),
                  _buildMenuItem(
                    Icons.shield_outlined,
                    "ความเป็นส่วนตัว",
                    true,
                    () => _showSnackBar("ตั้งค่าความเป็นส่วนตัว (เร็วๆ นี้)"),
                  ),
                  _buildMenuItem(
                    Icons.help_outline_rounded,
                    "ช่วยเหลือ",
                    false,
                    () => _showSnackBar("ศูนย์ช่วยเหลือ (เร็วๆ นี้)"),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Logout Button
            OutlinedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/auth');
                storage.delete(key: 'jwt_token');
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFEF4444)),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: const Color(0xFFFEF2F2),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout_rounded, color: Color(0xFFEF4444)),
                  SizedBox(width: 8),
                  Text(
                    "ออกจากระบบ",
                    style: TextStyle(
                      color: Color(0xFFEF4444),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildMenuItem(
    IconData icon,
    String title,
    bool showDivider,
    VoidCallback onTap,
  ) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 2,
          ),
          leading: Icon(icon, color: const Color(0xFF475569)),
          title: Text(
            title,
            style: const TextStyle(fontSize: 16, color: Color(0xFF1E293B)),
          ),
          trailing: const Icon(
            Icons.chevron_right_rounded,
            color: Color(0xFF94A3B8),
          ),
          onTap: onTap,
        ),
        if (showDivider)
          const Divider(
            height: 1,
            thickness: 1,
            color: Color(0xFFF1F5F9),
            indent: 20,
            endIndent: 20,
          ),
      ],
    );
  }
}
