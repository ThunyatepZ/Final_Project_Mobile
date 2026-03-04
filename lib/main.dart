import 'package:app/AuthScreen.login.dart';
import 'package:app/Homepage.dart';
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
            colorScheme: ColorScheme.dark(
              primary: Colors.blueAccent,
              secondary: Colors.blueAccent,
              surface: Color(0xFF121212),       // card / container background
              background: Color(0xFF0B0B0B),    // scaffold background
              onSurface: Colors.white70,        // text on cards
            ),
            scaffoldBackgroundColor: Color(0xFF0B0B0B),
            cardColor: Color(0xFF1E1E1E),       // use Theme.of(context).cardColor
            textTheme: TextTheme(
              bodyMedium: TextStyle(color: Colors.white70),
              bodySmall: TextStyle(color: Colors.white60),
            ),
            // optional: shadowColor, iconTheme, appBarTheme etc.
            shadowColor: Colors.black54,
            primaryTextTheme: TextTheme(
              titleMedium: TextStyle(color: Colors.white),
            ),
            dividerColor: const Color.fromARGB(58, 85, 85, 85),
          ),
          initialRoute: "/auth",
          routes: {
            "/auth": (context) => const AuthScreenLogin(),
            "/profile": (context) => const ProfilePage(),
            "/home": (context) => const Homepage(),
            "/course": (context) => const Coursepage(),
            "/theme": (context) => const Themepage(),
          },
        );
      },
    );
  }
}

class SizedBoxThemeData {
}

void main() {
  runApp(const MyWidget());
}
