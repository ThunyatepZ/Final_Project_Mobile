import 'package:app/component_/buttom_nav.dart';
import 'package:flutter/material.dart';

class QApage extends StatefulWidget {
  const QApage({super.key});

  @override
  State<QApage> createState() => _QApageState();
}

class _QApageState extends State<QApage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 1),
      body: const Center(child: Text("QA Page")),
    );
  }
}
