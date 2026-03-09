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
  List<dynamic> myQuizzes = [];
  List<dynamic> quizAttempts = [];

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

    final quizMyRes = await http.get(
      Uri.parse('$url/api/v1/quiz/my'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (!mounted) return;

    setState(() {
      username = jsonDecode(res.body)['username'];
      email = jsonDecode(res.body)['email'];

      final historyData = jsonDecode(historyRes.body);
      if (historyData['status'] == 'success') {
        quizAttempts = historyData['history'] ?? [];
      }

      final myData = jsonDecode(quizMyRes.body);
      if (myData['status'] == 'success') {
        myQuizzes = myData['quizzes'] ?? [];
      }

      isLoadingProfile = false;
    });
  }

  double _calculateAverageScore() {
    if (quizAttempts.isEmpty) return 0.0;
    double totalPercent = 0;
    for (var attempt in quizAttempts) {
      int score = attempt['score'] ?? 0;
      int total = attempt['total_questions'] ?? 1;
      totalPercent += (score / total) * 100;
    }
    return totalPercent / quizAttempts.length;
  }

  int _calculateBestScore() {
    if (quizAttempts.isEmpty) return 0;
    int best = 0;
    for (var attempt in quizAttempts) {
      int score = attempt['score'] ?? 0;
      if (score > best) best = score;
    }
    return best;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Text(
            "โปรไฟล์",
            style: TextStyle(
              color:
                  Theme.of(context).textTheme.titleLarge?.color ??
                  Theme.of(context).colorScheme.onSurface,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: false,
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 3),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            // New Profile Section
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade600, Colors.blue.shade900],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          username != null && username!.isNotEmpty
                              ? username![0].toUpperCase()
                              : "U",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              username ?? "Guest",
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              email ?? "no-email@example.com",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Divider(color: Colors.white24),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem("ครั้ง", quizAttempts.length.toString()),
                      _buildStatItem(
                        "เฉลี่ย",
                        "${_calculateAverageScore().toStringAsFixed(0)}%",
                      ),
                      _buildStatItem(
                        "สูงสุด",
                        _calculateBestScore().toString(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // My Created Quizzes section
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "ข้อสอบที่ฉันสร้าง (${myQuizzes.length})",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            const SizedBox(height: 12),
            if (isLoadingProfile)
              const CircularProgressIndicator()
            else if (myQuizzes.isEmpty)
              _buildEmptyState(
                "ยังไม่ได้สร้างแบบฝึกหัด\nมาลองสร้างแบบฝึกหัดเพิ่มกันเถอะ!",
                Icons.post_add_rounded,
              )
            else
              ...myQuizzes.map((quiz) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).shadowColor.withOpacity(0.04),
                        blurRadius: 15,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.description_outlined,
                          color: Colors.orange.shade400,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              quiz['title'] ?? "ไม่ทราบชื่อ",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              quiz['created_at'] != null
                                  ? quiz['created_at']
                                        .toString()
                                        .split(' ')
                                        .first
                                  : "-",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                );
              }),
            const SizedBox(height: 24),

            // History Section
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "ประวัติการทำข้อสอบ (${quizAttempts.length})", // Used quizHistory
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            const SizedBox(height: 12),
            if (isLoadingProfile)
              const CircularProgressIndicator()
            else if (quizAttempts.isEmpty) // Used quizHistory
              _buildEmptyState(
                "ยังไม่มีประวัติการทำข้อสอบ\nเริ่มทำข้อสอบเพื่อเก็บสถิติที่นี่!",
                Icons.quiz_outlined,
              )
            else
              ...quizAttempts.map((attempt) {
                // Used quizHistory
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).shadowColor.withOpacity(0.04),
                        blurRadius: 15,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${attempt['score'] ?? 0}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.blueAccent,
                              ),
                            ),
                            Text(
                              "/ ${attempt['total_questions'] ?? 0}",
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.blueAccent,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              attempt['quiz_title'] ?? "ไม่ทราบชื่อข้อสอบ",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              attempt['completed_at'] != null
                                  ? attempt['completed_at']
                                        .toString()
                                        .split(' ')
                                        .first
                                  : "-",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                );
              }),
            const SizedBox(height: 20),

            // Removed placeholder menu items as requested
            const SizedBox(height: 12),

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

  Widget _buildEmptyState(String message, IconData icon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          Icon(icon, size: 48, color: Colors.grey.shade200),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.7)),
        ),
      ],
    );
  }
}
