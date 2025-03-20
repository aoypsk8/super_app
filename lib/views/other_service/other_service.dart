import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/controllers/home_controller.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/utility/myconstant.dart';
import 'package:super_app/views/other_service/esim/esim_list.dart';
import 'package:super_app/widget/buildAppBar.dart';
import 'package:super_app/widget/textfont.dart';

class OtherService extends StatefulWidget {
  const OtherService({super.key});

  @override
  State<OtherService> createState() => _OtherServiceState();
}

class _OtherServiceState extends State<OtherService> {
  // Demo data for services
  final HomeController homeController = Get.find();
  final RefreshController _refreshController = RefreshController();
  final List<Map<String, dynamic>> services = [
    {
      "title": "Buy e-sim",
      "description": "Buy e-sim by Credit Card.",
      "icon": Iconsax.simcard,
      "logo": MyConstant.profile_default,
      "route": EsimCardScreen(),
    },
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(microseconds: 500), () {
      homeController.convertRate(1000);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color_fff,
      appBar: BuildAppBar(title: "other_service"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SmartRefresher(
          controller: _refreshController,
          enablePullDown: true,
          onRefresh: () {
            _refreshController.refreshCompleted();
          },
          header: WaterDropHeader(complete: TextFont(text: 'loading...')),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFont(
                text: "choose_other_service",
                fontWeight: FontWeight.w500,
              ),
              const SizedBox(height: 10),
              // Loop through the list of services
              Column(
                children: services.map((service) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: cardList(
                      service["title"],
                      service["description"],
                      service["icon"],
                      service["logo"],
                      () {
                        Get.to(() => service["route"] as Widget);
                      },
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container cardList(String title, String description, IconData icon,
      String logo, VoidCallback func) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color_f4f4,
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: func,
        child: Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color_f4f4,
                    border: Border.all(width: 1.5, color: cr_ef33),
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Icon(
                      icon,
                      color: Colors.red,
                      size: 8.w,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFont(
                        text: title,
                        fontWeight: FontWeight.w600,
                      ),
                      const SizedBox(height: 5),
                      TextFont(
                        text: description,
                        fontWeight: FontWeight.w400,
                        fontSize: 10,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              right: 0,
              top: 0,
              child: ClipOval(
                child: Image.network(
                  logo,
                  width: 6.w,
                  height: 6.w,
                  fit: BoxFit.cover,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
