import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeService extends GetxService {
  final _storage = GetStorage();
  final _key = 'isDarkMode';

  // Load theme from storage or default to light theme
  ThemeMode get theme {
    bool isDarkMode = _storage.read<bool>(_key) ?? false;
    return isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }

  // Check if the current theme is dark
  bool get isDarkMode {
    return theme == ThemeMode.dark;
  }

  // Toggle theme and save to storage
  void toggleTheme() {
    bool isDarkMode = theme == ThemeMode.dark;
    _storage.write(_key, !isDarkMode);
    Get.changeThemeMode(!isDarkMode ? ThemeMode.dark : ThemeMode.light);
  }
}
