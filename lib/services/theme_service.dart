import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:super_app/controllers/home_controller.dart';
import 'package:super_app/controllers/user_controller.dart';

class ThemeService extends GetxService {
  final HomeController homeController = Get.find();
  final UserController userController = Get.find();
  final _storage = GetStorage();
  final _key = 'isDarkMode';

  // Reactive observable for theme mode
  RxBool _isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    _isDarkMode.value = _storage.read<bool>(_key) ?? false;
  }

  ThemeMode get theme {
    bool isDarkMode = _storage.read<bool>(_key) ?? false;
    return isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }

  bool get isDarkMode => _isDarkMode.value;

  void toggleTheme() {
    _isDarkMode.value = !_isDarkMode.value;
    _storage.write(_key, _isDarkMode.value);
    homeController.fetchServicesmMenu(userController.rxMsisdn.value);
    Get.changeThemeMode(_isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }
}
