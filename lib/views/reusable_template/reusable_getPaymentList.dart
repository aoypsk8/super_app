import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/controllers/home_controller.dart';
import 'package:super_app/controllers/payment_controller.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/widget/buildAppBar.dart';
import 'package:super_app/widget/buildBottomAppbar.dart';
import 'package:super_app/widget/build_step_process.dart';
import 'package:super_app/widget/textfont.dart';

class ListsPaymentScreen extends StatefulWidget {
  final void Function(String paymentType, String cardDetail, String uuid)
      onSelectedPayment;
  final String stepBuild;
  final String description;
  final String title;

  ListsPaymentScreen({
    super.key,
    required this.onSelectedPayment,
    required this.stepBuild,
    required this.description,
    required this.title,
  });

  @override
  State<ListsPaymentScreen> createState() => _ListsPaymentScreenState();
}

class _ListsPaymentScreenState extends State<ListsPaymentScreen> {
  final homeController = Get.put(HomeController());
  final paymentController = Get.put(PaymentController());

  int? selectedIndex;
  late Worker _paymentMethodListener;

  @override
  void initState() {
    super.initState();
    paymentController.getPaymentMethods(widget.description);
    _paymentMethodListener = ever(paymentController.paymentMethods, (_) {
      if (!mounted) return;
      if (paymentController.paymentMethods.isNotEmpty) {
        int mainCardIndex =
            paymentController.paymentMethods.indexWhere((e) => e.maincard);
        if (mainCardIndex != -1) {
          selectedIndex = mainCardIndex;
        } else {
          selectedIndex = 0;
        }
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _paymentMethodListener
        .dispose(); // Remove the listener when widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: color_fff,
        appBar: BuildAppBar(title: widget.title),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Column(
            children: [
              buildStepProcess(
                  title: widget.stepBuild, desc: widget.description),
              Expanded(
                child: AnimationLimiter(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: paymentController.paymentMethods.length,
                    itemBuilder: (context, index) {
                      final isMainCard =
                          paymentController.paymentMethods[index].maincard;
                      final isSelected = selectedIndex == index;

                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 500),
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedIndex = index;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 10),
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.1)
                                      : color_f4f4,
                                  border: Border.all(
                                    color: isSelected
                                        ? Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.5)
                                        : color_f4f4,
                                    width: isSelected ? 1.5 : 0.5,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    ClipOval(
                                      child: Image.network(
                                        paymentController
                                            .paymentMethods[index].logo,
                                        fit: BoxFit.fill,
                                        width: 15.w,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (isMainCard)
                                            TextFont(
                                              text: 'Primary Card',
                                              poppin: true,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          TextFont(
                                            text: paymentController
                                                .paymentMethods[index].title
                                                .toString(),
                                            poppin: true,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          ),
                                          TextFont(
                                            text: paymentController
                                                .paymentMethods[index]
                                                .description
                                                .toString(),
                                            poppin: true,
                                            color: Colors.grey.shade600,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.only(top: 20),
          decoration: BoxDecoration(
            color: color_fff,
            border: Border.all(color: color_ddd),
          ),
          child: buildBottomAppbar(
            bgColor: Theme.of(context).primaryColor,
            title: 'Next',
            func: selectedIndex != null
                ? () {
                    final paymentType = paymentController
                        .paymentMethods[selectedIndex!].paymentType;
                    final cardIndex = paymentController
                        .paymentMethods[selectedIndex!].id
                        .toString();
                    final uuid =
                        paymentController.paymentMethods[selectedIndex!].uuid;
                    widget.onSelectedPayment(paymentType, cardIndex, uuid);
                  }
                : () {},
          ),
        ),
      ),
    );
  }
}
