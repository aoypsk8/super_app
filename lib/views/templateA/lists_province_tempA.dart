import 'package:flutter/material.dart';
import 'package:super_app/widget/buildAppBar.dart';
import 'package:super_app/widget/buildButtonBottom.dart';

class ListsProvinceTempA extends StatelessWidget {
  const ListsProvinceTempA({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BuildAppBar(title: 'title'),
      bottomNavigationBar: BuildButtonBottom(
        title: 'next',
        func: () {},
      ),
    );
  }
}
