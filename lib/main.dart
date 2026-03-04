import 'package:app/AuthScreen.login.dart';
import 'package:app/QA.page.dart';
import 'package:flutter/material.dart';
import 'package:app/Profile.page.dart';
import 'Course.dart';
import 'package:app/component_/theme.dart'; // for themeNotifier and Themepage

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, mode, _) {
        return MaterialApp(
          themeMode: mode,
          theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: Colors.blueAccent,
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              // foregroundColor: Colors.black,
            ),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: Colors.white,
              selectedItemColor: Colors.blueAccent,
              unselectedItemColor: Colors.grey,
            ),
            colorScheme: const ColorScheme.light(
              primary: Colors.blueAccent,
              // secondary: Colors.black,
              surface: Colors.white,
              onPrimary: Colors.grey,
              onSecondary: Colors.grey,
              // onSurface: Colors.black,
              error: Colors.red,
              onError: Colors.red,
            ),
            cardColor: Colors.white,
            shadowColor: Colors.grey.withOpacity(0.2),
            dividerColor: const Color.fromARGB(57, 193, 193, 193),
          ),
          //
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primaryColor: const Color(0xFF3B82F6),
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF3B82F6),
              secondary: Color(0xFF60A5FA),
              surface: Color(0xFF1E293B), // Card/Container background
              background: Color(0xFF0F172A), // Scaffold background
              onSurface: Color(0xFFF1F5F9), // Main text on cards
              onBackground: Color(0xFFF8FAFC), // Main text on background
            ),
            scaffoldBackgroundColor: const Color(0xFF0F172A),
            cardColor: const Color(0xFF1E293B),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF0F172A),
              elevation: 0,
            ),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: Color(0xFF1E293B),
              selectedItemColor: Color(0xFF3B82F6),
              unselectedItemColor: Color(0xFF94A3B8),
            ),
            textTheme: const TextTheme(
              bodyMedium: TextStyle(color: Color(0xFFE2E8F0)),
              bodySmall: TextStyle(color: Color(0xFF94A3B8)),
            ),
            shadowColor: Colors.black.withOpacity(0.4),
            dividerColor: const Color(0xFF334155),
          ),
          initialRoute: "/auth",
          routes: {
            "/auth": (context) => const AuthScreenLogin(),
            "/profile": (context) => const ProfilePage(),
            "/QA": (context) => const QApage(),
            "/course": (context) => const Coursepage(),
            "/theme": (context) => const Themepage(),
          },
        );
      },
    );
  }
}

class SizedBoxThemeData {}

void main() {
  runApp(const MyWidget());
}
