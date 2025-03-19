// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/controllers/home_controller.dart';
import 'package:super_app/controllers/payment_controller.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/utility/dialog_helper.dart';
import 'package:super_app/views/visa-mastercard/addVisaMasterCard.dart';
import 'package:super_app/widget/buildAppBar.dart';
import 'package:super_app/widget/mask_msisdn.dart';
import 'package:super_app/widget/myIcon.dart';
import 'package:super_app/widget/textfont.dart';

class VisaMasterCard extends StatefulWidget {
  const VisaMasterCard({super.key});

  @override
  State<VisaMasterCard> createState() => _VisaMasterCardState();
}

class _VisaMasterCardState extends State<VisaMasterCard> {
  final paymentController = Get.put(PaymentController());
  final homeController = Get.find<HomeController>();
  @override
  void initState() {
    super.initState();
    paymentController.getPaymentMethods('all');
  }

  int? selectedCardIndex = 0;

  void confirmDelete(String owner, int id) {
    DialogHelper.showErrorWithFunctionDialog(
      closeTitle: "ລົບ",
      title: "ຕ້ອງການລົບບັນຊີນີ້ບໍ່",
      description: "ການກະທຳນີ້ຈະບໍ່ສາມາດກູຄືນໄດ້!",
      withCancel: true,
      onClose: () async {
        var deleteData = await paymentController.deletePaymentMethod(owner, id);
        Get.back();
        if (deleteData) {
          DialogHelper.showSuccessWithMascot(
            onClose: () => {},
            title: 'ລົບສຳເລັດ!',
          );
        } else {
          DialogHelper.showErrorDialogNew(
            title: 'cannot_delete!',
            description: "please_change_main_card",
          );
        }
      },
    );
  }

  // payment methods
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: color_fff,
        appBar: BuildAppBar(title: homeController.menutitle.value),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: color_f4f4,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextFont(text: "all_cards"),
                              GestureDetector(
                                onTap: () {
                                  Get.to(AddVisaMasterCard());
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 7,
                                    ),
                                    child: TextFont(
                                      color: color_fff,
                                      text: "+ Add",
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Divider(color: color_b6b6),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: paymentController.paymentMethods.length,
                            itemBuilder: (context, index) {
                              bool isSelected = selectedCardIndex == index;
                              return GestureDetector(
                                onTap: () async {
                                  paymentController.loading.value = true;
                                  await paymentController.updatePaymentMethod(
                                      paymentController
                                          .paymentMethods[index].owner,
                                      paymentController
                                          .paymentMethods[index].id);
                                  if (paymentController.loading.value) {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      },
                                    );
                                  } else {
                                    setState(() {
                                      selectedCardIndex = index;
                                    });
                                    DialogHelper.showSuccessWithMascot(
                                      onClose: () => {},
                                      title: 'change_primary_success',
                                    );
                                  }
                                },
                                child: AnimationConfiguration.staggeredList(
                                  position: index,
                                  duration: const Duration(milliseconds: 800),
                                  child: SlideAnimation(
                                    horizontalOffset: 500.0,
                                    child: FadeInAnimation(
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                        color: paymentController
                                                                .paymentMethods[
                                                                    index]
                                                                .maincard
                                                            ? cr_ef33
                                                            : color_9f9,
                                                        width: 2,
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              2.5),
                                                      child: Container(
                                                        width: 10,
                                                        height: 10,
                                                        decoration: BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color: paymentController
                                                                    .paymentMethods[
                                                                        index]
                                                                    .maincard
                                                                ? cr_ef33
                                                                : null),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  TextFont(
                                                    text: "Primary account",
                                                    poppin: true,
                                                  ),
                                                ],
                                              ),
                                              InkWell(
                                                onTap: paymentController
                                                            .paymentMethods[
                                                                index]
                                                            .title ==
                                                        "MMONEY"
                                                    ? null
                                                    : () => confirmDelete(
                                                        paymentController
                                                            .paymentMethods[
                                                                index]
                                                            .owner,
                                                        paymentController
                                                            .paymentMethods[
                                                                index]
                                                            .id),
                                                child: paymentController
                                                            .paymentMethods[
                                                                index]
                                                            .paymentType ==
                                                        "MMONEY"
                                                    ? SizedBox.shrink()
                                                    : SvgPicture.asset(
                                                        MyIcon.ic_trash,
                                                        color: cr_ef33,
                                                      ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          MoneyCardWidget(
                                            cardHolderName: paymentController
                                                .paymentMethods[index].accname,
                                            logo: paymentController
                                                        .paymentMethods[index]
                                                        .paymentType ==
                                                    'MMONEY'
                                                ? paymentController
                                                    .paymentMethods[index].logo
                                                : paymentController
                                                            .paymentMethods[
                                                                index]
                                                            .paymentType ==
                                                        'VISA'
                                                    ? "https://mmoney.la/Payment/visa.jpg"
                                                    : paymentController
                                                                .paymentMethods[
                                                                    index]
                                                                .paymentType ==
                                                            'MASTERCARD'
                                                        ? "https://mmoney.la/Payment/mastercard.png"
                                                        : paymentController
                                                                    .paymentMethods[
                                                                        index]
                                                                    .paymentType ==
                                                                'UNIONPAY'
                                                            ? "https://mmoney.la/Payment/unionpay.png"
                                                            : paymentController
                                                                .paymentMethods[
                                                                    index]
                                                                .logo,
                                            accountNumber: paymentController
                                                .paymentMethods[index]
                                                .description,
                                            mainCard: paymentController
                                                .paymentMethods[index].maincard,
                                            type: paymentController
                                                .paymentMethods[index]
                                                .paymentType,
                                            selected: isSelected,
                                          ),
                                          const SizedBox(height: 10),
                                          Divider(color: color_b6b6),
                                          const SizedBox(height: 20),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MoneyCardWidget extends StatelessWidget {
  final String cardHolderName;
  final String accountNumber;
  final String logo;
  final bool mainCard;
  final String type;
  final bool selected;

  MoneyCardWidget({
    required this.cardHolderName,
    required this.accountNumber,
    required this.mainCard,
    required this.type,
    required this.logo,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      decoration: BoxDecoration(
        color: mainCard ? color_ec1c : color_8e94,
        borderRadius: BorderRadius.circular(15),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: SizedBox(
          height: 20.h,
          child: Stack(
            children: [
              SvgPicture.asset(
                MyIcon.bgOfCard,
                color: mainCard ? cr_ef33 : color_989,
              ),
              SizedBox(
                height: Get.height,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFont(
                            text: cardHolderName,
                            color: color_fff,
                            fontSize: 13,
                          ),
                          const SizedBox(height: 10),
                          TextFont(
                            text: type,
                            color: color_fff,
                            fontSize: 10,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 12.w,
                            height: 12.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: color_fff,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(1.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.network(
                                  logo,
                                  fit: BoxFit.cover,
                                  width: 15.w,
                                  height: 15.w,
                                ),
                              ),
                            ),
                          ),
                          TextFont(
                            text: maskMsisdn(accountNumber),
                            color: color_fff,
                            fontSize: 13,
                            poppin: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
