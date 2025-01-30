import 'dart:ui';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LanguageService extends GetxService {
  final box = GetStorage();

  // Supported locales
  static const supportedLocales = [
    Locale('en', 'US'), // English
    Locale('lo', 'LA'), // Lao
    Locale('zh', 'CN'), // Chinese (Simplified)
    Locale('vi', 'VN'), // Vietnamese
  ];

  Locale get locale {
    String languageCode = box.read('language') ?? 'lo';
    return Locale(languageCode);
  }

  Future<void> init() async {
    String languageCode = box.read('language') ?? 'lo';
    Get.updateLocale(Locale(languageCode));
  }

  // Change language method
  void changeLanguage(String languageCode) {
    // Validate if the language is supported
    if (!supportedLocales
        .any((locale) => locale.languageCode == languageCode)) {
      languageCode = 'lo';
    }

    // Save the language preference
    box.write('language', languageCode);
    Get.updateLocale(Locale(languageCode)); // Update locale immediately
  }
}
