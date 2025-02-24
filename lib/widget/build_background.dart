import 'package:flutter/material.dart';
import 'package:super_app/utility/color.dart';

class buildBackground extends StatelessWidget {
  const buildBackground({super.key, required this.widget});
  final Widget widget;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: color_red_background,
      // decoration: const BoxDecoration(
      //     gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomCenter, colors: [
      //   Color.fromARGB(255, 122, 0, 0),
      //   // Color.fromARGB(255, 255, 1, 1),
      //   Color.fromARGB(255, 235, 3, 3),
      //   // Color.fromARGB(255, 235, 3, 3),
      //   Color.fromARGB(255, 122, 0, 0),
      // ])),

      child: widget,
    );
  }
}
