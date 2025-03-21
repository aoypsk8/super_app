import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:super_app/controllers/home_controller.dart';
import 'package:super_app/controllers/temp_b_controller.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/widget/buildAppBar.dart';
import 'package:super_app/widget/buildBottomAppbar.dart';
import 'package:super_app/widget/buildButtonBottom.dart';
import 'package:super_app/widget/build_step_process.dart';
import 'package:super_app/widget/mounoy_textfield.dart';
import 'package:super_app/widget/textfont.dart';

class VerifyAccountTempB extends StatefulWidget {
  const VerifyAccountTempB({super.key});

  @override
  State<VerifyAccountTempB> createState() => _VerifyAccountTempBState();
}

class _VerifyAccountTempBState extends State<VerifyAccountTempB> {
  final controller = Get.put(TempBController());
  final homeController = Get.find<HomeController>();

  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();

  final accountNumber = TextEditingController();
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BuildAppBar(title: homeController.getMenuTitle()),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: Column(
          children: [
            Container(
              color: color_fff,
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  buildStepProcess(title: '2/5', desc: 'input_bill_no'),
                  SizedBox(height: 5),
                  buildForm(),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Container(
                decoration: BoxDecoration(color: color_fff, boxShadow: []),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFont(text: 'history'),
                      Obx(() {
                        if (controller.isLoading.value) {
                          return Expanded(
                            child: const Center(
                                child: CircularProgressIndicator()),
                          );
                        }
                        if (controller.recenttampB.isEmpty) {
                          return Expanded(
                            child: Center(
                              child: TextFont(
                                text: 'No data available',
                                color: Theme.of(context).primaryColor,
                                poppin: true,
                              ),
                            ),
                          );
                        }
                        return Expanded(
                          child: AnimationLimiter(
                            child: ListView.builder(
                              padding: const EdgeInsets.all(8.0),
                              itemCount: controller.recenttampB.length,
                              itemBuilder: (context, index) {
                                final account = controller.recenttampB[index];
                                bool isSelected = selectedIndex == index;
                                return AnimationConfiguration.staggeredList(
                                  position: index,
                                  duration: const Duration(milliseconds: 500),
                                  child: SlideAnimation(
                                    verticalOffset: 50.0,
                                    child: FadeInAnimation(
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedIndex =
                                                index; // Set the selected index
                                            accountNumber.text = account
                                                    .serviceNumber ??
                                                ''; // Set the account number in the text field
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 20, horizontal: 10),
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? Theme.of(context)
                                                    .primaryColor
                                                    .withOpacity(0.1)
                                                : color_f4f4, // Change background color if selected
                                            border: Border.all(
                                              color: isSelected
                                                  ? Theme.of(context)
                                                      .primaryColor
                                                      .withOpacity(0.5)
                                                  : color_f4f4,
                                              width: isSelected
                                                  ? 2
                                                  : 1, // Change border width if selected
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Row(
                                            children: [
                                              Container(
                                                height: 54,
                                                width: 54,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                ),
                                                child: CachedNetworkImage(
                                                    imageUrl: controller
                                                            .tempBdetail
                                                            .value
                                                            .logo ??
                                                        ''),
                                              ),
                                              SizedBox(width: 10),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  TextFont(
                                                    text: account.accName ??
                                                        "No Name",
                                                    noto: true,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  TextFont(
                                                    text:
                                                        account.serviceNumber ??
                                                            "N/A",
                                                    poppin: true,
                                                    color: color_777,
                                                  ),
                                                ],
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
                        );
                      }),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: buildBottomAppbar(
          title: 'next',
          isEnabled: controller.enableBottom.value,
          func: () {
            formKey.currentState!.save();
            if (formKey.currentState!.validate()) {
              controller.enableBottom.value = false;
              controller.verifyAcc(
                  accountNumber.text, homeController.menudetail.value);
            }
          }),
    );
  }

  FormBuilder buildForm() {
    return FormBuilder(
      key: formKey,
      child: Column(
        children: [
          // Row(
          //   children: [
          //     Expanded(
          //       flex: 3,
          //       child: buildTextField(
          //         controller: accountNumber,
          //         label: 'bill_no',
          //         name: 'name',
          //         hintText: 'XXXXXXXXXX',
          //         fillcolor: color_f4f4,
          //         bordercolor: color_f4f4,
          //       ),
          //     ),
          //     SizedBox(width: 10),
          //     Container(
          //       height: 54,
          //       width: 54,
          //       decoration: BoxDecoration(
          //         color: color_primary_light,
          //         borderRadius: BorderRadius.circular(50),
          //       ),
          //       child: IconButton(
          //         onPressed: () async {
          //           final result = await Get.to(() => QRScannerScreen());
          //           if (result != null) {
          //             print(result);
          //           }
          //         },
          //         icon: Image.asset(
          //           'assets/icons/scan.png',
          //           // color: color_436,
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
          TextfieldWithScanButton(
            controller: accountNumber,
            label: "transaction_id",
            name: "qr_field",
            hintText: "XXXXXXXXXX...",
            buttonText: "Scan",
            fillcolor: color_f4f4,
            bordercolor: color_f4f4,
            onScanned: (scannedResult) {
              // Update the controller with the scanned result
              accountNumber.text = scannedResult;

              // Or perform other actions with the result
              print("Scanned QR Code: $scannedResult");
            },
          ),
        ],
      ),
    );
  }
}
