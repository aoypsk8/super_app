import 'dart:ui';

import 'package:flutter/material.dart';

class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);

    return path;
  }

  @override
  bool shouldReclip(TriangleClipper oldClipper) => false;
}

class MyCustomClipperTop extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    var curXPos = 0.0;
    var curYPos = size.height;
    var increment = size.width / 58;
    while (curXPos < size.width) {
      curXPos += increment;
      curYPos = curYPos == size.height ? size.height - 10 : size.height;
      path.lineTo(curXPos, curYPos);
    }
    path.lineTo(size.width, size.height);
    path.lineTo(size.height, size.width);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class MyCustomClipperButtom extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    var curXPos = 0.0;
    var curYPos = size.height;
    var increment = size.width / 58;

    path.moveTo(0, size.height);

    // Create the zigzag wave
    while (curXPos < size.width) {
      curXPos += increment;
      curYPos = curYPos == size.height ? size.height - 10 : size.height;
      path.lineTo(curXPos, curYPos);
    }

    // Complete the path
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
