import 'package:flutter/material.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/widget/buildBottomAppbar.dart';

class BuildButtonBottom extends StatelessWidget {
  final String title; // Title for the button.
  final VoidCallback func; // Function to execute on button press.

  const BuildButtonBottom({
    super.key,
    required this.title, // Make title required.
    required this.func, // Make func required.
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: color_fff,
        border: Border.all(color: color_ddd),
      ),
      child: buildBottomAppbar(
        bgColor: Theme.of(context).primaryColor,
        title: title, // Use the title passed from the constructor.
        func: func, // Use the func passed from the constructor.
      ),
    );
  }
}
