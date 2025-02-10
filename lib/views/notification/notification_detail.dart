// ignore_for_file: sort_child_properties_last, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/controllers/home_controller.dart';
import 'package:super_app/widget/buildBottomAppbar.dart';
import 'package:super_app/widget/myIcon.dart';
import 'package:super_app/widget/textfont.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

import '../../utility/color.dart';

class NotificationDetail extends StatefulWidget {
  const NotificationDetail({super.key});

  @override
  State<NotificationDetail> createState() => _NotificationDetailState();
}

class _NotificationDetailState extends State<NotificationDetail> {
  final homeController = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: 24, right: 24),
            child: Column(
              children: [header(), messageTitle()],
            ),
          ),
        ),
        bottomNavigationBar:
            buildBottomAppbar(func: () => Get.back(), title: 'close'),
      ),
    );
  }

  Widget header() {
    var date = DateTime.parse(homeController.messageListDetail.value.createAt!);
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 1),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30), color: cr_red),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    MyIcon.ic_speaker,
                    height: 5.5.w,
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  TextFont(
                    text: homeController.messageListDetail.value.typeName!,
                    fontSize: 10,
                    color: Colors.white,
                    noto: true,
                  ),
                ],
              ),
            ),
            Spacer(),
            TextFont(
              text: DateFormat("MMM dd, yyyy - HH:mm").format(date),
              fontSize: 11,
              color: Color(0xff636E72),
              poppin: true,
            ),
          ],
        ),
        SizedBox(
          height: 16,
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: homeController.messageListDetail.value.imgUrl == null ||
                  homeController.messageListDetail.value.imgUrl == 'null' ||
                  homeController.messageListDetail.value.imgUrl == ''
              ? SvgPicture.asset(
                  MyIcon.bgg_nopic,
                  fit: BoxFit.fitHeight,
                )
              : CachedNetworkImage(
                  fit: BoxFit.fitWidth,
                  progressIndicatorBuilder: (context, url, progress) =>
                      SizedBox(),
                  imageUrl: homeController.messageListDetail.value.imgUrl!,
                  errorWidget: (context, url, error) => SvgPicture.asset(
                    MyIcon.bgg_nopic,
                    fit: BoxFit.fitHeight,
                  ),
                ),
        ),
      ],
    );
  }

  Widget messageTitle() {
    return Container(
      padding: EdgeInsets.only(top: 10, left: 3, right: 3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFont(
            text: homeController.messageListDetail.value.title!,
            fontWeight: FontWeight.w600,
            noto: true,
          ),
          SizedBox(
            height: 6,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () async {
                var url = '${homeController.messageListDetail.value.url}';
                if (!await launchUrl(Uri.parse(url),
                    mode: LaunchMode.externalApplication)) {
                  throw 'Could not launch $url';
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  // color: cr_red,
                  border: Border.all(
                    color: Color(0xff636E72),
                    width: 1.2,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.language, size: 4.w, color: Color(0xff636E72)),
                    SizedBox(
                      width: 4,
                    ),
                    TextFont(
                      text: 'gotoWeb',
                      fontSize: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          TextFont(
            text: homeController.messageListDetail.value.body!,
            maxLines: 100,
            noto: true,
          )
        ],
      ),
    );
  }
}
