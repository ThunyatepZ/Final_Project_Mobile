import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:app/component_/buttom_nav.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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

  Future<void> _fetchPathProgress(Map<String, dynamic> path) async {
    try {
      final token = await secureStorage.read(key: 'jwt_token');
      if (token == null || token.isEmpty) return;

      final String baseUrl = Platform.isAndroid
          ? 'http://10.0.2.2:8000'
          : 'http://127.0.0.1:8000';

      final res = await http.get(
        Uri.parse('$baseUrl/api/v1/learning-path/progress/${path['id']}'),
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

      final lessons = path['lessons'] as List;
      for (final lesson in lessons) {
        final title = lesson['title'] as String;
        lesson['isCompleted'] = completedLessons.contains(title);
      }

      final int completedCount = lessons
          .where((l) => l['isCompleted'] == true)
          .length;

      path['completedCourses'] = completedCount;
      path['progress'] = lessons.isEmpty
          ? 0.0
          : (completedCount / lessons.length).clamp(0.0, 1.0);
      path['isEnrolled'] = isEnrolled;
    } catch (e) {
      debugPrint("Error fetching path progress for id ${path['id']}: $e");
    }
  }

  Future<bool> _saveProgressToServer(Map<String, dynamic> path) async {
    try {
      final token = await secureStorage.read(key: 'jwt_token');
      if (token == null || token.isEmpty) return false;

      final String baseUrl = Platform.isAndroid
          ? 'http://10.0.2.2:8000'
          : 'http://127.0.0.1:8000';

      final lessons = path['lessons'] as List;
      final completedTitles = lessons
          .where((l) => l['isCompleted'] == true)
          .map<String>((l) => l['title'] as String)
          .toList();

      final response = await http.post(
        Uri.parse('$baseUrl/api/v1/learning-path/progress'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'path_id': path['id'],
          'completed_lessons': completedTitles,
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint("Error saving path progress for id ${path['id']}: $e");
      return false;
    }
  }

  final List<Map<String, dynamic>> _paths = [
    {
      "id": "1",
      "title": "Mobile Developer (Flutter)",
      "description":
          "เส้นทางสู่การเป็นนักพัฒนาแอปมือถือ เริ่มตั้งแต่พื้นฐาน Dart ไปจนถึงการสร้างแอปด้วย Flutter",
      "progress": 0.0,
      "isEnrolled": false,
      "totalCourses": 6,
      "completedCourses": 0,
      "color": Colors.blueAccent,
      "icon": Icons.phone_iphone_rounded,
      "lessons": [
        {
          "title": "บทที่ 1: ทำความรู้จักกับ Dart",
          "content":
              "Dart เป็นภาษาโปรแกรมที่พัฒนาโดย Google ถูกเปิดตัวครั้งแรกในปี 2011 โดยมีเป้าหมายเริ่มต้นคือการนำมาแทนที่ JavaScript แต่ต่อมาได้ปรับสถาปัตยกรรมใหม่เพื่อให้เหมาะกับการสร้าง Client-side Applications อย่าง Mobile, Web, และ Desktop\n\nจุดเด่นของ Dart ที่เหนือกว่าภาษาอื่น:\n1. JIT (Just-In-Time) Compilation: เวลาคุณเขียนโค้ดและกด Save ระบบจะทำงานทันทีผ่านฟีเจอร์ที่เรียกว่า 'Hot Reload' ทำให้เห็นการเปลี่ยนแปลงของ UI สดๆ โดยไม่ต้องรันแอปใหม่\n2. AOT (Ahead-Of-Time) Compilation: เมื่อคุณพร้อมนำแอปขึ้น Store ตัว Dart จะถูกแปลงเป็น Machine Code ทำให้แอปทำงานได้เร็วในระดับ Native Performance\n3. Sound Null Safety: เป็นฟีเจอร์ความปลอดภัยที่ป้องกันไม่ให้เกิด Error ประเภท Null Reference Exception ซึ่งเป็นบั๊กยอดฮิตในสาย Mobile Development\n\nเวลาเขียน Dart ทุกโปรแกรมจะต้องเริ่มทำงานที่ฟังก์ชัน `main()` เสมอ",
          "codeSnippet":
              "// ฟังก์ชัน main คือจุดเริ่มต้น (Entry Point) ของทุกโปรแกรมใน Dart\nvoid main() {\n  // ฟังก์ชัน print() ใช้สำหรับแสดงผลข้อความออกทาง Console\n  print('Hello, Welcome to Dart!');\n  \n  int year = 2024;\n  // การแทรกตัวแปรลงใน String (String Interpolation)\n  print('This year is \$year');\n}",
          "isCompleted": false,
        },
        {
          "title": "บทที่ 2: ตัวแปรประเภทต่างๆ และฟังก์ชัน",
          "content":
              "Dart เป็นภาษาประเภท Strongly Typed หมายความว่าทุกตัวแปรจะต้องมีประเภทข้อมูล (Data Type) ที่ชัดเจน แต่ Dart ก็ฉลาดพอที่จะเดา Type ให้เราผ่านคำว่า 'var'\n\nหลักการประกาศตัวแปร:\n- var: ให้คอมไพเลอร์เดาประเภทเอง (ใช้ได้ครั้งเดียว เปลี่ยน type กลางทางไม่ได้)\n- final: กำหนดค่าได้ครั้งเดียว (ถูกเซ็ตตอน Runtime)\n- const: เป็นค่าคงที่ตั้งแต่ก่อนรันแอป (Compile-time constant)\n\nประเภทข้อมูลพื้นฐาน (Primitive Types):\n- int (จำนวนเต็ม), double (ทศนิยม)\n- String (ข้อความ), bool (true/false)\n\nส่วนฟังก์ชัน เป็นการจัดกลุ่มชุดคำสั่งเพื่อให้นำกลับมาเรียกใช้ซ้ำได้ง่าย ฟังก์ชันที่ดีควรมีการระบุการคืนค่า (Return Type) ให้ชัดเจน",
          "codeSnippet":
              "// 1. การสร้างฟังก์ชันแบบตั้งชื่อเต็มรูปแบบ\n// รับค่า birthYear (int) และคืนค่าอายุ (int)\nint calculateAge(int birthYear) {\n  // final ประเมินค่าตอนรัน\n  final int currentYear = DateTime.now().year;\n  return currentYear - birthYear;\n}\n\n// 2. ฟังก์ชันแบบย่อ (Arrow Function) \n// ใช้ได้ในกรณีที่ฟังก์ชันมีแค่ 1 บรรทัด\nbool isAdult(int age) => age >= 18;\n\nvoid main() {\n  // การใช้ var\n  var name = 'Somchai'; // Dart รู้ว่าเป็น String\n  \n  // การเรียกใช้ฟังก์ชัน\n  int myAge = calculateAge(2000);\n  \n  if (isAdult(myAge)) {\n    print('\$name เป็นผู้ใหญ่แล้ว เพราะอายุ \$myAge ปี');\n  } else {\n    print('\$name ยังเป็นเด็ก');\n  }\n}",
          "isCompleted": false,
        },
        {
          "title": "บทที่ 3: Object-Oriented Programming (OOP)",
          "content":
              "Everything is an Object (ทุกสิ่งทุกอย่างคือออบเจ็กต์) คือหัวใจหลักของภาษา Dart แม้แต่ตัวเลขหรือข้อความเปล่าๆ ก็ล้วนสืบทอดมาจากคลาส Object\n\nความเข้าใจ OOP จำเป็นมากเวลาที่คุณเขียน Flutter เพราะทุก Widget หรือกล่องหน้าจอที่คุณสร้าง คือการสร้าง Object ขึ้นมา\n\nคอนเซ็ปต์หลัก:\n1. Class (คลาส) - เป็นพิมพ์เขียว (Blueprint)\n2. Object (ออบเจ็กต์) - สิ่งที่ถูกสร้างจากพิมพ์เขียว\n3. Inheritance (การสืบทอดลักษณะ) - การใช้คำสั่ง 'extends' เพื่อดึงความสามารถจากอีกคลาสมาใช้ เพื่อลดการเขียนโค้ดซ้ำ",
          "codeSnippet":
              "// การสร้างพิมพ์เขียวชื่อ Animal\nclass Animal {\n  String name; // ตัวแปรในคลาสเรียกว่า Property\n  \n  // Constructor สำหรับกำหนดค่าเริ่มต้น\n  Animal(this.name);\n\n  // ฟังก์ชันในคลาสเรียกว่า Method\n  void speak() {\n    print('\$name makes a generalized sound.');\n  }\n}\n\n// การสืบทอด (Inheritance) ด้วย extends\nclass Dog extends Animal {\n  // ส่ง constructor กลับไปให้คลาสแม่ (super)\n  Dog(String name) : super(name);\n\n  // Polymorphism: การ override method\n  @override\n  void speak() {\n    print('\$name says: Woof! Woof!');\n  }\n}\n\n\nvoid main() {\n  // การสร้าง Object (Instantiating)\n  var genericAnimal = Animal('Unknown');\n  var myDog = Dog('Buddy');\n\n  genericAnimal.speak();\n  myDog.speak();\n}",
          "isCompleted": false,
        },
        {
          "title": "บทที่ 4: Hello Flutter วิดเจ็ตคืออะไร?",
          "content":
              "ลบความรู้เกี่ยวกับการเขียน UI แบบภาษาอื่นๆ ทิ้งไปได้เลยครับ เพราะใน Flutter \"Everything is a Widget\" (ทุกอย่างคือวิดเจ็ต)\n\nWidget คือชิ้นส่วนเล็กๆ ที่ถูกนำมาประกอบร่างกันเป็นหน้าจอ ไม่ว่าจะเป็น ปุ่ม (Button), ข้อความ (Text), ช่องว่าง (Padding), และแม้กระทั่งตัวจัดการแกนการจัดเรียง (Center) ก็ล้วนเป็น Widget ทั้งสิ้น\n\nโครงสร้างแอป Flutter จะเป็นโครงสร้างต้นไม้ (Widget Tree) โดยมีราก (Root) และแผ่กิ่งก้านสาขาลงมา",
          "codeSnippet":
              "import 'package:flutter/material.dart';\n\n// รันแอปเริ่มต้น\nvoid main() {\n  runApp(const MyApp());\n}\n\n// สร้าง Widget ตัวแม่สุด\nclass MyApp extends StatelessWidget {\n  const MyApp({super.key});\n\n  @override\n  // build คือเมธอดที่จะถูกเรียกเพื่อวาดหน้าจอ\n  Widget build(BuildContext context) {\n    return MaterialApp(\n      title: 'Hello Flutter',\n      // Scaffold คือโครงสร้างหน้าแอปมาตรฐาน (มี Appbar, Body, BottomNav)\n      home: Scaffold(\n        appBar: AppBar(\n          title: const Text('แอปแรกของฉัน'),\n          backgroundColor: Colors.blueAccent,\n        ),\n        body: const Center(\n          // Text เป็น Widget ที่อยู่ตรงกลางหน้าจอ\n          child: Text(\n            'Hello, World!',\n            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),\n          ),\n        ),\n      ),\n    );\n  }\n}",
          "isCompleted": false,
        },
        {
          "title": "บทที่ 5: การจัด Layout ชั้นสูง (Row & Column)",
          "content":
              "ตอนนี้คุณแสดงข้อความ 1 ชิ้นได้แล้ว แต่ถ้าในหน้าจอมีข้อความ 10 ชิ้นล่ะ? นี่คือจุดที่ Layout Widgets เข้ามามีบทบาท\n\n- Column: เรียงของจาก 'บนลงล่าง'\n- Row: เรียงของจาก 'ซ้ายไปขวา'\n\nเคล็ดลับ: แกนหลักของมันเรียกว่า MainAxis ส่วนแกนตั้งฉากเรียกว่า CrossAxis\nตัวอย่างเช่น สำหรับ Column, แกน Main ของมันคือแนวดิ่ง (บน-ล่าง) แต่ถ้าคุณอยากให้มันอยู่ตรงกลางในแนวนอน คุณต้องใช้ CrossAxisAlignment.center",
          "codeSnippet":
              "import 'package:flutter/material.dart';\n\nclass LayoutExample extends StatelessWidget {\n  @override\n  Widget build(BuildContext context) {\n    return Scaffold(\n      appBar: AppBar(title: Text('Layout Demo')),\n      body: Container(\n        width: double.infinity, // สั่งให้กว้างเต็มจอ\n        padding: const EdgeInsets.all(20),\n        child: Column(\n          // เรียงจากบนลงล่าง ให้อยู่ตรงกลาง\n          mainAxisAlignment: MainAxisAlignment.center,\n          // ให้อยู่ตรงกลางบรรทัดในแนวนอน\n          crossAxisAlignment: CrossAxisAlignment.center,\n          children: [\n            const Text(\n              'Profile Card',\n              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),\n            ),\n            const SizedBox(height: 20), // ตัวดันช่องว่าง\n            \n            // กล่องโปรไฟล์ที่ใช้ Row จัดเรียง\n            Container(\n              padding: const EdgeInsets.all(16),\n              color: Colors.blue.shade50,\n              child: Row(\n                children: [\n                  const CircleAvatar(\n                    radius: 30,\n                    child: Icon(Icons.person),\n                  ),\n                  const SizedBox(width: 16),\n                  Expanded(\n                    // Expanded สั่งให้กินพื้นที่ที่เหลือทั้งหมดในแนวนอน\n                    child: Column(\n                      crossAxisAlignment: CrossAxisAlignment.start,\n                      children: const [\n                        Text('Somchai Dev', style: TextStyle(fontSize: 18)),\n                        Text('Mobile Developer', style: TextStyle(color: Colors.grey)),\n                      ],\n                    ),\n                  ),\n                ],\n              ),\n            ),\n          ],\n        ),\n      ),\n    );\n  }\n}",
          "isCompleted": false,
        },
        {
          "title": "บทที่ 6: การทำให้แอปมีชีวิตชีวา (StatefulWidget)",
          "content":
              "หน้าแอปทั้งหมดที่คุณสร้างมาใน 2 บทก่อนคือ 'StatelessWidget' ซึ่งแปลว่า \"วิดเจ็ตที่ไม่มีการเปลี่ยนแปลงสถานะ\" วาดแล้วจบกัน\n\nแต่ถ้าคุณต้องการแอปที่ กดปุ่มแล้วตัวเลขขึ้น, พิมพ์ข้อความแล้วอัปเดตแบบเรียลไทม์ หรือรับข้อมูลจาก API คุณต้องใช้ 'StatefulWidget'\n\nพาร์ทเนอร์ที่สำคัญที่สุดของตัวนี้คือคำสั่ง `setState(() {})` ทันทีที่คุณเรียกคำสั่งนี้ Flutter จะสั่งทำลายหน้าจอเก่า และวาดหน้าจอใหม่ทันทีโดยดึงข้อมูลใหม่ไปโชว์ นี่แหละคือเวทมนตร์ของศาสตร์ Reactive Programming",
          "codeSnippet":
              "import 'package:flutter/material.dart';\n\n// คลาสหลักที่เรียกขอลูกที่เป็น State ออกมา\nclass CounterBox extends StatefulWidget {\n  const CounterBox({super.key});\n\n  @override\n  State<CounterBox> createState() => _CounterBoxState();\n}\n\n// คลาส State จะเป็นตัวเก็บข้อมูลของจริง\nclass _CounterBoxState extends State<CounterBox> {\n  // ข้อมูลที่เปลี่ยนไปมาได้ (State)\n  int _count = 0;\n\n  void _incrementCounter() {\n    // นี่คือพระเอก สั่ง setState\n    // จังหวะนี้ Build() ด้านล่างจะถูกเรียกซ้ำทันที!\n    setState(() {\n      _count++;\n    });\n  }\n\n  @override\n  Widget build(BuildContext context) {\n    return Center(\n      child: Column(\n        mainAxisAlignment: MainAxisAlignment.center,\n        children: [\n          Text(\n            'You pressed the button this many times:',\n            style: TextStyle(fontSize: 16),\n          ),\n          Text(\n            '\$_count',\n            style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.blueAccent),\n          ),\n          const SizedBox(height: 20),\n          ElevatedButton.icon(\n            icon: const Icon(Icons.add),\n            label: const Text('Add Number'),\n            onPressed: _incrementCounter,\n          )\n        ],\n      ),\n    );\n  }\n}",
          "isCompleted": false,
        },
      ],
    },
    {
      "id": "2",
      "title": "Backend Developer (Go Lang)",
      "description":
          "เส้นทางสู่การเป็นนักพัฒนา Backend ด้วย Go เริ่มตั้งแต่พื้นฐานภาษา ไปจนถึงการสร้าง REST API และเชื่อมต่อฐานข้อมูล",
      "progress": 0.0,
      "isEnrolled": false,
      "totalCourses": 6,
      "completedCourses": 0,
      "color": Colors.teal,
      "icon": Icons.storage_rounded,
      "lessons": [
        {
          "title": "บทที่ 1: ทำความรู้จักกับ Go",
          "content":
              "Go (หรือ Golang) เป็นภาษาโปรแกรมที่ถูกพัฒนาโดย Google ในปี 2009 จุดประสงค์หลักคือสร้างภาษาที่มีประสิทธิภาพสูง แต่เขียนง่ายเหมือนภาษา Script\n\nGo ได้รับความนิยมมากในสาย Backend, Cloud Infrastructure และ Microservices เพราะมีความเร็วระดับ Compiled Language แต่ Syntax เรียบง่าย\n\nจุดเด่นของ Go:\n1. Compile เร็วมาก\n2. Syntax เรียบง่าย\n3. มีระบบ Concurrency ที่ทรงพลัง (Goroutine)\n4. เหมาะกับการทำ Server และ API\n\nทุกโปรแกรมใน Go จะเริ่มทำงานจากฟังก์ชัน `main()` ภายใน package main",
          "codeSnippet":
              "package main\n\nimport \"fmt\"\n\n// main คือ entry point ของโปรแกรม\nfunc main() {\n\n    fmt.Println(\"Hello, Welcome to Go!\")\n\n    year := 2024\n    fmt.Println(\"This year is\", year)\n}",
          "isCompleted": false,
        },
        {
          "title": "บทที่ 2: ตัวแปรและประเภทข้อมูล",
          "content":
              "Go เป็นภาษาแบบ Strongly Typed หมายความว่าตัวแปรต้องมีประเภทข้อมูลที่ชัดเจน\n\nGo มีวิธีประกาศตัวแปร 2 แบบหลัก:\n\n1. แบบระบุ type\n2. แบบ shorthand `:=`\n\nประเภทข้อมูลพื้นฐาน:\n- int (จำนวนเต็ม)\n- float64 (ทศนิยม)\n- string (ข้อความ)\n- bool (true / false)\n\nGo ไม่มี class แบบ OOP แต่มี struct ซึ่งใช้เก็บข้อมูลหลายตัวรวมกัน",
          "codeSnippet":
              "package main\n\nimport \"fmt\"\n\nfunc main() {\n\n    // แบบกำหนด type\n    var name string = \"Somchai\"\n\n    // shorthand\n    age := 22\n\n    var isStudent bool = true\n\n    fmt.Println(\"Name:\", name)\n    fmt.Println(\"Age:\", age)\n    fmt.Println(\"Student:\", isStudent)\n}",
          "isCompleted": false,
        },
        {
          "title": "บทที่ 3: Function และ Control Flow",
          "content":
              "Function ใน Go ใช้สำหรับจัดกลุ่มคำสั่งเพื่อให้เรียกใช้งานซ้ำได้ง่าย\n\nรูปแบบของฟังก์ชัน:\nfunc functionName(parameter type) returnType\n\nGo รองรับการคืนค่าหลายค่า (Multiple Return Values) ซึ่งนิยมใช้ในการส่ง error กลับมา\n\nControl Flow ที่สำคัญ:\n- if / else\n- for loop\n- switch",
          "codeSnippet":
              "package main\n\nimport \"fmt\"\n\nfunc calculateAge(birthYear int) int {\n\n    currentYear := 2024\n\n    return currentYear - birthYear\n}\n\nfunc main() {\n\n    age := calculateAge(2000)\n\n    if age >= 18 {\n        fmt.Println(\"You are an adult\")\n    } else {\n        fmt.Println(\"You are underage\")\n    }\n}",
          "isCompleted": false,
        },
        {
          "title": "บทที่ 4: Struct และ Method",
          "content":
              "Go ไม่มี Class แบบภาษา OOP แต่ใช้ Struct แทน\n\nStruct คือโครงสร้างข้อมูลที่รวมหลาย field ไว้ด้วยกัน เช่น name, age, email\n\nเราสามารถเพิ่ม Method ให้กับ Struct ได้ ซึ่งทำให้โค้ดมีโครงสร้างคล้าย Object-Oriented Programming",
          "codeSnippet":
              "package main\n\nimport \"fmt\"\n\n// สร้าง struct\n\ntype User struct {\n\n    Name string\n    Age  int\n}\n\n// method ของ struct\n\nfunc (u User) introduce() {\n\n    fmt.Println(\"Hello my name is\", u.Name)\n}\n\nfunc main() {\n\n    user := User{\n        Name: \"Somchai\",\n        Age:  22,\n    }\n\n    user.introduce()\n}",
          "isCompleted": false,
        },
        {
          "title": "บทที่ 5: Goroutine และ Concurrency",
          "content":
              "หนึ่งในจุดเด่นที่สุดของ Go คือระบบ Concurrency\n\nGo ใช้สิ่งที่เรียกว่า Goroutine ซึ่งเป็น Thread ที่มีน้ำหนักเบามาก ทำให้สามารถรันหลายงานพร้อมกันได้\n\nการสร้าง Goroutine ทำได้ง่ายมาก เพียงแค่ใส่คำว่า `go` หน้าฟังก์ชัน\n\nสิ่งที่ใช้สื่อสารระหว่าง Goroutine คือ Channel",
          "codeSnippet":
              "package main\n\nimport (\n    \"fmt\"\n    \"time\"\n)\n\nfunc sayHello() {\n\n    fmt.Println(\"Hello from Goroutine\")\n}\n\nfunc main() {\n\n    go sayHello()\n\n    fmt.Println(\"Main function\")\n\n    time.Sleep(time.Second)\n}",
          "isCompleted": false,
        },
        {
          "title": "บทที่ 6: การสร้าง REST API ด้วย Go",
          "content":
              "Go ถูกใช้สร้าง Backend API ได้ดีมาก เพราะมี HTTP Server built-in อยู่ใน Standard Library\n\nแพ็กเกจ `net/http` ช่วยให้เราสร้าง Web Server ได้ง่าย\n\nFlow การทำ API:\n1. สร้าง handler function\n2. map route\n3. start server\n\nFramework ที่นิยมใน Go เช่น Gin, Fiber และ Echo",
          "codeSnippet":
              "package main\n\nimport (\n    \"fmt\"\n    \"net/http\"\n)\n\nfunc helloHandler(w http.ResponseWriter, r *http.Request) {\n\n    fmt.Fprintf(w, \"Hello from Go API\")\n}\n\nfunc main() {\n\n    http.HandleFunc(\"/hello\", helloHandler)\n\n    fmt.Println(\"Server running on :8080\")\n\n    http.ListenAndServe(\":8080\", nil)\n}",
          "isCompleted": false,
        },
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          "เส้นทางการเรียนรู้",
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
                            "เลือกเส้นทางที่ใช่\nไปให้ถึงเป้าหมาย",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "เรียนรู้ตามลำดับขั้นตอนที่ออกแบบมาอย่างดี เพื่อให้คุณเก่งขึ้นอย่างก้าวกระโดด",
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

  Widget _buildPathCard(Map<String, dynamic> path) {
    final bool isEnrolled = path['isEnrolled'] == true;

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
                    color: (path['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(path['icon'], color: path['color'], size: 30),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        path['title'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        path['description'],
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
                          ? "เรียนไปแล้ว ${path['completedCourses']}/${path['totalCourses']} คอร์ส"
                          : "ทั้งหมด ${path['totalCourses']} คอร์ส",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    Text(
                      "${(path['progress'] * 100).toInt()}%",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: path['color'],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: path['progress'],
                    backgroundColor: Colors.grey.shade200,
                    color: path['color'],
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
                              pathData: path,
                              onProgressUpdated: () => setState(() {}),
                            ),
                          ),
                        );
                      } else {
                        _enrollPath(path);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isEnrolled
                          ? path['color']
                          : Colors.black87,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      isEnrolled ? "เรียนต่อ" : "สมัครเรียนเส้นทางนี้",
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

  Future<void> _enrollPath(Map<String, dynamic> path) async {
    setState(() {
      path['isEnrolled'] = true;
    });
    final bool didSave = await _saveProgressToServer(path);
    if (!didSave) {
      if (!mounted) return;
      setState(() {
        path['isEnrolled'] = false;
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
          "สมัครเรียนแผนการเรียน\n「${path['title']}」 สำเร็จ!\nระบบได้อัปเดตสถานะของคุณแล้ว",
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
  final Map<String, dynamic> pathData;
  final VoidCallback onProgressUpdated;

  const LearningPathDetailPage({
    super.key,
    required this.pathData,
    required this.onProgressUpdated,
  });

  @override
  State<LearningPathDetailPage> createState() => _LearningPathDetailPageState();
}

class _LearningPathDetailPageState extends State<LearningPathDetailPage> {
  final FlutterSecureStorage _detailStorage = const FlutterSecureStorage();

  Future<void> _updateProgress() async {
    final lessons = widget.pathData['lessons'] as List;
    int completed = lessons.where((l) => l['isCompleted'] == true).length;

    setState(() {
      widget.pathData['completedCourses'] = completed;
      widget.pathData['progress'] = (completed / lessons.length).clamp(
        0.0,
        1.0,
      );
      widget.pathData['isEnrolled'] = true;
    });
    widget.onProgressUpdated();
    await _saveProgressToServer(widget.pathData);
  }

  Future<void> _saveProgressToServer(Map<String, dynamic> path) async {
    try {
      final token = await _detailStorage.read(key: 'jwt_token');
      if (token == null || token.isEmpty) return;

      final String baseUrl = Platform.isAndroid
          ? 'http://10.0.2.2:8000'
          : 'http://127.0.0.1:8000';

      final lessons = path['lessons'] as List;
      final completedTitles = lessons
          .where((l) => l['isCompleted'] == true)
          .map<String>((l) => l['title'] as String)
          .toList();

      await http.post(
        Uri.parse('$baseUrl/api/v1/learning-path/progress'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'path_id': path['id'],
          'completed_lessons': completedTitles,
        }),
      );
    } catch (e) {
      debugPrint("Error saving detail path progress for id ${path['id']}: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final path = widget.pathData;
    final color = path['color'] as Color;
    final lessons = path['lessons'] as List;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          path['title'],
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
          final bool isCompleted = lesson['isCompleted'];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isCompleted
                    ? color.withOpacity(0.5)
                    : Colors.grey.shade200,
                width: isCompleted ? 2 : 1,
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
                backgroundColor: isCompleted ? color : Colors.grey.shade200,
                child: Icon(
                  isCompleted ? Icons.check_rounded : Icons.lock_open_rounded,
                  color: isCompleted ? Colors.white : Colors.grey.shade600,
                ),
              ),
              title: Text(
                lesson['title'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isCompleted ? Colors.black87 : Colors.black54,
                ),
              ),
              subtitle: Text(
                isCompleted ? "เรียนจบแล้ว" : "ยังไม่ได้เรียน",
                style: TextStyle(
                  color: isCompleted ? color : Colors.grey,
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
                      lessonTitle: lesson['title'],
                      lessonContent: lesson['content'],
                      codeSnippet: lesson['codeSnippet'],
                      color: color,
                      isCompleted: isCompleted,
                      onMarkComplete: () {
                        setState(() => lesson['isCompleted'] = true);
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
