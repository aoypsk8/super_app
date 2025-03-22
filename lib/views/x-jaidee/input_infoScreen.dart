import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:super_app/controllers/xjaidee_controller.dart';
import 'package:super_app/utility/myconstant.dart';
import 'package:super_app/views/image_preview.dart';
import 'package:super_app/widget/buildAppBar.dart';
import 'package:super_app/widget/buildTextField.dart';
import 'package:super_app/widget/textfont.dart';

import '../../utility/color.dart';
import '../../utility/dialog_helper.dart';
import '../../widget/buildBottomAppbar.dart';

class InputInfoXJaideeScreen extends StatefulWidget {
  const InputInfoXJaideeScreen({super.key});

  @override
  State<InputInfoXJaideeScreen> createState() => _InputInfoXJaideeScreenState();
}

class _InputInfoXJaideeScreenState extends State<InputInfoXJaideeScreen> {
  final XjaideeController xjaidee = Get.find<XjaideeController>();
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final TextEditingController _empID = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _surname = TextEditingController();
  final TextEditingController _msisdn = TextEditingController();
  final TextEditingController _contact = TextEditingController();
  final TextEditingController _department = TextEditingController();
  final TextEditingController _section = TextEditingController();
  final TextEditingController _dob = TextEditingController();
  final TextEditingController _swd = TextEditingController();
  final TextEditingController _img = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _paymentAmount = TextEditingController();
  final TextEditingController _months = TextEditingController();
  final TextEditingController _percent = TextEditingController();
  final TextEditingController _monthlyPayment = TextEditingController();

  @override
  void initState() {
    super.initState();
    _empID.text = xjaidee.rxEmpID.value;
    _name.text = xjaidee.rxName.value;
    _surname.text = xjaidee.rxSurname.value;
    _msisdn.text = xjaidee.rxMsisdn.value;
    _department.text = xjaidee.rxDepartment.value;
    _section.text = xjaidee.rxSection.value;
    _dob.text = xjaidee.rxDOB.value;
    _swd.text = xjaidee.rxSWD.value;
    _img.text = xjaidee.rxImg.value;
    _paymentAmount.text = fn.format(xjaidee.paymentAmount.value);
    _months.text = xjaidee.months.value;
    _percent.text = xjaidee.percent.value;
    _monthlyPayment.text = fn.format(xjaidee.monthlyPayment.value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color_fff,
      appBar: BuildAppBar(title: "ຢືມສິນເຊື່ອ"),
      bottomNavigationBar: buildBottomAppbar(
        bgColor: Theme.of(context).primaryColor,
        title: 'confirm',
        func: () async {
          xjaidee.rxContact.value = _contact.text;
          xjaidee.rxDescription.value = _description.text;

          if (_description.text.isEmpty) {
            FocusScope.of(context)
                .requestFocus(FocusNode()); // Close keyboard first
            Future.delayed(Duration(milliseconds: 200), () {
              FocusScope.of(context).requestFocus(FocusNode()); // Reset focus
              FocusScope.of(context).requestFocus(); // Set focus
            });

            DialogHelper.showErrorDialogNew(
                description: 'ກະລຸນາປ້ອນຈຸດປະສົງການກູ້ຢືມເງີນ');
            return;
          }
          if (_formKey.currentState!.validate()) {
            await xjaidee.SaveInfo();
          }
        },
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: FormBuilder(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  buildLoanFiledValidate(
                    enable: false,
                    controller: _empID,
                    label: 'ລະຫັດພະນັກງານ',
                    name: '',
                    hintText: '',
                    fillcolor: color_f4f4,
                    bordercolor: color_f4f4,
                  ),
                  const SizedBox(height: 10),
                  buildLoanFiledValidate(
                    enable: false,
                    controller: _name,
                    label: 'ຊື່',
                    name: '',
                    hintText: '',
                    fillcolor: color_f4f4,
                    bordercolor: color_f4f4,
                  ),
                  const SizedBox(height: 10),
                  buildLoanFiledValidate(
                    enable: false,
                    controller: _surname,
                    label: 'ນາມສະກຸນ',
                    name: '',
                    hintText: '',
                    fillcolor: color_f4f4,
                    bordercolor: color_f4f4,
                  ),
                  const SizedBox(height: 10),
                  buildLoanFiledValidate(
                    enable: false,
                    controller: _msisdn,
                    label: 'ເບີໂທພະນັກງານ',
                    name: '',
                    hintText: '',
                    fillcolor: color_f4f4,
                    bordercolor: color_f4f4,
                  ),
                  const SizedBox(height: 10),
                  buildLoanFiledValidate(
                    enable: true,
                    controller: _contact,
                    label: 'ເບີຕິດຕໍ່',
                    name: 'contact',
                    hintText: '',
                    fillcolor: color_f4f4,
                    bordercolor: color_f4f4,
                  ),
                  const SizedBox(height: 10),
                  buildLoanFiledValidate(
                    enable: false,
                    controller: _department,
                    label: 'ສັງກັດຢູ່ພະແນກ',
                    name: '',
                    hintText: '',
                    fillcolor: color_f4f4,
                    bordercolor: color_f4f4,
                  ),
                  const SizedBox(height: 10),
                  buildLoanFiledValidate(
                    enable: false,
                    controller: _section,
                    label: 'ສັງກັດຢູ່ພາກສ່ວນ',
                    name: '',
                    hintText: '',
                    fillcolor: color_f4f4,
                    bordercolor: color_f4f4,
                  ),
                  const SizedBox(height: 10),
                  buildLoanFiledValidate(
                    enable: false,
                    controller: _dob,
                    label: 'ວັນເດືອນປີເກີດ',
                    name: '',
                    hintText: '',
                    fillcolor: color_f4f4,
                    bordercolor: color_f4f4,
                  ),
                  const SizedBox(height: 10),
                  buildLoanFiledValidate(
                    enable: false,
                    controller: _swd,
                    label: 'ວັນເດືອນປີເຂົ້າການ',
                    name: '',
                    hintText: '',
                    fillcolor: color_f4f4,
                    bordercolor: color_f4f4,
                  ),
                  const SizedBox(height: 10),
                  buildLoanFiledValidate(
                    enable: false,
                    controller: _paymentAmount,
                    label: 'ຈຳນວນເງີນທີ່ຢືມ',
                    name: '',
                    hintText: '',
                    fillcolor: color_f4f4,
                    bordercolor: color_f4f4,
                  ),
                  const SizedBox(height: 10),
                  buildLoanFiledValidate(
                    enable: false,
                    controller: _months,
                    label: 'ຈຳນວນເດືອນຜ່ອນຊຳລະ',
                    name: '',
                    hintText: '',
                    fillcolor: color_f4f4,
                    bordercolor: color_f4f4,
                  ),
                  const SizedBox(height: 10),
                  buildLoanFiledValidate(
                    enable: false,
                    controller: _percent,
                    label: 'ເປີເຊັນການຜ່ອນຊຳລະ',
                    name: '',
                    hintText: '',
                    fillcolor: color_f4f4,
                    bordercolor: color_f4f4,
                  ),
                  const SizedBox(height: 10),
                  buildLoanFiledValidate(
                    enable: false,
                    controller: _monthlyPayment,
                    label: 'ຈຳນວນເດືອນຜ່ອນຊຳລະ / ເດືອນ',
                    name: '',
                    hintText: '',
                    fillcolor: color_f4f4,
                    bordercolor: color_f4f4,
                  ),
                  const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFont(
                        text: 'ບັດປະຈຳຄົວ ຫຼື ສຳມະໂນຄົວ',
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          if (_img.text.isNotEmpty) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ImagepreviewScreen(
                                  imageUrl: _img.text,
                                  title: 'Preview',
                                ),
                              ),
                            );
                          }
                        },
                        child: Image.network(
                          _img.text.isNotEmpty
                              ? _img.text
                              : MyConstant.profile_default,
                          height: 350,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.network(
                              MyConstant.profile_default,
                              height: 300,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  BuildTextAreaValidate(
                    max: 150,
                    controller: _description,
                    label: 'ຈຸດປະສົງການຂໍກູ້ຢືມເງີນ',
                    name: '',
                    hintText: '',
                    fillcolor: color_f4f4,
                    Isvalidate: true,
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
