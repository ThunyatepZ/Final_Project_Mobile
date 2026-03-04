import 'package:app/component_/buttom_nav.dart';
import 'package:app/Detail.page.dart';
import 'package:app/Model/course.model.dart';
import 'package:flutter/material.dart';
import 'package:app/products/course.product.dart';

class Coursepage extends StatefulWidget {
  const Coursepage({super.key});

  @override
  State<Coursepage> createState() => _CoursepageState();
}

class _CoursepageState extends State<Coursepage> {
  final product = CourseProduct();
  String selectedFilter = "ทั้งหมด";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Text(
                "วิชาเรียน",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                "หลักสูตรวิทยาการคอมพิวเตอร์",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 20),

              // Search Bar
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: "ค้นหาวิชา...",
                    hintStyle: TextStyle(color: Colors.grey),
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Filters
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip("ทั้งหมด"),
                    const SizedBox(width: 8),
                    _buildFilterChip("ลงทะเบียน"),
                    const SizedBox(width: 8),
                    _buildFilterChip("เปิดให้เรียน"),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Course List
              Expanded(
                child: ListView.builder(
                  itemCount: product.cousrsProduct.length,
                  itemBuilder: (context, index) {
                    final course = product.cousrsProduct[index];
                    return _buildCourseCard(course);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 1),
    );
  }

  Widget _buildCourseCard(CourseModel course) {
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Course icon / image
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: course.imageUrl.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          course.imageUrl,
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Icon(
                        Icons.menu_book_rounded,
                        color: Colors.grey,
                        size: 28,
                      ),
              ),
              const SizedBox(width: 12),
              // Course info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.courseName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "${course.courseID} • ${course.courseNameEn}",
                      style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "${course.credits} หน่วยกิต",
                      style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Description
          Text(
            course.description,
            style: TextStyle(fontSize: 13, color: Colors.grey[700]),
          ),
          const SizedBox(height: 12),
          // Topics as chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: course.topics.map((topic) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF00B4FF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  topic,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF0091D5),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 14),
          // ปุ่มดูรายละเอียด
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailPage(course: course),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00B4FF),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text(
                "ดูรายละเอียด",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    bool isSelected = selectedFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF00B4FF) : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
