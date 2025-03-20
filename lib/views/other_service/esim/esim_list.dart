import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:super_app/controllers/esim_controller.dart';
import 'package:super_app/controllers/home_controller.dart';
import 'package:super_app/services/helper/random.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/views/other_service/esim/build_card_esim.dart';
import 'package:super_app/widget/buildAppBar.dart';
import 'package:super_app/widget/build_pay_visa.dart';
import 'package:super_app/widget/textfont.dart';

class EsimCardScreen extends StatefulWidget {
  const EsimCardScreen({super.key});

  @override
  State<EsimCardScreen> createState() => _EsimCardScreenState();
}

class _EsimCardScreenState extends State<EsimCardScreen> {
  final RefreshController _refreshController = RefreshController();
  final HomeController homeController = Get.find();
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
                    child: CardWidgetESIM(
                      packagename:
                          'Stock : ${esimController.esimModel[index].totalRecords.toString()}',
                      code: esimController.esimModel[index].freeCall,
                      amount: esimController.esimModel[index].price.toString(),
                      detail:
                          "${esimController.esimModel[index].data} / ${esimController.esimModel[index].time}",
                      onTap: () async {
                        esimController.RxTransID.value =
                            'XX${await randomNumber().fucRandomNumber()}';
                        esimController.RxUSD.value = double.parse((double.parse(
                                    esimController.esimModel[index].price
                                        .toString()) /
                                homeController.RxrateUSDKIP.value)
                            .toStringAsFixed(2));

                        Get.to(PaymentVisaMasterCard(
                          function: () {
                            esimController.esimProcess(
                              esimController.esimModel[index].data,
                              esimController.esimModel[index].time,
                              esimController.esimModel[index].price,
                              esimController.esimModel[index].freeCall,
                              esimController.RxMail.value,
                              esimController.RxTransID.value,
                            );
                          },
                          trainID: esimController.RxTransID.value,
                          description: "BUY E-SIM",
                          amount: esimController.esimModel[index].price,
                        ));
                      },
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
