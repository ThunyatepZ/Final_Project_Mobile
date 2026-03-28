import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class CreateQuizPage extends StatefulWidget {
  const CreateQuizPage({super.key});

  @override
  State<CreateQuizPage> createState() => _CreateQuizPageState();
}

class _CreateQuizPageState extends State<CreateQuizPage> {
  final List<File> _selectedFiles = [];
  bool _isUploading = false;
  final storage = const FlutterSecureStorage();

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'txt'],
      allowMultiple: true,
    );

    if (result != null) {
      setState(() {
        _selectedFiles.addAll(result.paths.map((path) => File(path!)).toList());
      });
    }
  }

  Future<void> _uploadAndGenerate() async {
    if (_selectedFiles.isEmpty) return;

    setState(() => _isUploading = true);

    try {
      final token = await storage.read(key: 'jwt_token');
      final url = Platform.isAndroid
          ? 'http://10.0.2.2:8000'
          : 'http://127.0.0.1:8000';

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$url/api/v1/quiz/generate'),
      );
      request.headers['Authorization'] = 'Bearer $token';

      for (var file in _selectedFiles) {
        request.files.add(
          await http.MultipartFile.fromPath('files', file.path),
        );
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('สร้างข้อสอบสำเร็จ!')));
          Navigator.pop(context, true); // Return true to refresh list
        }
      } else {
        debugPrint("Upload failed: ${response.body}");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('เกิดข้อผิดพลาด: ${response.statusCode}')),
          );
        }
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("สร้างคลังข้อสอบใหม่")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.picture_as_pdf_outlined,
                size: 80,
                color: Colors.blueAccent,
              ),
              const SizedBox(height: 16),
              const Text(
                "อัปโหลดไฟล์ (PDF/Text) เพื่อเริ่มสร้างแบบฝึกหัด",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 32),
              if (_selectedFiles.isNotEmpty) ...[
                Container(
                  constraints: const BoxConstraints(maxHeight: 150),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _selectedFiles.length,
                    itemBuilder: (context, index) {
                      final file = _selectedFiles[index];
                      return ListTile(
                        leading: const Icon(
                          Icons.file_present,
                          color: Colors.green,
                        ),
                        title: Text(
                          file.path.split('/').last,
                          style: const TextStyle(fontSize: 14),
                        ),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.remove_circle_outline,
                            color: Colors.red,
                          ),
                          onPressed: () =>
                              setState(() => _selectedFiles.removeAt(index)),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
              ],
              ElevatedButton.icon(
                onPressed: _pickFile,
                icon: const Icon(Icons.file_upload),
                label: const Text("เลือกไฟล์จากเครื่อง"),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
              const SizedBox(height: 16),
              if (_selectedFiles.isNotEmpty)
                ElevatedButton(
                  onPressed: _isUploading ? null : _uploadAndGenerate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: _isUploading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("เริ่มสร้างแบบฝึกหัดของคุณ"),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
