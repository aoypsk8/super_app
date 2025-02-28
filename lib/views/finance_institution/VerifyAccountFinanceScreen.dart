import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/controllers/finance_controller.dart';
import 'package:super_app/controllers/home_controller.dart';
import 'package:super_app/controllers/user_controller.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/views/reusable_template/reusable_getPaymentList.dart';
import 'package:super_app/widget/buildAppBar.dart';
import 'package:super_app/widget/buildBottomAppbar.dart';
import 'package:super_app/widget/buildTextField.dart';
import 'package:super_app/widget/build_step_process.dart';
import 'package:super_app/widget/myIcon.dart';
import 'package:super_app/widget/textfont.dart';

class VerifyAccountFinanceScreen extends StatefulWidget {
  const VerifyAccountFinanceScreen({super.key});

  @override
  State<VerifyAccountFinanceScreen> createState() =>
      _VerifyAccountFinanceScreenState();
}

class _VerifyAccountFinanceScreenState
    extends State<VerifyAccountFinanceScreen> {
  final UserController userController = Get.find();
  final HomeController homeController = Get.find();
  final financeController = Get.put(FinanceController());

  @override
  void initState() {
    userController.increasepage();
    super.initState();
    financeController.getToken();
    _loadData();
  }

  @override
  void dispose() {
    userController.decreasepage();
    super.dispose();
  }

  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final _accoutNumber = TextEditingController();

  List<Map<String, dynamic>> historyData = [];

  void _loadData() async {
    final box = GetStorage();
    String? jsonData = box.read('historyFinance');
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
    String? jsonData = box.read('historyFinance');
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
        await box.write('historyFinance', newJsonData);
        setState(() {
          historyData = sortedData;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: Scaffold(
          backgroundColor: color_fff,
          appBar: BuildAppBar(
              title: financeController.financeModelDetail.value.title!),
          body: SingleChildScrollView(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Container(
                  color: cr_fbf7,
                  child: Column(
                    children: [
                      Container(
                        color: color_fff,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // TextFont(
                              //   text: 'account_number',
                              //   fontWeight: FontWeight.w500,
                              //   fontSize: 12,
                              // ),
                              buildStepProcess(
                                  title: "2/4", desc: "input_account_number"),
                              SizedBox(height: 5.sp),
                              FormBuilder(
                                key: _formKey,
                                child: billform(),
                              ),
                              SizedBox(height: 10.sp),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      Container(
                        color: color_fff,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFont(
                                text: 'history',
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                              SizedBox(height: 10.sp),
                              Center(
                                child: historyData.isEmpty
                                    ? buildEmptyRecent()
                                    : buildRecentLists(),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.only(top: 20),
            child: buildBottomAppbar(
              title: 'next',
              // radius: 20,
              func: () {
                // Get.toNamed("/paymentFinace");
                _formKey.currentState!.save();
                if (_formKey.currentState!.validate()) {
                  Get.to(
                    ListsPaymentScreen(
                      description: homeController.menudetail.value.groupNameEN
                          .toString(),
                      stepBuild: '2/3',
                      title: homeController.getMenuTitle(),
                      onSelectedPayment: (paymentType, cardIndex) {
                        financeController.rxAccNo.value = _accoutNumber.text;
                        financeController.verifyAccount();
                      },
                    ),
                  );
                  return Container();
                }
              },
            ),
          ),
        ),
      ),
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

  ListView buildRecentLists() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: historyData.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: color_ddd),
                borderRadius: BorderRadius.circular(
                  10,
                )),
            padding: const EdgeInsets.symmetric(vertical: 5),
            // margin: const EdgeInsets.symmetric(horizontal: 10),
            child: InkWell(
              onTap: () {
                setState(() {
                  _accoutNumber.text = historyData[index]['msisdn'].toString();
                });
              },
              child: ListTile(
                leading: Container(
                  width: 40.sp,
                  decoration: BoxDecoration(
                      color: color_fbd,
                      borderRadius: BorderRadius.circular(10)),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: SvgPicture.asset('images/icon/user-square.svg'),
                  ),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFont(
                      text: historyData[index]['msisdn'],
                      // fontWeight: FontWeight.w700,
                      poppin: true,
                      fontSize: 10.5,
                    ),
                    TextFont(
                      text: historyData[index]['fullname'],
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
          ),
        );
      },
    );
  }

  Widget billform() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Expanded(
              child: buildNumberFiledValidate(
                controller: _accoutNumber,
                label: 'account_number',
                name: 'accountNumber',
                hintText: 'XXXXXXXX',
                max: 16,
                fillcolor: color_f4f4,
                bordercolor: color_f4f4,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
