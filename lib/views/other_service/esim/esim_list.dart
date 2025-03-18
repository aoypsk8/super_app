import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:super_app/controllers/esim_controller.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/views/other_service/esim/build_card_esim.dart';
import 'package:super_app/views/other_service/esim/vertify_kyc_esim.dart';
import 'package:super_app/widget/buildAppBar.dart';
import 'package:super_app/widget/textfont.dart';

class EsimCardScreen extends StatefulWidget {
  const EsimCardScreen({super.key});

  @override
  State<EsimCardScreen> createState() => _EsimCardScreenState();
}

class _EsimCardScreenState extends State<EsimCardScreen> {
  final RefreshController _refreshController = RefreshController();
  final esimController = Get.put(ESIMController());
  void _onRefresh() {
    Future.delayed(const Duration(seconds: 1), () {
      _refreshController.refreshCompleted();
      esimController.fetchESIM();
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color_fff,
      appBar: BuildAppBar(title: "buy_ESIM"),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
        child: SmartRefresher(
          controller: _refreshController,
          enablePullDown: true,
          onRefresh: _onRefresh,
          header: WaterDropHeader(
            complete: TextFont(text: 'Refresh Complete'),
          ),
          child: SingleChildScrollView(
              child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFont(
                  fontSize: 13,
                  text: "choose_ESIM",
                ),
                const SizedBox(height: 5),
                ...esimController.esimModel.asMap().entries.map((entry) {
                  int index = entry.key;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Hero(
                      tag:
                          "${esimController.esimModel[index].title}_${esimController.esimModel[index].phoneNumber}", // Add index for uniqueness
                      child: Material(
                        color: Colors.transparent,
                        child: CardWidgetESIM(
                          packagename: esimController.esimModel[index].title,
                          code: esimController.esimModel[index].phoneNumber,
                          amount:
                              esimController.esimModel[index].price.toString(),
                          detail:
                              "${esimController.esimModel[index].data} / ${esimController.esimModel[index].time}",
                          onTap: () {
                            Get.to(
                              () => Vertify_kyc_ESIM(
                                esimData: esimController.esimModel[index],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                }).toList(),
                const SizedBox(height: 30),
              ],
            ),
          )),
        ),
      ),
    );
  }
}
