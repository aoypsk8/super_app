import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:super_app/services/theme_service.dart';

class PrimaryCard extends StatelessWidget {
  const PrimaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = Get.find<ThemeService>();

    return Obx(() {
      // Use reactive theme changes
      final isDarkMode = themeService.isDarkMode;
      final cardColor = isDarkMode ? Colors.grey[850] : Colors.white; // Customize colors here

      return Card(
        color: cardColor,
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.card_giftcard,
                size: 40.0,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
              const SizedBox(width: 10.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Card Title',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    'Card Subtitle',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: isDarkMode ? Colors.white70 : Colors.black54,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
