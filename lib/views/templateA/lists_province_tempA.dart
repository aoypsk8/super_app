import 'package:flutter/material.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/widget/buildAppBar.dart';
import 'package:super_app/widget/buildButtonBottom.dart';
import 'package:super_app/widget/textfont.dart';

class ListsProvinceTempA extends StatelessWidget {
  const ListsProvinceTempA({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BuildAppBar(title: 'title'),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: const [
            Row(
              children: [
                TextFont(
                  text: '1/3',
                  poppin: true,
                  fontWeight: FontWeight.bold,
                  color: color_primary_light,
                ),
                SizedBox(width: 5),
                TextFont(text: 'ເລືອກແຂວງຂອງທ່ານ'),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BuildButtonBottom(
        title: 'next',
        func: () {},
      ),
    );
  }
}
