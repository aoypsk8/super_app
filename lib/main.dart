import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:super_app/app_routes.dart';
import 'package:super_app/services/language_service.dart';
import 'package:super_app/services/theme_service.dart';
import 'package:super_app/themes/dark_theme.dart';
import 'package:super_app/themes/light_theme.dart';
import 'package:super_app/translations.dart';
import 'package:super_app/views/main/bottom_nav.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  // Initialize services
  final languageService = Get.put(LanguageService());
  await languageService.init();
  await AppTranslations.loadTranslations();
  Get.put(ThemeService());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, eviceType) {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        translations: AppTranslations(),
        locale: Get.find<LanguageService>().locale,
        fallbackLocale: const Locale('lo'),
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: Get.find<ThemeService>().theme,
        initialRoute: '/',
        getPages: AppRoutes.routes,
        home: BottomNav(),
      );
    });
  }
}
