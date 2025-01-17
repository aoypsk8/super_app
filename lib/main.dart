import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:super_app/services/language_service.dart';
import 'package:super_app/services/theme_service.dart';
import 'package:super_app/themes/dark_theme.dart';
import 'package:super_app/themes/light_theme.dart';
import 'package:super_app/translations.dart';
import 'home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  final languageService = Get.put(LanguageService());
  await languageService.init();

  await AppTranslations.loadTranslations(); // Initialize language service and set the default language
  Get.put(ThemeService());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      translations: AppTranslations(),
      locale: Get.find<LanguageService>().locale, // Listen for changes in the locale
      fallbackLocale: const Locale('lo'),
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: Get.find<ThemeService>().theme,
      home: HomeScreen(),
    );
  }
}
