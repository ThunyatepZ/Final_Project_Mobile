import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'package:app/component_/buttom_nav.dart';

class QApage extends StatefulWidget {
  const QApage({super.key});

  @override
  State<QApage> createState() => _QApageState();
}

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}

class _QApageState extends State<QApage> {
  final TextEditingController _controller = TextEditingController();
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  final ScrollController _scrollController = ScrollController();

  bool _isLoading = false;
  List<PlatformFile> _selectedFiles = [];

  final List<ChatMessage> _messages = [
    ChatMessage(
      text:
          "สวัสดีครับ มีอะไรให้ผมช่วยไหมครับ? \n สามารถอัพโหลดไฟล์เพื่อสอบถามได้ครับ",
      isUser: false,
    ),
  ];

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'txt', 'md', 'csv', 'json'],
      withData: true,
      allowMultiple: true,
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _selectedFiles.addAll(result.files);
      });
    }
  }

  Future<void> _handleSendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty && _selectedFiles.isEmpty) return;

    final selectedFiles = List<PlatformFile>.from(_selectedFiles);
    String displayMessage = text;
    if (selectedFiles.isNotEmpty) {
      final fileNames = selectedFiles.map((f) => f.name).join(', ');
      displayMessage = text.isEmpty
          ? "[ไฟล์แบบแนบ: $fileNames]"
          : "$text\n[ไฟล์แนบ: $fileNames]";
    }

    _addUserMessage(displayMessage);
    _controller.clear();

    setState(() {
      _isLoading = true;
      _selectedFiles = [];
    });
    _scrollToBottom();

    final answer = await _getAnswerFromAPI(text, selectedFiles);

    if (mounted) {
      setState(() {
        _isLoading = false;
        _addBotMessage(answer);
      });
      _scrollToBottom();
    }
  }

  void _addUserMessage(String text) {
    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
    });
  }

  void _addBotMessage(String text) {
    setState(() {
      _messages.add(ChatMessage(text: text, isUser: false));
    });
  }

  Future<String> _getAnswerFromAPI(
    String question,
    List<PlatformFile> files,
  ) async {
    try {
      final url = Platform.isAndroid
          ? 'http://10.0.2.2:8000'
          : 'http://127.0.0.1:8000';

      final token = await storage.read(key: 'jwt_token');
      if (token == null || token.isEmpty) {
        return "ไม่พบ token สำหรับการยืนยันตัวตน";
      }

      final request =
          http.MultipartRequest(
              'POST',
              Uri.parse('$url/api/v1/chat/ask-upload'),
            )
            ..headers['Authorization'] = 'Bearer $token'
            ..fields['question'] = question;

      for (var file in files) {
        if (file.bytes != null) {
          request.files.add(
            http.MultipartFile.fromBytes(
              'files',
              file.bytes!,
              filename: file.name,
            ),
          );
        } else if (file.path != null) {
          request.files.add(
            await http.MultipartFile.fromPath('files', file.path!),
          );
        }
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return data['answer'] ?? "ไม่พบคำตอบ";
      }

      String errorMessage = "";
      try {
        final errorData = jsonDecode(utf8.decode(response.bodyBytes));
        errorMessage = errorData['detail']?.toString() ?? "";
      } catch (_) {
        errorMessage = response.body;
      }

      return "ขออภัยครับ เกิดปัญหาจาก Server: HTTP ${response.statusCode} ${errorMessage.isNotEmpty ? '- $errorMessage' : ''}";
    } catch (e) {
      return "ขออภัยครับ เกิดปัญหาขัดข้อง: $e";
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: message.isUser ? Colors.blueAccent : Colors.grey[200],
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(message.isUser ? 16 : 0),
            bottomRight: Radius.circular(message.isUser ? 0 : 16),
          ),
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: message.isUser ? Colors.white : Colors.black87,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedFilesPreview() {
    if (_selectedFiles.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      constraints: const BoxConstraints(maxHeight: 120),
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blueAccent.withValues(alpha: 0.35)),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: _selectedFiles.length,
        itemBuilder: (context, index) {
          final file = _selectedFiles[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                const Icon(
                  Icons.attach_file,
                  color: Colors.blueAccent,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    file.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, color: Colors.black87),
                  ),
                ),
                InkWell(
                  onTap: () => setState(() => _selectedFiles.removeAt(index)),
                  child: const Icon(
                    Icons.close,
                    size: 16,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Learner Assistant",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 2),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.only(top: 16, bottom: 8),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessageBubble(_messages[index]);
              },
            ),
          ),
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                children: [
                  const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "ผู้ช่วยกำลังค้นหาคำตอบ...",
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                ],
              ),
            ),
          _buildSelectedFilesPreview(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(
                    onPressed: _isLoading ? null : _pickFile,
                    icon: const Icon(Icons.attach_file),
                    color: Colors.blueAccent,
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          hintText: "พิมพ์คำถามของคุณ...",
                          border: InputBorder.none,
                        ),
                        onSubmitted: (_) => _handleSendMessage(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: _isLoading ? null : _handleSendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
