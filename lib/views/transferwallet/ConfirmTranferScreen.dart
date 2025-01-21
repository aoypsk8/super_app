import 'package:flutter/material.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/widget/textfont.dart';

class ConfirmTranferScreen extends StatefulWidget {
  const ConfirmTranferScreen({super.key});

  @override
  State<ConfirmTranferScreen> createState() => _ConfirmTranferScreenState();
}

class _ConfirmTranferScreenState extends State<ConfirmTranferScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color_fff,
      appBar: AppBar(
        backgroundColor: color_red244,
        title: TextFont(
          // text: menulists.groupNameEN.toString(),
          text: "homeController.menutitle.value",
          color: Colors.white,
          fontSize: 14,
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(0.00, -1.00),
              end: Alignment(0, 1),
              colors: [Color(0x00F14D58), Color(0xFFED1C29)],
            ),
          ),
        ),
      ),
    );
  }
}
