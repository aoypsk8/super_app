import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/controllers/cashout_controller.dart';
import 'package:super_app/controllers/home_controller.dart';
import 'package:super_app/controllers/user_controller.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/views/cashout/VerifyAccountBankScreen.dart';
import 'package:super_app/widget/buildAppBar.dart';
import 'package:super_app/widget/build_step_process.dart';
import 'package:super_app/widget/textfont.dart';
// import 'package:mmoney_lite/screens/bank/controller/bank_controller.dart';

class ListsProviderBankScreen extends StatefulWidget {
  const ListsProviderBankScreen({super.key});

  @override
  State<ListsProviderBankScreen> createState() =>
      _ListsProviderBankScreenState();
}

class _ListsProviderBankScreenState extends State<ListsProviderBankScreen> {
  final homeController = Get.find<HomeController>();
  final userController = Get.find<UserController>();
  final cashOutControler = Get.put(CashOutController());

  @override
  void initState() {
    userController.increasepage();
    cashOutControler.fetchBankList();
    super.initState();
  }

  @override
  void dispose() {
    userController.decreasepage();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: color_grey_background,
        appBar: BuildAppBar(title: "cashout"),
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              // TextFont(
              //   text: 'transfer_wallet',
              //   fontWeight: FontWeight.w500,
              //   fontSize: 12,
              // ),
              buildStepProcess(title: '1/3', desc: 'transfer_wallet'),
              const SizedBox(height: 10),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: cashOutControler.bankModel.length,
                  itemBuilder: (context, index) {
                    return AnimationConfiguration.staggeredGrid(
                      position: index,
                      duration: const Duration(milliseconds: 600),
                      columnCount: 3,
                      child: ScaleAnimation(
                        child: FadeInAnimation(
                          child: buildListProvider(index),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildListProvider(int index) {
    return InkWell(
      onTap: () {
        cashOutControler.bankDetail.value = cashOutControler.bankModel[index];
        cashOutControler.rxCodeBank.value =
            cashOutControler.bankModel[index].code!;
        cashOutControler.rxLogo.value = cashOutControler.bankModel[index].logo!;

        Get.to(() => const VerifyAccountBankScreen());
      },
      child: Container(
        decoration: BoxDecoration(
          color: color_f4f4,
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.only(bottom: 10),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.contain,
                    image: NetworkImage(
                      cashOutControler.bankModel[index].logo
                          .toString()
                          .replaceAll(
                            'https://mmoney.la',
                            'https://gateway.ltcdev.la/AppImage',
                          ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextFont(
                text: cashOutControler.bankModel[index].title!,
                fontWeight: FontWeight.w400,
                fontSize: 11,
                maxLines: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
