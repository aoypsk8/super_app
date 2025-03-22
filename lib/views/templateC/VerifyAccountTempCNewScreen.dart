// ignore_for_file: invalid_use_of_protected_member
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/controllers/home_controller.dart';
import 'package:super_app/controllers/payment_controller.dart';
import 'package:super_app/controllers/temp_c_controller.dart';
import 'package:super_app/controllers/user_controller.dart';
import 'package:super_app/services/helper/random.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/utility/dialog_helper.dart';
import 'package:super_app/utility/myconstant.dart';
import 'package:super_app/views/reusable_template/reusable_confirm.dart';
import 'package:super_app/views/reusable_template/reusable_getPaymentList.dart';
import 'package:super_app/widget/buildAppBar.dart';
import 'package:super_app/widget/buildBottomAppbar.dart';
import 'package:super_app/widget/buildTextField.dart';
import 'package:super_app/widget/build_pay_visa.dart';
import 'package:super_app/widget/build_step_process.dart';
import 'package:super_app/widget/input_cvv.dart';
import 'package:super_app/widget/myIcon.dart';
import 'package:super_app/widget/textfont.dart';

class VerifyAccountTempCNewScreen extends StatefulWidget {
  const VerifyAccountTempCNewScreen({super.key});

  @override
  State<VerifyAccountTempCNewScreen> createState() =>
      _VerifyAccountTempCNewScreenState();
}

class _VerifyAccountTempCNewScreenState
    extends State<VerifyAccountTempCNewScreen> {
  final homeController = Get.find<HomeController>();
  final userController = Get.find<UserController>();
  final paymentController = Get.put(PaymentController());
  final tempCcontroler = Get.put(TempCController());

  final storage = GetStorage();
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  final _accoutNumber = TextEditingController();

  List<Map<String, dynamic>> historyData = [];

  int? selectedOption = 1;

  int? selectedIndex;

  @override
  void initState() {
    userController.increasepage();
    _loadData();

    tempCcontroler.rxPrepaidShow.value = false;
    super.initState();
  }

  @override
  void dispose() {
    userController.decreasepage();
    super.dispose();
  }

  void _loadData() async {
    final box = GetStorage();
    String? jsonData = box.read('historyMobile');
    if (jsonData != null) {
      List<dynamic> data = json.decode(jsonData);
      List<Map<String, dynamic>> sortedData =
          List<Map<String, dynamic>>.from(data)
            ..sort((a, b) => b['timeStamp'].compareTo(a['timeStamp']));
      setState(() {
        historyData = sortedData;
      });
      print(historyData);
    }
  }

  void deleteData(String msisdn) async {
    final box = GetStorage();
    String? jsonData = box.read('historyMobile');
    if (jsonData != null) {
      List<dynamic> data = json.decode(jsonData);
      List<Map<String, dynamic>> sortedData =
          List<Map<String, dynamic>>.from(data)
            ..sort((a, b) => b['timeStamp'].compareTo(a['timeStamp']));

      // Find the index of the data to delete
      int indexToDelete = -1;
      for (int i = 0; i < sortedData.length; i++) {
        if (sortedData[i]['msisdn'] == msisdn) {
          indexToDelete = i;
          break;
        }
      }
      // Remove the data if found
      if (indexToDelete != -1) {
        sortedData.removeAt(indexToDelete);
        String newJsonData = json.encode(sortedData);
        await box.write('historyMobile', newJsonData);
        setState(() {
          historyData = sortedData;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: color_fff,
        appBar: BuildAppBar(
            title: tempCcontroler.tempCservicedetail.value.description!),
        body: FooterLayout(
          footer: buildBottomAppbar(
            isEnabled: tempCcontroler.enableBottom.value,
            title: tempCcontroler.rxPrepaidShow.value ? 'confirm' : 'next',
            func: () {
              tempCcontroler.enableBottom.value = false;
              tempCcontroler.rxNote.value = tempCcontroler
                  .tempCservicedetail.value.description
                  .toString();
              if (tempCcontroler.rxPrepaidShow.value) {
                if (tempCcontroler.rxTotalAmount.value != 0 &&
                    tempCcontroler.rxPaymentAmount.value != 0 &&
                    tempCcontroler.rxTotalAmount.value ==
                        tempCcontroler.rxPaymentAmount.value) {
                  //! Call Request CashOut
                  paymentController
                      .reqCashOut(
                          transID: tempCcontroler.rxTransID.value,
                          amount: tempCcontroler.rxTotalAmount.value,
                          toAcc: tempCcontroler.rxAccNo.value,
                          chanel: homeController.menudetail.value.groupNameEN,
                          provider:
                              "${tempCcontroler.tempCdetail.value.groupTelecom!}|${tempCcontroler.tempCservicedetail.value.name!}",
                          package: '',
                          remark: tempCcontroler.rxNote.value)
                      .then(
                        (value) => {
                          if (value)
                            {
                              tempCcontroler.enableBottom.value = true,
                              Get.to(ListsPaymentScreen(
                                description:
                                    homeController.menudetail.value.appid!,
                                stepBuild: '5/6',
                                title: homeController.getMenuTitle(),
                                onSelectedPayment: (paymentType, cardIndex,
                                    uuid, logo, accName, cardNumber) async {
                                  if (paymentType == "Other") {
                                    // homeController.RxamountUSD.value =
                                    //     await homeController.convertRate(
                                    //         tempCcontroler.rxTotalAmount.value);
                                    // tempCcontroler.rxTransID.value =
                                    //     "XX${homeController.menudetail.value.description! + await randomNumber().fucRandomNumber()}";
                                    // Get.to(PaymentVisaMasterCard(
                                    //   function: () {
                                    //     tempCcontroler
                                    //         .paymentPrepaidVisaWithoutstoredCardUniqueID(
                                    //       homeController.menudetail.value,
                                    //     );
                                    //   },
                                    //   trainID: tempCcontroler.rxTransID.value,
                                    //   description: tempCcontroler.rxNote.value,
                                    //   amount:
                                    //       tempCcontroler.rxTotalAmount.value,
                                    // ));
                                  } else if (paymentType == 'MMONEY') {
                                    navigateToConfirmScreen(paymentType);
                                  } else {
                                    String? cvv = await showDynamicQRDialog(
                                        context, () {});
                                    if (cvv != null &&
                                        cvv.isNotEmpty &&
                                        cvv.length >= 3) {
                                      navigateToConfirmScreen(paymentType, cvv,
                                          uuid, logo, accName, cardNumber);
                                    } else {
                                      DialogHelper.showErrorDialogNew(
                                        description: "please_input_cvv",
                                      );
                                    }
                                  }
                                },
                              ))
                            }
                          else
                            {
                              tempCcontroler.enableBottom.value = true,
                            }
                        },
                      );
                } else {
                  tempCcontroler.enableBottom.value = true;
                  DialogHelper.showErrorDialogNew(
                      description: 'Please select your amount.');
                }
              } else {
                _formKey.currentState!.save();
                if (_formKey.currentState!.validate()) {
                  FocusScope.of(context).requestFocus(FocusNode());
                  tempCcontroler.verifyAcc(_accoutNumber.text);
                } else {
                  tempCcontroler.enableBottom.value = true;
                }
              }
            },
          ),
          child: SingleChildScrollView(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    buildStepProcess(
                      title: tempCcontroler.rxPrepaidShow.value ? "4/6" : "3/6",
                      desc: "input_phone_number",
                    ),
                    const SizedBox(height: 10),
                    buildForm(),
                    const SizedBox(height: 15),
                    tempCcontroler.rxPrepaidShow.value
                        ? showPrepaidSelectMenu()
                        : buildRecent(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget showPrepaidSelectMenu() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFont(
          text: 'select_your_amount',
        ),
        SizedBox(height: 10),
        AnimationLimiter(
          child: AlignedGridView.count(
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            shrinkWrap: true,
            itemCount: tempCcontroler.tempCprepaidmodel.length,
            primary: false,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 400),
                child: SlideAnimation(
                  child: FlipAnimation(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                        tempCcontroler.rxTotalAmount.value = tempCcontroler
                            .tempCprepaidmodel.value[index].amount!;
                        tempCcontroler.rxPaymentAmount.value = tempCcontroler
                            .tempCprepaidmodel.value[index].amount!;
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: selectedIndex == index ? cr_fdeb : color_f4f4,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: selectedIndex == index ? cr_ef33 : color_fff,
                          ),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: TextFont(
                              text: fn.format(
                                double.parse(
                                  tempCcontroler
                                      .tempCprepaidmodel.value[index].amount
                                      .toString(),
                                ),
                              ),
                              color: color_blackE72,
                              poppin: true,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget buildRecent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(Iconsax.clock, color: Colors.black),
              const SizedBox(width: 5),
              TextFont(text: 'recent'),
            ],
          ),
          SizedBox(height: 10.sp),
          historyData.isEmpty ? buildEmptyRecent() : buildRecentLists()
        ],
      ),
    );
  }

  ListView buildRecentLists() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: historyData.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: color_fff,
            border: Border.all(
              color: color_ddd,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _accoutNumber.text =
                          historyData[index]['msisdn'].toString();
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      children: [
                        SvgPicture.asset(MyIcon.ic_user,
                            fit: BoxFit.fill, width: 7.w),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextFont(
                                  text: historyData[index]['msisdn'],
                                  poppin: true,
                                  fontSize: 10.5,
                                ),
                                TextFont(
                                  text: historyData[index]['mobileType'],
                                  color: color_777,
                                  maxLines: 1,
                                  fontSize: 9,
                                  noto: true,
                                ),
                                TextFont(
                                  text: historyData[index]['timeStamp'],
                                  fontSize: 7,
                                  color: color_777,
                                  poppin: true,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                child: Row(
                  children: [
                    GestureDetector(
                        onTap: () {
                          deleteData(
                            (historyData[index]['msisdn']),
                          );
                        },
                        child: const Icon(Icons.close, color: color_999))
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget buildEmptyRecent() {
    return Column(
      children: [
        SizedBox(height: 50.sp),
        Image.asset(MyIcon.ic_box_open_bg, width: 25.w),
        TextFont(text: 'no_item_found', color: color_999),
      ],
    );
  }

  Widget buildForm() {
    return FormBuilder(
      key: _formKey,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: buildNumberFiledValidate(
                  controller: _accoutNumber,
                  label: 'msisdn',
                  name: 'msisdn',
                  hintText: '20XXXXXXXX',
                  max: 10,
                  fillcolor: color_f4f4,
                  bordercolor: color_f4f4,
                  textType:
                      tempCcontroler.tempCservicedetail.value.name == "INTERNET"
                          ? TextInputType.text
                          : TextInputType.number,
                  suffixIcon: Container(
                    padding: const EdgeInsets.all(10),
                    child: SvgPicture.asset(
                      MyIcon.ic_contact,
                    ),
                  ),
                  suffixonTapFuc: () async {
                    // if (await Permission.contacts.request().isGranted) {
                    //   try {
                    //     final Contact? contact =
                    //         await ContactsService.openDeviceContactPicker();
                    //     if (contact != null) {
                    //       final Item phone = contact.phones!.first;
                    //       String phoneNO = phone.value
                    //           .toString()
                    //           .trim()
                    //           .replaceAll(' ', '')
                    //           .replaceAll('-', '');
                    //       if (phoneNO.startsWith('020')) {
                    //         setState(() {
                    //           _accoutNumber.text =
                    //               phoneNO.replaceAll("020", "20");
                    //         });
                    //       } else if (phoneNO.startsWith('+85620')) {
                    //         setState(() {
                    //           _accoutNumber.text =
                    //               phoneNO.replaceAll("+85620", "20");
                    //         });
                    //       } else if (phoneNO.startsWith('85620')) {
                    //         setState(() {
                    //           _accoutNumber.text =
                    //               phoneNO.replaceAll("85620", "20");
                    //         });
                    //       } else {
                    //         setState(() {
                    //           _accoutNumber.text = phoneNO;
                    //         });
                    //       }
                    //     }
                    //     setState(() {
                    //       // _contactName = contact!.displayName.toString();
                    //     });
                    //   } on FormOperationException catch (e) {
                    //     switch (e.errorCode) {
                    //       case FormOperationErrorCode.FORM_OPERATION_CANCELED:
                    //       case FormOperationErrorCode.FORM_COULD_NOT_BE_OPEN:
                    //       case FormOperationErrorCode
                    //             .FORM_OPERATION_UNKNOWN_ERROR:
                    //       default:
                    //       // print(e.toString());
                    //     }
                    //   }
                    // }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildHeader(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(0.00, -1.00),
              end: Alignment(0, 1),
              colors: [Color(0xffF14D58), Color(0xFFED1C29)],
            ),
          ),
          child: SafeArea(
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: color_fff,
                    size: 25,
                  ),
                  onPressed: () => Get.back(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextFont(
                    text: tempCcontroler.tempCservicedetail.value.description!,
                    fontWeight: FontWeight.bold,
                    fontSize: 12.5,
                    color: color_fff,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: -10,
          right: -50,
          bottom: 0,
          child: SvgPicture.asset(
            MyIcon.bg_gradient1,
            fit: BoxFit.fill,
          ),
        ),
      ],
    );
  }

  void navigateToConfirmScreen(
    String paymentType, [
    String cvv = '',
    String storedCardUniqueID = '',
    String? logo,
    String accName = '',
    String cardNumber = '',
  ]) {
    logo ??= MyConstant.profile_default;
    Get.to(
      ReusableConfirmScreen(
        isEnabled: tempCcontroler.enableBottom,
        appbarTitle: "confirm_payment",
        function: () {
          if (paymentType == 'MMONEY') {
            tempCcontroler.enableBottom.value = false;
            tempCcontroler.paymentPrepaid(homeController.menudetail.value);
          } else {
            tempCcontroler.paymentPrepaidVisa(
              homeController.menudetail.value,
              storedCardUniqueID,
              cvv,
              paymentType,
              logo!,
              accName,
              cardNumber,
            );
          }
        },
        stepProcess: "6/6",
        stepTitle: "check_detail",
        fromAccountImage: paymentType == 'MMONEY'
            ? userController.userProfilemodel.value.profileImg ??
                MyConstant.profile_default
            : logo,
        fromAccountName: paymentType == 'MMONEY'
            ? '${userController.userProfilemodel.value.name.toString()} ${userController.userProfilemodel.value.surname.toString()}'
            : accName,
        fromAccountNumber: paymentType == 'MMONEY'
            ? userController.userProfilemodel.value.msisdn.toString()
            : cardNumber,
        toAccountImage: MyConstant.profile_default,
        toAccountName:
            tempCcontroler.tempCservicedetail.value.description.toString(),
        toAccountNumber: _accoutNumber.text,
        amount: tempCcontroler.rxTotalAmount.toString(),
        fee: '0',
        note: tempCcontroler.tempCservicedetail.value.description.toString(),
      ),
    );
  }
}
