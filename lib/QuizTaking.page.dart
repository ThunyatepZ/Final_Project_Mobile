import 'dart:convert';
import 'dart:io';
import 'package:app/Model/quiz.model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class QuizTakingPage extends StatefulWidget {
  final String quizId;
  const QuizTakingPage({super.key, required this.quizId});

  @override
  State<QuizTakingPage> createState() => _QuizTakingPageState();
}

class _QuizTakingPageState extends State<QuizTakingPage> {
  String _title = "กำลังโหลดข้อสอบ...";
  List<QuestionModel> _questions = [];
  final Map<int, String> _userAnswers = {};
  bool _isLoading = true;
  bool _isSubmitted = false;
  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _fetchQuizDetail();
  }

  Future<void> _fetchQuizDetail() async {
    try {
      final token = await storage.read(key: 'jwt_token');
      final url = Platform.isAndroid
          ? 'http://10.0.2.2:8000'
          : 'http://127.0.0.1:8000';

      final res = await http.get(
        Uri.parse('$url/api/v1/quiz/${widget.quizId}'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (mounted) {
          setState(() {
            _title = data['title'];
            _questions = (data['questions'] as List)
                .map((e) => QuestionModel.fromJson(e))
                .toList();
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      debugPrint("Error fetching quiz: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  int _calculateScore() {
    int score = 0;
    for (int i = 0; i < _questions.length; i++) {
      if (_userAnswers[i] == _questions[i].correctAnswer) {
        score++;
      }
    }
    return score;
  }

  Future<void> _saveAttempt(int score) async {
    try {
      final token = await storage.read(key: 'jwt_token');
      final url = Platform.isAndroid
          ? 'http://10.0.2.2:8000'
          : 'http://127.0.0.1:8000';

      final res = await http.post(
        Uri.parse('$url/api/v1/quiz/submit'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'quiz_id': widget.quizId,
          'score': score,
          'total_questions': _questions.length,
        }),
      );

      if (res.statusCode != 200) {
        debugPrint("Failed to save attempt: ${res.body}");
      }
    } catch (e) {
      debugPrint("Error saving attempt: $e");
    }
  }

  Future<void> _submitQuiz() async {
    int finalScore = _calculateScore();
    setState(() => _isSubmitted = true);

    // Save to backend
    await _saveAttempt(finalScore);

    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              Icon(Icons.emoji_events, color: Colors.orange),
              SizedBox(width: 8),
              Text("สรุปคะแนน"),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "$finalScore / ${_questions.length}",
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 8),
              const Text("เก่งมาก! บันทึกคะแนนของคุณเรียบร้อยแล้ว"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // ปิดแค่ Dialog เพื่อให้ดูเฉลยได้ต่อ
              },
              child: const Text(
                "ดูเฉลย",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(_title)),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _questions.length,
              itemBuilder: (context, qIndex) {
                final q = _questions[qIndex];
                return _buildQuestionCard(q, qIndex);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isSubmitted
                    ? () => Navigator.pop(context, true)
                    : _submitQuiz,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isSubmitted
                      ? Colors.redAccent
                      : Colors.blueAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  _isSubmitted ? "ออกจากการฝึก" : "ส่งข้อสอบ",
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(QuestionModel q, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "ข้อที่ ${index + 1}: ${q.questionText}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...q.options.map((option) {
              bool isSelected = _userAnswers[index] == option;
              bool isCorrect = q.correctAnswer == option;

              Color getColor() {
                if (!_isSubmitted) {
                  return isSelected ? Colors.blueAccent : Colors.black87;
                }
                if (isCorrect) return Colors.green;
                if (isSelected && !isCorrect) return Colors.red;
                return Colors.grey;
              }

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: getColor(),
                    width: isSelected || (_isSubmitted && isCorrect) ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  color: isSelected ? getColor().withOpacity(0.1) : null,
                ),
                child: RadioListTile<String>(
                  title: Text(
                    option,
                    style: TextStyle(
                      color: getColor(),
                      fontWeight: isSelected ? FontWeight.bold : null,
                    ),
                  ),
                  value: option,
                  groupValue: _userAnswers[index],
                  activeColor: getColor(),
                  onChanged: _isSubmitted
                      ? null
                      : (val) {
                          setState(() => _userAnswers[index] = val!);
                        },
                ),
              );
            }),
            if (_isSubmitted) ...[
              const Divider(height: 32),
              const Text(
                "คำอธิบาย:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                q.explanation,
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
