import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:super_app/app_routes.dart';
import 'package:super_app/services/blindings/initial_blinding.dart';
import 'package:super_app/services/language_service.dart';
import 'package:super_app/services/theme_service.dart';
import 'package:super_app/themes/dark_theme.dart';
import 'package:super_app/themes/light_theme.dart';
import 'package:super_app/translations.dart';
import 'package:super_app/views/main/bottom_nav.dart';
import 'package:sizer/sizer.dart';

void main() async {
  HttpOverrides.global = MyHttpOverrides();
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
        initialBinding: InitialBindings(),
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

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
