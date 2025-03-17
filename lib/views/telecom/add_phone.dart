import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/widget/buildBottomAppbar.dart';
import 'package:super_app/widget/buildTextField.dart';
import 'package:super_app/widget/myIcon.dart';
import 'package:super_app/widget/textfont.dart';

class AddPhonePage extends StatefulWidget {
  const AddPhonePage({super.key});

  @override
  State<AddPhonePage> createState() => _AddPhonePageState();
}

class _AddPhonePageState extends State<AddPhonePage> {
  final phoneController = TextEditingController();
  late PageController pageViewController;
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    pageViewController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageViewController.dispose();
  }

  void handlePageViewChange(int e) {
    setState(() {
      currentPage = e;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(right: 20, left: 20, top: 20),
            child: Stack(
              children: [
                body(),
                appBarBackBtn(),
                appBarTitle(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: bottomNavBtn());
  }

  Widget body() {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: PageView(
        controller: pageViewController,
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: handlePageViewChange,
        children: [inputContact(), comfirmOTP()],
      ),
    );
  }

  Widget comfirmOTP() {
    return Padding(
      padding: const EdgeInsets.only(top: 60, right: 40, left: 40),
      child: Column(
        children: [
          Image.asset(
            MyIcon.ic_phone_otp,
            height: 30.w,
          ),
          TextFont(
            text:
                'ກະລຸນາປ້ອນລະຫັດ OTP ທາງພວກເຮົາໄດ້ສົ່ງຫາໝາຍເລກ ${phoneController.text}',
            maxLines: 3,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }

  Widget inputContact() {
    return FormBuilder(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.only(top: 80),
        child: Column(
          children: [
            buildPhoneEmailValidate(
              controller: phoneController,
              label: 'ປ້ອນໝາຍເລກໂທລະສັບ',
              name: '',
              hintText: '205XXXXXXX',
              textType: TextInputType.number,
              fillcolor: cr_eded,
              borderColor: cr_eded,
            ),
            SizedBox(height: 20),
            InkWell(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1.5, color: Color(0xFFEC1C29)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      MyIcon.ic_contact_line,
                      width: 5.w,
                    ),
                    SizedBox(width: 20),
                    TextFont(
                      text: 'ເລືອກເບີຈາກເຄື່ອງ',
                      fontSize: 11,
                      color: cr_red,
                      fontWeight: FontWeight.w500,
                    )
                  ],
                ),
              ),
              onTap: () async {
                if (await Permission.contacts.request().isGranted) {
                  try {
                    final Contact? contact =
                        await ContactsService.openDeviceContactPicker();
                    if (contact != null) {
                      final Item phone = contact.phones!.first;
                      String phoneNO = phone.value
                          .toString()
                          .trim()
                          .replaceAll(' ', '')
                          .replaceAll('-', '');
                      if (phoneNO.startsWith('020')) {
                        setState(() {
                          phoneController.text =
                              phoneNO.replaceAll("020", "20");
                        });
                      } else if (phoneNO.startsWith('+85620')) {
                        setState(() {
                          phoneController.text =
                              phoneNO.replaceAll("+85620", "20");
                        });
                      } else if (phoneNO.startsWith('85620')) {
                        setState(() {
                          phoneController.text =
                              phoneNO.replaceAll("85620", "20");
                        });
                      } else {
                        setState(() {
                          phoneController.text = phoneNO;
                        });
                      }
                    }
                    setState(() {
                      // _contactName = contact!.displayName.toString();
                    });
                  } on FormOperationException catch (e) {
                    switch (e.errorCode) {
                      case FormOperationErrorCode.FORM_OPERATION_CANCELED:
                      case FormOperationErrorCode.FORM_COULD_NOT_BE_OPEN:
                      case FormOperationErrorCode.FORM_OPERATION_UNKNOWN_ERROR:
                      default:
                      // print(e.toString());
                    }
                  }
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Widget appBarTitle() {
    return Align(
      alignment: Alignment.topCenter,
      child: TextFont(
        text: 'ເພິ່ມໝາຍເລກໂທລະສັບ',
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget appBarBackBtn() {
    return Positioned(
        right: 0,
        child: InkWell(
            onTap: () => Get.back(),
            child: SvgPicture.asset(
              MyIcon.deleteX_round,
              width: 10.w,
              height: 10.w,
            )));
  }

  Widget bottomNavBtn() {
    return Container(
      padding: EdgeInsets.only(top: 20),
      child: buildBottomAppbar(
        radius: 8,
        bgColor: currentPage == 0 ? cr_ef33 : cr_fbf7,
        title: currentPage == 0 ? 'ຖັດໄປ' : 'ກັບຄືນ',
        textColor: currentPage == 0 ? color_fff : color_blackE72,
        borderColor: currentPage == 0 ? cr_ef33 : color_blackE72,
        func: () {
          if (currentPage == 1) {
            pageViewController.animateToPage(currentPage - 1,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut);
          } else {
            _formKey.currentState!.save();
            if (_formKey.currentState!.validate()) {
              pageViewController.animateToPage(currentPage + 1,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut);
            }
          }
        },
      ),
    );
  }
}
