import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/utility/myIcon.dart';
import 'package:super_app/widget/buildAppBar.dart';
import 'package:super_app/controllers/user_controller.dart';
import 'package:super_app/widget/textfont.dart';
import 'package:intl/intl.dart';

class AccountProfileScreen extends StatelessWidget {
  final userController = Get.find<UserController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color_fff,
      appBar: BuildAppBar(title: 'profile'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildHeader(),
              SizedBox(height: 15),
              TextFont(text: 'profile', color: cr_b326),
              buildTextDetail('fullname', userController.profileName.value, noto: true),
              buildTextDetail('msisdn', userController.userProfilemodel.value.msisdn!),
              buildTextDetail('birthday', userController.userProfilemodel.value.birthdate!),
              buildTextDetail(
                'address',
                [
                  userController.userProfilemodel.value.village,
                  userController.userProfilemodel.value.district,
                  userController.userProfilemodel.value.provinceDesc,
                ].where((element) => element != null && element!.isNotEmpty).join('\n'),
                noto: true,
                maxline: 3,
              ),
              buildTextDetail('document_id', userController.userProfilemodel.value.cardId ?? ''),
              SizedBox(height: 30),
              TextFont(text: 'restriction', color: cr_b326),
              buildTextDetail('max_balance', NumberFormat('#,###').format(double.parse(userController.balanceModel.value.data!.limitBalance.toString()))),
              buildTextDetail('limit_transfer', '-'),
              buildTextDetail('limit_transfer_per_day', NumberFormat('#,###').format(double.parse(userController.balanceModel.value.data!.limitPerday.toString()))),
            ],
          ),
        ),
      ),
    );
  }

  Column buildTextDetail(String title, String desc, {bool noto = false, int maxline = 1}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFont(
                text: title,
                fontWeight: FontWeight.w500,
              ),
              Expanded(
                child: TextFont(
                  text: desc,
                  textAlign: TextAlign.right,
                  color: color_7070,
                  fontWeight: FontWeight.w500,
                  poppin: noto ? false : true, // Set poppin to true if money is true
                  noto: noto ? true : false,
                  maxLines: maxline,
                ),
              ),
            ],
          ),
        ),
        Divider(color: color_ecec),
      ],
    );
  }

  Row buildHeader() {
    return Row(
      children: [
        SizedBox(
          width: 50.sp,
          height: 50.sp,
          child: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(userController.userProfilemodel.value.profileImg ?? ''),
            backgroundColor: Colors.transparent, // Optional: Set a background color
          ),
        ),
        SizedBox(width: 8), // Optional spacing between image and column
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFont(
                text: userController.profileName.value,
                maxLines: 2,
                noto: true,
                color: color_7070,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              Row(
                children: [
                  TextFont(
                    text: userController.userProfilemodel.value.msisdn!,
                    poppin: true,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(color: color_f4f4, borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              userController.userProfilemodel.value.verify == "Approved"
                  ? SvgPicture.asset(MyIconOld.ic_check_circle)
                  : SvgPicture.asset(
                      MyIconOld.ic_info,
                      color: userController.userProfilemodel.value.verify == "UnApproved" ? color_primary_light : Colors.grey,
                    ),
              SizedBox(width: 5),
              TextFont(
                text: userController.userProfilemodel.value.verify ?? '',
                fontSize: 10,
                poppin: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
