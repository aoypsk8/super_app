import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/services/theme_service.dart';
import 'package:super_app/services/language_service.dart';
import 'package:super_app/widget/button.dart';
import 'package:super_app/widget/textfont.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = Get.find<ThemeService>();

    Get.find<LanguageService>(); // Ensure we load language service

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.language),
            onPressed: () {
              _showLanguageDialog(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: themeService.toggleTheme, // Toggle theme
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFont(text: 'hello'),
              SizedBox(height: 10),
              TextFont(text: 'change_language'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: PrimaryButton(
                      title: 'Click Me',
                      svgPath: 'assets/icons/ic_home.svg',
                      onPressed: () {
                        print('objectssss');
                      },
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: SecondaryButton(
                      title: 'Click Me',
                      svgPath: 'assets/icons/ic_home.svg',
                      onPressed: () {
                        print('objectssss');
                      },
                    ),
                  ),
                ],
              ),
              Text(
                themeService.isDarkMode ? 'Dark Theme' : 'Light Theme',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.labelLarge?.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final languageService = Get.find<LanguageService>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows bottom sheet to be flexible
      backgroundColor: Colors.transparent, // Make the background transparent
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFont(
                text: 'Select Language',
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              SizedBox(height: 16),
              _buildLanguageOption(context, 'English', 'en', languageService),
              _buildLanguageOption(context, 'Lao', 'lo', languageService),
              _buildLanguageOption(context, 'Chinese', 'zh', languageService),
              _buildLanguageOption(context, 'Vietnamese', 'vi', languageService),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(BuildContext context, String languageName, String languageCode, LanguageService languageService) {
    return ListTile(
      title: TextFont(text: languageName),
      trailing: languageService.locale.languageCode == languageCode ? Icon(Icons.check, color: Colors.blue) : null, // Show check mark for the active language
      onTap: () {
        languageService.changeLanguage(languageCode);
        Get.back(); // Close the bottom sheet after selecting a language
      },
    );
  }
}
