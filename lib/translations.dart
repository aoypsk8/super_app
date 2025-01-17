import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AppTranslations extends Translations {
  static final Map<String, Map<String, String>> _translations = {};

  static Future<void> loadTranslations() async {
    for (var locale in ['en', 'lo', 'zh', 'vi']) {
      String jsonString = await rootBundle.loadString('assets/lang/$locale.json');
      Map<String, String> jsonMap = Map<String, String>.from(json.decode(jsonString));
      _translations[locale] = jsonMap;
    }
  }

  @override
  Map<String, Map<String, String>> get keys => _translations;
}
