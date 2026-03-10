import 'dart:io';
import 'dart:convert';
import 'package:app/Model/learning_path.model.dart';
import 'package:app/component_/buttom_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class LearningPathPage extends StatefulWidget {
  const LearningPathPage({super.key});

  @override
  State<LearningPathPage> createState() => _LearningPathPageState();
}

class _LearningPathPageState extends State<LearningPathPage> {
  final secureStorage = const FlutterSecureStorage();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadAllPathsProgress();
  }

  Future<void> _loadAllPathsProgress() async {
    setState(() => _isLoading = true);

    try {
      for (final path in _paths) {
        await _fetchPathProgress(path);
      }
    } catch (e) {
      debugPrint("Error loading learning path progress: $e");
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _fetchPathProgress(LearningPathModel path) async {
    try {
      final token = await secureStorage.read(key: 'jwt_token');
      if (token == null || token.isEmpty) return;

      final String baseUrl = Platform.isAndroid
          ? 'http://10.0.2.2:8000'
          : 'http://127.0.0.1:8000';

      final res = await http.get(
        Uri.parse('$baseUrl/api/v1/learning-path/progress/${path.id}'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (res.statusCode != 200) return;

      final data = jsonDecode(res.body);
      if (data is! Map || data['success'] != true) return;

      final dynamic rawCompletedLessons = data['completed_lessons'] ?? [];
      final List<dynamic> completedLessons = rawCompletedLessons is List
          ? rawCompletedLessons
          : (rawCompletedLessons is String
                ? (jsonDecode(rawCompletedLessons) as List<dynamic>)
                : <dynamic>[]);
      final bool isEnrolled = data['is_enrolled'] == true;

      for (final lesson in path.lessons) {
        lesson.isCompleted = completedLessons.contains(lesson.title);
      }

      final int completedCount = path.lessons
          .where((l) => l.isCompleted)
          .length;

      path.completedCourses = completedCount;
      path.progress = path.lessons.isEmpty
          ? 0.0
          : (completedCount / path.lessons.length).clamp(0.0, 1.0);
      path.isEnrolled = isEnrolled;
    } catch (e) {
      debugPrint("Error fetching path progress for id ${path.id}: $e");
    }
  }

  Future<bool> _saveProgressToServer(LearningPathModel path) async {
    try {
      final token = await secureStorage.read(key: 'jwt_token');
      if (token == null || token.isEmpty) return false;

      final String baseUrl = Platform.isAndroid
          ? 'http://10.0.2.2:8000'
          : 'http://127.0.0.1:8000';

      final completedTitles = path.lessons
          .where((l) => l.isCompleted)
          .map<String>((l) => l.title)
          .toList();

      final response = await http.post(
        Uri.parse('$baseUrl/api/v1/learning-path/progress'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'path_id': path.id,
          'completed_lessons': completedTitles,
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint("Error saving path progress for id ${path.id}: $e");
      return false;
    }
  }

  final List<LearningPathModel> _paths = [
    LearningPathModel(
      id: "1",
      title: "Mobile Developer (Flutter)",
      description:
          "เส้นทางสู่การเป็นนักพัฒนาแอปมือถือ เริ่มตั้งแต่พื้นฐาน Dart ไปจนถึงการสร้างแอปด้วย Flutter",
      color: Colors.blueAccent,
      icon: Icons.phone_iphone_rounded,
      lessons: [
        LessonModel(
          title: "บทที่ 1: ทำความรู้จักกับ Dart",
          content:
              "Dart เป็นภาษาโปรแกรมที่พัฒนาโดย Google ถูกเปิดตัวครั้งแรกในปี 2011...",
          codeSnippet:
              "// ฟังก์ชัน main...\nvoid main() {\n  print('Hello, Welcome to Dart!');\n}",
        ),
        LessonModel(
          title: "บทที่ 2: ตัวแปรประเภทต่างๆ และฟังก์ชัน",
          content: "Dart เป็นภาษาประเภท Strongly Typed...",
          codeSnippet:
              "int calculateAge(int birthYear) {\n  final int currentYear = DateTime.now().year;\n  return currentYear - birthYear;\n}",
        ),
        LessonModel(
          title: "บทที่ 3: Object-Oriented Programming (OOP)",
          content: "Everything is an Object...",
          codeSnippet:
              "class Animal {\n  String name;\n  Animal(this.name);\n}",
        ),
        LessonModel(
          title: "บทที่ 4: Hello Flutter วิดเจ็ตคืออะไร?",
          content: "ลบความรู้เกี่ยวกับการเขียน UI แบบภาษาอื่นๆ ทิ้งไปได้เลย...",
          codeSnippet: "void main() {\n  runApp(const MyApp());\n}",
        ),
        LessonModel(
          title: "บทที่ 5: การจัด Layout ชั้นสูง (Row & Column)",
          content:
              "ตอนนี้คุณแสดงข้อความ 1 ชิ้นได้แล้ว แต่ถ้าในหน้าจอมีข้อความ 10 ชิ้นล่ะ?...",
          codeSnippet:
              "Column(\n  children: [\n    Text('Profile Card'),\n  ],\n)",
        ),
        LessonModel(
          title: "บทที่ 6: การทำให้แอปมีชีวิตชีวา (StatefulWidget)",
          content:
              "หน้าแอปทั้งหมดที่คุณสร้างมาใน 2 บทก่อนคือ 'StatelessWidget'...",
          codeSnippet:
              "void _incrementCounter() {\n  setState(() {\n    _count++;\n  });\n}",
        ),
      ],
    ),
    LearningPathModel(
      id: "2",
      title: "Backend Developer (Go Lang)",
      description:
          "เส้นทางสู่การเป็นนักพัฒนา Backend ด้วย Go เริ่มตั้งแต่พื้นฐานภาษา ไปจนถึงการสร้าง REST API",
      color: Colors.teal,
      icon: Icons.storage_rounded,
      lessons: [
        LessonModel(
          title: "บทที่ 1: ทำความรู้จักกับ Go",
          content:
              "Go (หรือ Golang) เป็นภาษาโปรแกรมที่ถูกพัฒนาโดย Google ในปี 2009...",
          codeSnippet:
              "func main() {\n    fmt.Println(\"Hello, Welcome to Go!\")\n}",
        ),
        LessonModel(
          title: "บทที่ 2: ตัวแปรและประเภทข้อมูล",
          content: "Go เป็นภาษาแบบ Strongly Typed...",
          codeSnippet: "name := \"Somchai\"\nage := 22",
        ),
        LessonModel(
          title: "บทที่ 3: Function และ Control Flow",
          content: "Function ใน Go ใช้สำหรับจัดกลุ่มคำสั่ง...",
          codeSnippet:
              "func calculateAge(birthYear int) int {\n    return 2024 - birthYear\n}",
        ),
        LessonModel(
          title: "บทที่ 4: Struct และ Method",
          content: "Go ไม่มี Class แบบภาษา OOP แต่ใช้ Struct แทน...",
          codeSnippet: "type User struct {\n    Name string\n}",
        ),
        LessonModel(
          title: "บทที่ 5: Goroutine และ Concurrency",
          content: "หนึ่งในจุดเด่นที่สุดของ Go คือระบบ Concurrency...",
          codeSnippet: "go sayHello()",
        ),
        LessonModel(
          title: "บทที่ 6: การสร้าง REST API ด้วย Go",
          content: "Go ถูกใช้สร้าง Backend API ได้ดีมาก...",
          codeSnippet: "http.HandleFunc(\"/hello\", helloHandler)",
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          "Learnify Learning Path",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: false,
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 0),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blue.shade700, Colors.blue.shade900],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.shade900.withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              "Learning Paths 🚀",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            "Learnify",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "คอร์สเรียนสำหรับคุณ เพื่อคุณที่ดีขึ้น",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      "แผนการเรียนของคุณ",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ..._paths.map((path) => _buildPathCard(path)),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildPathCard(LearningPathModel path) {
    final bool isEnrolled = path.isEnrolled;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: path.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(path.icon, color: path.color, size: 30),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        path.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        path.description,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isEnrolled
                          ? "เรียนไปแล้ว ${path.completedCourses}/${path.lessons.length} คอร์ส"
                          : "ทั้งหมด ${path.lessons.length} คอร์ส",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    Text(
                      "${(path.progress * 100).toInt()}%",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: path.color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: path.progress,
                    backgroundColor: Colors.grey.shade200,
                    color: path.color,
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (isEnrolled) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LearningPathDetailPage(
                              path: path,
                              onProgressUpdated: () => setState(() {}),
                            ),
                          ),
                        );
                      } else {
                        _enrollPath(path);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isEnrolled ? path.color : Colors.black87,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      isEnrolled ? "เรียนต่อ" : "สมัครคอร์สเรียนวิชานี้",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _enrollPath(LearningPathModel path) async {
    setState(() {
      path.isEnrolled = true;
    });
    final bool didSave = await _saveProgressToServer(path);
    if (!didSave) {
      if (!mounted) return;
      setState(() {
        path.isEnrolled = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("สมัครเรียนไม่สำเร็จ กรุณาลองใหม่อีกครั้ง"),
        ),
      );
      return;
    }

    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Icon(
          Icons.check_circle_rounded,
          size: 50,
          color: Colors.green,
        ),
        content: Text(
          "สมัครเรียนแผนการเรียน\n「${path.title}」 สำเร็จ!\nระบบได้อัปเดตสถานะของคุณแล้ว",
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("ปิด"),
          ),
        ],
      ),
    );
  }
}

class LearningPathDetailPage extends StatefulWidget {
  final LearningPathModel path;
  final VoidCallback onProgressUpdated;

  const LearningPathDetailPage({
    super.key,
    required this.path,
    required this.onProgressUpdated,
  });

  @override
  State<LearningPathDetailPage> createState() => _LearningPathDetailPageState();
}

class _LearningPathDetailPageState extends State<LearningPathDetailPage> {
  final FlutterSecureStorage _detailStorage = const FlutterSecureStorage();

  Future<void> _updateProgress() async {
    int completed = widget.path.lessons.where((l) => l.isCompleted).length;

    setState(() {
      widget.path.completedCourses = completed;
      widget.path.progress = (completed / widget.path.lessons.length).clamp(
        0.0,
        1.0,
      );
      widget.path.isEnrolled = true;
    });
    widget.onProgressUpdated();
    await _saveProgressToServer(widget.path);
  }

  Future<void> _saveProgressToServer(LearningPathModel path) async {
    try {
      final token = await _detailStorage.read(key: 'jwt_token');
      if (token == null || token.isEmpty) return;

      final String baseUrl = Platform.isAndroid
          ? 'http://10.0.2.2:8000'
          : 'http://127.0.0.1:8000';

      final completedTitles = path.lessons
          .where((l) => l.isCompleted)
          .map<String>((l) => l.title)
          .toList();

      await http.post(
        Uri.parse('$baseUrl/api/v1/learning-path/progress'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'path_id': path.id,
          'completed_lessons': completedTitles,
        }),
      );
    } catch (e) {
      debugPrint("Error saving detail path progress for id ${path.id}: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final path = widget.path;
    final color = path.color;
    final lessons = path.lessons;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          path.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      backgroundColor: Colors.grey.shade50,
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: lessons.length,
        itemBuilder: (context, index) {
          final lesson = lessons[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: lesson.isCompleted
                    ? color.withOpacity(0.5)
                    : Colors.grey.shade200,
                width: lesson.isCompleted ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 8,
              ),
              leading: CircleAvatar(
                backgroundColor: lesson.isCompleted
                    ? color
                    : Colors.grey.shade200,
                child: Icon(
                  lesson.isCompleted
                      ? Icons.check_rounded
                      : Icons.lock_open_rounded,
                  color: lesson.isCompleted
                      ? Colors.white
                      : Colors.grey.shade600,
                ),
              ),
              title: Text(
                lesson.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: lesson.isCompleted ? Colors.black87 : Colors.black54,
                ),
              ),
              subtitle: Text(
                lesson.isCompleted ? "เรียนจบแล้ว" : "ยังไม่ได้เรียน",
                style: TextStyle(
                  color: lesson.isCompleted ? color : Colors.grey,
                  fontSize: 12,
                ),
              ),
              trailing: const Icon(
                Icons.play_arrow_rounded,
                color: Colors.blueAccent,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LessonContentPage(
                      lessonTitle: lesson.title,
                      lessonContent: lesson.content,
                      codeSnippet: lesson.codeSnippet,
                      color: color,
                      isCompleted: lesson.isCompleted,
                      onMarkComplete: () {
                        setState(() => lesson.isCompleted = true);
                        _updateProgress();
                      },
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class LessonContentPage extends StatelessWidget {
  final String lessonTitle;
  final String lessonContent;
  final String? codeSnippet;
  final Color color;
  final bool isCompleted;
  final VoidCallback onMarkComplete;

  const LessonContentPage({
    super.key,
    required this.lessonTitle,
    required this.lessonContent,
    this.codeSnippet,
    required this.color,
    required this.isCompleted,
    required this.onMarkComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("เนื้อหาบทเรียน"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lessonTitle,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      lessonContent,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.8,
                        color: Colors.black87,
                      ),
                    ),
                    if (codeSnippet != null) ...[
                      const SizedBox(height: 24),
                      const Text(
                        "💡 ตัวอย่างโค้ด (Code Snippet)",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1E1E),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Text(
                          codeSnippet!,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 14,
                            color: Color(0xFFD4D4D4),
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (!isCompleted) {
                      onMarkComplete();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("ทำเครื่องหมายว่าเรียนจบแล้ว!"),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isCompleted ? Colors.grey.shade300 : color,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    isCompleted
                        ? "เรียนจบแล้ว (กลับหน้ารวม)"
                        : "ทำเครื่องหมายว่าเรียนจบ",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isCompleted ? Colors.black54 : Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
