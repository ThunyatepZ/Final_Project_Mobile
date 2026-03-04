import 'package:flutter/material.dart';
// Source - https://stackoverflow.com/q/67794181
// Posted by Silent Fairy, modified by community. See post 'Timeline' for change history
// Retrieved 2026-03-04, License - CC BY-SA 4.0

// global notifier used by the app to rebuild when theme changes
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.system);

class Themepage extends StatelessWidget {
  const Themepage({super.key});

  @override
  Widget build(BuildContext context) {
    // use ValueListenableBuilder so UI updates when mode changes
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentMode, _) {
        void setMode(ThemeMode mode) {
          themeNotifier.value = mode;
        }

        return Scaffold(
          appBar: AppBar(title: const Text("Profile")),
          body: Container(
            margin: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text(
                  "APPEARANCE",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).shadowColor.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.light_mode_outlined),
                        title: const Text("โหมดสว่าง"),
                        trailing: currentMode == ThemeMode.light
                            ? const Icon(Icons.check)
                            : null,
                        onTap: () => setMode(ThemeMode.light),
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.dark_mode_outlined),
                        title: const Text("โหมดมืด"),
                        trailing: currentMode == ThemeMode.dark
                            ? const Icon(Icons.check)
                            : null,
                        onTap: () => setMode(ThemeMode.dark),
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.phone_iphone),
                        title: const Text("ใช้โหมดระบบ"),
                        trailing: currentMode == ThemeMode.system
                            ? const Icon(Icons.check)
                            : null,
                        onTap: () => setMode(ThemeMode.system),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
