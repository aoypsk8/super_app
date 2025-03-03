import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/controllers/home_controller.dart';
import 'package:super_app/controllers/payment_controller.dart';
import 'package:super_app/controllers/tempA_controller.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/widget/buildAppBar.dart';
import 'package:super_app/widget/build_step_process.dart';
import 'package:super_app/widget/textfont.dart';

class ListsPaymentScreen extends StatefulWidget {
  final void Function(String paymentType, String cardDetail) onSelectedPayment;
  final String stepBuild;
  final String description;
  final String title;

  ListsPaymentScreen(
      {super.key,
      required this.onSelectedPayment,
      required this.stepBuild,
      required this.description,
      required this.title});

  @override
  State<ListsPaymentScreen> createState() => _ListsPaymentScreenState();
}

class _ListsPaymentScreenState extends State<ListsPaymentScreen> {
  final homeController = Get.find<HomeController>();

  final paymentController = Get.put(PaymentController());

  final controller = Get.put(TempAController());

  @override
  void initState() {
    super.initState();
    paymentController.getPaymentMethods();
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
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 500),
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(
                            child: GestureDetector(
                              onTap: () {
                                final paymentType = paymentController
                                    .paymentMethods[index].paymentType;
                                final cardIndex = paymentController
                                    .paymentMethods[index].id
                                    .toString();
                                widget.onSelectedPayment(
                                    paymentType, cardIndex);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 10),
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                    width: 1,
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
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          paymentController
                                                  .paymentMethods[index]
                                                  .maincard
                                              ? TextFont(
                                                  text: 'Primary',
                                                  poppin: true,
                                                  color: color_primary_light,
                                                  fontSize: 10,
                                                )
                                              : SizedBox.shrink(),
                                          TextFont(
                                            text: paymentController
                                                .paymentMethods[index].title
                                                .toString(),
                                            poppin: true,
                                            fontWeight: FontWeight.w500,
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
      ),
    );
  }
}
