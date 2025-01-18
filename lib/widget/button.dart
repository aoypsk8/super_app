import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final String svgPath;
  final double borderRadius;
  final double width;
  final double height;
  final VoidCallback onPressed;

  const CustomButton({
    Key? key,
    required this.title,
    this.svgPath = '',
    this.borderRadius = 16.0,
    this.width = 150.0,
    this.height = 50.0,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use Theme.of(context) to get dynamic theme colors
    final backgroundColor = Theme.of(context).cardColor;
    final borderColor = Theme.of(context).primaryColor;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: borderColor, width: 2.0),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (svgPath.isNotEmpty)
              SvgPicture.asset(
                svgPath,
                width: 24.0,
                height: 24.0,
                color: textColor,
              ),
            if (svgPath.isNotEmpty) const SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
