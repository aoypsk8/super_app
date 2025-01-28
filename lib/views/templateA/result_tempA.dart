import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:super_app/widget/buildAppBar.dart';

class ResultTempAScreen extends StatelessWidget {
  const ResultTempAScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BuildAppBar(title: 'receipt'),
    );
  }
}
