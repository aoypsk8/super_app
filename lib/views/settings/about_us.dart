// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, unnecessary_this
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/utility/myIcon.dart';
import 'package:super_app/widget/myIcon.dart';
import 'package:super_app/widget/textfont.dart';

class AboutUs extends StatefulWidget {
  AboutUs({Key? key}) : super(key: key);

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  String? version;
  String? name;

  @override
  void initState() {
    _getPackageinfo().then((num) {
      setState(() {
        version = num;
      });
    });
    super.initState();
  }

  _getPackageinfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    var version = packageInfo.version;
    return version;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            width: size.width,
            padding: EdgeInsets.only(left: 30, right: 20),
            decoration: BoxDecoration(color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  MyIconOld.logox,
                  width: 18.w,
                  fit: BoxFit.cover,
                ),
                SizedBox(
                  height: 20,
                ),
                ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    AboutInfoList(
                      title: 'version',
                      desc: version ?? '',
                    ),
                    // AboutInfoList(
                    //   title: 'name',
                    //   desc: name == null ? '' : name,
                    // ),
                    AboutInfoList(
                      title: 'address',
                      desc: 'addressdesc',
                    ),
                    AboutInfoList(
                      title: 'callcenter',
                      desc: '1101',
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: TextFont(
                        maxLines: 3,
                        textAlign: TextAlign.center,
                        text: 'devby',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AboutInfoList extends StatelessWidget {
  final title;
  final desc;
  const AboutInfoList({
    Key? key,
    this.desc,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Flex(
        direction: Axis.vertical,
        children: [
          Container(
            child: Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: TextFont(
                    text: this.title,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: TextFont(
                      text: this.desc,
                      maxLines: 5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Flex(
            direction: Axis.horizontal,
            children: const [
              Expanded(
                flex: 1,
                child: SizedBox(),
              ),
              Expanded(
                flex: 2,
                child: Divider(
                  thickness: 1.2,
                  height: 1,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
