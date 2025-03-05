import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/widget/buildBottomAppbar.dart';

class BuildButtonBottom extends StatelessWidget {
  final String title; // Title for the button.
  final VoidCallback func;
  final bool isActive; // Function to execute on button press.

  const BuildButtonBottom({
    super.key,
    required this.title, // Make title required.
    required this.func,
    this.isActive = true, // Make func required.
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
        bgColor: isActive ? Theme.of(context).primaryColor : color_ddd,
        title: title,
        func: isActive
            ? func
            : () {
                print('not active function');
              },
      ),
    );
  }
}
