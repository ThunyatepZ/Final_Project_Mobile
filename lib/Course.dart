import 'dart:convert';
import 'dart:io';

import 'package:app/component_/buttom_nav.dart';
import 'package:app/CreateQuiz.page.dart';
import 'package:app/Model/quiz.model.dart';
import 'package:app/QuizTaking.page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class CoursePage extends StatefulWidget {
  const CoursePage({super.key});

  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  List<QuizModel> _allQuizzes = [];
  String _searchQuery = "";
  bool isPageLoading = true;
  final secureStorage = const FlutterSecureStorage();
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadQuizzes();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _loadQuizzes() async {
    setState(() => isPageLoading = true);
    try {
      final token = await secureStorage.read(key: 'jwt_token');
      final baseUrl = Platform.isAndroid
          ? 'http://10.0.2.2:8000'
          : 'http://127.0.0.1:8000';

      final response = await http.get(
        Uri.parse('$baseUrl/api/v1/quiz'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          if (mounted) {
            setState(() {
              _allQuizzes = (data['quizzes'] as List)
                  .map((e) => QuizModel.fromJson(e))
                  .toList();
              isPageLoading = false;
            });
          }
          return;
        }
      }
    } catch (e) {
      debugPrint("Error fetching quizzes: $e");
    }

    if (mounted) setState(() => isPageLoading = false);
  }

  // ฟังก์ชันสำหรับกรองข้อมูล (ลอจิกการค้นหา)
  List<QuizModel> get _getFilteredQuizzes {
    if (_searchQuery.isEmpty) return _allQuizzes;

    final query = _searchQuery.toLowerCase();
    return _allQuizzes.where((quiz) {
      return quiz.title.toLowerCase().contains(query) ||
          quiz.description.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "คลังฝึกหัด",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: _loadQuizzes,
                    icon: const Icon(Icons.refresh),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                "สร้างแบบฝึกหัดส่วนตัว",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 20),

              // Search Bar
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: TextField(
                  controller: searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "ค้นหาแนวข้อสอบ...",
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.blueAccent,
                      size: 20,
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(
                              Icons.clear,
                              size: 20,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              searchController.clear();
                              setState(() {
                                _searchQuery = "";
                              });
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Quiz List
              Expanded(
                child: isPageLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _allQuizzes.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.quiz_outlined,
                              size: 80,
                              color: Colors.grey[300],
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              "ยังไม่มีข้อสอบในคลัง",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: _getFilteredQuizzes.length,
                        itemBuilder: (context, index) {
                          final quiz = _getFilteredQuizzes[index];
                          return _buildQuizCard(quiz);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blueAccent,
        onPressed: () async {
          bool? created = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateQuizPage()),
          );
          if (created == true) _loadQuizzes();
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("สร้างข้อสอบ", style: TextStyle(color: Colors.white)),
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 1),
    );
  }

  Widget _buildQuizCard(QuizModel quiz) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                backgroundColor: Colors.blueAccent,
                child: Icon(Icons.question_answer, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      quiz.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "โดย: ${quiz.author} • ${quiz.createdAt.split(' ').first}",
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            quiz.description,
            style: TextStyle(fontSize: 14, color: Colors.grey[800]),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizTakingPage(quizId: quiz.id),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("เริ่มทำข้อสอบ"),
            ),
          ),
        ],
      ),
    );
  }
}
