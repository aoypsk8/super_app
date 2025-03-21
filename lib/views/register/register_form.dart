import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/controllers/user_controller.dart';
import 'package:super_app/models/kyc_model.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/utility/myIcon.dart';
import 'package:super_app/views/image_preview.dart';
import 'package:super_app/widget/buildAppBar.dart';
import 'package:super_app/widget/buildBottomAppbar.dart';
import 'package:super_app/widget/buildButtonBottom.dart';
import 'package:super_app/widget/buildTextField.dart';
import 'package:super_app/widget/mounoy_textfield.dart';
import 'package:super_app/widget/textfont.dart';

class RegisterFormScreen extends StatefulWidget {
  const RegisterFormScreen({super.key, required this.regType});
  final String regType;

  @override
  State<RegisterFormScreen> createState() => _RegisterFormScreenState();
}

class _RegisterFormScreenState extends State<RegisterFormScreen> {
  final userControler = Get.find<UserController>();
  final _formKey = GlobalKey<FormBuilderState>();
  final _fname = TextEditingController();
  final _lname = TextEditingController();
  final _province = TextEditingController();
  final _district = TextEditingController();
  final _village = TextEditingController();
  final _cardID = TextEditingController();
  final _birthday = TextEditingController();
  DateTime _dateTime = DateTime(2000, 1, 1);
  String? _gender;
  bool _genderMale = true;

  String welcomeText = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadData();
    if (widget.regType == "UnApproved") {
      welcomeText = 'Welcome M moneyX users';
    } else {
      welcomeText = 'Welcome M-Money users';
    }
  }

  _loadData() async {
    _fname.text = userControler.kycModel.value.data?.firstName ?? '';
    _lname.text = userControler.kycModel.value.data?.lastName ?? '';
    var bd = userControler.kycModel.value.data?.birthday?.toString() ?? '';
    if (bd != null && bd.isNotEmpty) {
      try {
        DateTime parsedDate;
        if (bd.contains('/')) {
          List<String> parts = bd.split('/');
          parsedDate = DateTime(
            int.parse(parts[2]),
            int.parse(parts[1]),
            int.parse(parts[0]),
          );
        } else {
          parsedDate = DateTime.parse(bd);
        }
        _birthday.text = DateFormat('yyyy-MM-dd').format(parsedDate);
        _dateTime = parsedDate; // also update _dateTime used in date picker
      } catch (e) {
        _birthday.text = '';
      }
    }

    // if (bd.contains('/')) {
    //   List<String> dateComponents = bd.split('/');
    //   _birthday.text =
    //       '${dateComponents[2]}-${dateComponents[1]}-${dateComponents[0]}';
    // }
    var address = userControler.kycModel.value.data?.address?.toString() ?? '';
    if (address.contains(',')) {
      List<String> dateComponents = address.split(',');
      _village.text = dateComponents[0].replaceAll('ບ້ານ', '').trim();
      _district.text = dateComponents[1].replaceAll('ເມືອງ', '').trim();
    }
    var sex = userControler.kycModel.value.data!.gender;
    if (sex == 'M') {
      _genderMale = true;
      _gender = 'male';
    } else {
      _genderMale = false;
      _gender = 'female';
    }
    var province = userControler.kycModel.value.data!.province;
    switch (province) {
      case 'ນະຄອນຫຼວງວຽງຈັນ':
        _provinceCode = 'VTE';
        _province.text = 'VTE';
        break;
      case 'ວຽງຈັນ':
        _provinceCode = 'VTP';
        _province.text = 'VTP';
        break;
      case 'ບໍລິຄຳໄຊ':
        _provinceCode = 'BKX';
        _province.text = 'BKX';
        break;
      case 'ອຸດົມໄຊ':
        _provinceCode = 'UDX';
        _province.text = 'UDX';
        break;
      case 'ຫຼວງພະບາງ':
        _provinceCode = 'LPB';
        _province.text = 'LPB';
        break;
      case 'ຫຼວງນ້ຳທາ':
        _provinceCode = 'LNT';
        _province.text = 'LNT';
        break;
      case 'ຊຽງຂວາງ':
        _provinceCode = 'XKG';
        _province.text = 'XKG';
        break;
      case 'ຫົວພັນ':
        _provinceCode = 'HPN';
        _province.text = 'HPN';
        break;
      case 'ຜົ້ງສາລີ':
        _provinceCode = 'PSL';
        _province.text = 'PSL';
        break;
      case 'ບໍ່ແກ້ວ':
        _provinceCode = 'BOK';
        _province.text = 'BOK';
        break;
      case 'ໄຊສົມບູນ':
        _provinceCode = 'XBS';
        _province.text = 'XBS';
        break;
      case 'ອັດຕະປື':
        _provinceCode = 'ATP';
        _province.text = 'ATP';
        break;
      case 'ຈຳປາສັກ':
        _provinceCode = 'CPS';
        _province.text = 'CPS';
        break;
      case 'ໄຊຍະບູລີ':
        _provinceCode = 'XAY';
        _province.text = 'XAY';
        break;
      case 'ສະຫວັນນະເຂດ':
        _provinceCode = 'SVK';
        _province.text = 'SVK';
        break;
      case 'ສາລະວັນ':
        _provinceCode = 'SLV';
        _province.text = 'SLV';
        break;
      case 'ເຊກອງ':
        _provinceCode = 'XEK';
        _province.text = 'XEK';
        break;
      case 'ຄຳມ່ວນ':
        _provinceCode = 'KMN';
        _province.text = 'KMN';
      default:
        _provinceCode = 'VTE';
        _province.text = 'VTE';
    }
  }

  String _provinceCode = '';
  var dataProvice = [
    {
      "proid": 1,
      "Name": "ນະຄອນຫຼວງວຽງຈັນ",
      "Code": "VTE",
      "Description": "NULL"
    },
    {"proid": 2, "Name": "ວຽງຈັນ", "Code": "VTP", "Description": "NULL"},
    {"proid": 3, "Name": "ບໍລິຄຳໄຊ", "Code": "BKX", "Description": "NULL"},
    {"proid": 4, "Name": "ອຸດົມໄຊ", "Code": "UDX", "Description": "NULL"},
    {"proid": 5, "Name": "ຫຼວງພະບາງ", "Code": "LPB", "Description": "NULL"},
    {"proid": 6, "Name": "ຫຼວງນ້ຳທາ", "Code": "LNT", "Description": "NULL"},
    {"proid": 7, "Name": "ຊຽງຂວາງ", "Code": "XKG", "Description": "NULL"},
    {"proid": 8, "Name": "ຫົວພັນ", "Code": "HPN", "Description": "NULL"},
    {"proid": 9, "Name": "ຜົ້ງສາລີ", "Code": "PSL", "Description": "NULL"},
    {"proid": 10, "Name": "ບໍ່ແກ້ວ", "Code": "BOK", "Description": "NULL"},
    {"proid": 11, "Name": "ໄຊສົມບູນ", "Code": "XBS", "Description": "NULL"},
    {"proid": 12, "Name": "ອັດຕະປື", "Code": "ATP", "Description": "NULL"},
    {"proid": 13, "Name": "ຈຳປາສັກ", "Code": "CPS", "Description": "NULL"},
    {"proid": 14, "Name": "ໄຊຍະບູລີ", "Code": "XAY", "Description": "NULL"},
    {"proid": 15, "Name": "ສະຫວັນນະເຂດ", "Code": "SVK", "Description": "NULL"},
    {"proid": 16, "Name": "ສາລະວັນ", "Code": "SLV", "Description": "NULL"},
    {"proid": 17, "Name": "ເຊກອງ", "Code": "XEK", "Description": "NULL"},
    {"proid": 18, "Name": "ຄຳມ່ວນ", "Code": "KMN", "Description": "NULL"}
  ];

  @override
  Widget build(BuildContext context) {
    print(_birthday.text);
    return Scaffold(
      backgroundColor: color_fff,
      appBar: BuildAppBar(title: 'register_form'),
      body: Obx(
        () => SingleChildScrollView(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: FormBuilder(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // InkWell(
                    //   onTap: () {
                    //     userControler.queryKYC_5_7('2052142702');
                    //     setState(() {
                    //       _loadData();
                    //     });
                    //   },
                    //   child: TextFont(text: 'queryKYC_5_7'),
                    // ),
                    buildHeader(),
                    Divider(color: color_ecec),
                    SizedBox(height: 15),
                    SizedBox(height: 8),
                    buildTextField(
                        controller: _fname,
                        label: 'fname',
                        name: 'fname',
                        hintText: '',
                        isEditable: true),
                    buildTextField(
                        controller: _lname,
                        label: 'lname',
                        name: 'lname',
                        hintText: '',
                        isEditable: true),
                    // FormBuilderDateTimePicker(
                    //   name: 'birthday',
                    //   controller: _birthday,
                    //   inputType: InputType.date,
                    //   decoration: InputDecoration(
                    //     labelText: 'Birthday',
                    //     hintText: '',
                    //     labelStyle: TextStyle(color: color_2929),
                    //     hintStyle: TextStyle(color: color_2929),
                    //   ),
                    //   format: DateFormat('yyyy-MM-dd'),
                    //   onChanged: (value) {
                    //     _birthday.text = value != null
                    //         ? DateFormat('yyyy-MM-dd').format(value)
                    //         : '';
                    //   },
                    //   initialValue: _birthday.text.isNotEmpty
                    //       ? DateTime.tryParse(_birthday.text)
                    //       : DateTime(2003, 10, 31),
                    //   enabled: true,
                    // ),
                    buildSelectDate(context),
                    buildSelectGender(),
                    Divider(color: color_ecec),
                    // SizedBox(height: 8),
                    // TextFont(text: 'input_profile', color: cr_b326),
                    SizedBox(height: 8),
                    BuildDropDown(
                      controller: _province,
                      name: "province",
                      label: "province",
                      hintText: "",
                      dataObject: dataProvice, // Pass your list
                      colName: "Code", // Column for display text
                      valName: "Code", // Column for value

                      initValue: '$_provinceCode-$_provinceCode',
                      onChanged: (value) {
                        List<String> province = value.toString().split('-');
                        _provinceCode = province[0];
                        _province.text = province[0];
                      },
                    ),
                    buildTextField(
                        controller: _district,
                        label: 'district',
                        name: 'district'),
                    buildTextField(
                        controller: _village,
                        label: 'village',
                        name: 'village'),
                    Divider(color: color_ecec),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BuildButtonBottom(
        title: 'next',
        isActive: true,
        func: () {
          // var amount = controller.rxPaymentAmount.value.replaceAll(RegExp(r'[^\w\s]+'), '');
          // controller.paymentprocess(amount);
          print(_province.text);

          _formKey.currentState!.save();
          if (_formKey.currentState!.validate()) {
            userControler.register(
                widget.regType,
                _gender,
                _fname.text,
                _lname.text,
                _birthday.text,
                _province.text,
                _district.text,
                _village.text);
          }
        },
      ),
    );
  }

  Container buildSelectDate(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(
        color: color_ddd,
        width: 1.5,
      ),
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFont(text: 'birthday'),
          FormBuilderTextField(
            name: 'birthday',
            controller: _birthday,
            style: TextStyle(
              fontSize: 17,
              color: Colors.black,
              fontFamily: 'PoppinsRegular',
            ),
            decoration: InputDecoration(
              fillColor: color_fafa,
              filled: true,
              enabledBorder: border,
              focusedBorder: border,
              errorStyle: GoogleFonts.notoSansLao(color: Colors.red),
              focusedErrorBorder: border,
              errorBorder: border,
              suffixIcon: Icon(
                Icons.calendar_today_outlined,
                color: cr_red,
              ),
            ),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
            ]),
            readOnly: true,
            onTap: () {
              showCupertinoModalPopup(
                context: context,
                builder: (context) => CupertinoActionSheet(
                  actions: [
                    SizedBox(
                      height: 300,
                      child: CupertinoDatePicker(
                        minimumYear: 1930,
                        maximumYear: DateTime.now().year,
                        initialDateTime: _birthday.text.isNotEmpty
                            ? DateTime.tryParse(_birthday.text) ?? _dateTime
                            : _dateTime,
                        mode: CupertinoDatePickerMode.date,
                        onDateTimeChanged: (dateTime) {
                          setState(() {
                            _dateTime = dateTime;
                            _birthday.text =
                                DateFormat('yyyy-MM-dd').format(dateTime);
                          });
                        },
                      ),
                    ),
                  ],
                  cancelButton: CupertinoActionSheetAction(
                    child: TextFont(
                      text: 'done',
                      color: color_red_background,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Row buildHeader() {
    return Row(
      children: [
        SizedBox(
          width: 50.sp,
          height: 50.sp,
          child: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(
                userControler.userProfilemodel.value.profileImg ??
                    'https://mmoney.la/AppLite/Users/mmoney.png'),
            backgroundColor:
                Colors.transparent, // Optional: Set a background color
          ),
        ),
        SizedBox(width: 8), // Optional spacing between image and column
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // TextFont(
              //   text: userControler.profileName.value,
              //   maxLines: 2,
              //   noto: true,
              //   color: color_7070,
              //   fontWeight: FontWeight.bold,
              //   fontSize: 14,
              // ),
              TextFont(
                text: welcomeText,
                poppin: true,
              ),
              Row(
                children: [
                  TextFont(
                    text:
                        userControler.kycModel.value.data?.phone ?? '20xxxxxx',
                    poppin: true,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
            ],
          ),
        ),
        // Container(
        //   decoration: BoxDecoration(color: color_f4f4, borderRadius: BorderRadius.circular(10)),
        //   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        //   child: Row(
        //     mainAxisSize: MainAxisSize.min,
        //     children: [
        //       userControler.userProfilemodel.value.verify == "Approved"
        //           ? SvgPicture.asset(MyIconOld.ic_check_circle)
        //           : SvgPicture.asset(
        //               MyIconOld.ic_info,
        //               color: userControler.userProfilemodel.value.verify == "UnApproved" ? color_primary_light : Colors.grey,
        //             ),
        //       SizedBox(width: 5),
        //       TextFont(
        //         text: userControler.userProfilemodel.value.verify ?? '',
        //         fontSize: 10,
        //         poppin: true,
        //       ),
        //     ],
        //   ),
        // ),
      ],
    );
  }

  Widget buildSelectGender() {
    double radius = 6;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFont(text: 'sex'),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _genderMale = true;
                      _gender = 'male';
                      print(_gender);
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(radius),
                      border: Border.all(
                          color: _genderMale
                              ? color_primary_light
                              : color_blackE72,
                          width: _genderMale ? 1 : 0),
                      color: _genderMale
                          ? color_primary_light.withOpacity(0.1)
                          : color_f4f4,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            height: 40,
                            width: 40,
                            child: Image.asset('assets/images/man.png')),
                        const SizedBox(width: 5),
                        TextFont(text: 'Male', color: color_blackE72),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _genderMale = false;
                      _gender = 'female';
                      print(_gender);
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(radius),
                      border: Border.all(
                          color:
                              !_genderMale ? color_primary_light : color_f4f4,
                          width: !_genderMale ? 1 : 0),
                      color: !_genderMale
                          ? color_primary_light.withOpacity(0.1)
                          : color_f4f4,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            height: 40,
                            width: 40,
                            child: Image.asset('assets/images/woman.png')),
                        const SizedBox(width: 5),
                        TextFont(text: 'Female', color: color_blackE72)
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Column buildImageForm(
      String title, String desc, String type, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFont(text: title),
        TextFont(text: desc, fontSize: 9, maxLines: 2, color: color_7070),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: color_f4f4,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Container(
                      child: (type == 'doc_img'
                              ? (!(userControler.kycModel.value.data!.docImg!
                                  .startsWith('http')))
                              : (!(userControler.kycModel.value.data!.photo!
                                  .startsWith('http'))))
                          ? SizedBox(
                              width: 30.w,
                              child: Image.asset(
                                type == 'doc_img'
                                    ? 'assets/images/id_card.png'
                                    : 'assets/images/verify_account.png',
                              ),
                            )
                          : SizedBox(
                              width: 85.w,
                              height: 60.w,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        Get.to(() => ImagepreviewScreen(
                                            imageUrl: type == 'doc_img'
                                                ? userControler.kycModel.value
                                                    .data!.docImg!
                                                : userControler.kycModel.value
                                                    .data!.photo!,
                                            title: type == 'doc_img'
                                                ? 'Document Image'
                                                : 'Verify Account Image'));
                                      },
                                      child: CachedNetworkImage(
                                        imageUrl: type == 'doc_img'
                                            ? userControler
                                                .kycModel.value.data!.docImg!
                                            : userControler
                                                .kycModel.value.data!.photo!,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                    (type == 'doc_img'
                            ? (userControler
                                    .kycModel.value.data!.docImg?.isEmpty ??
                                true)
                            : (userControler
                                    .kycModel.value.data!.photo?.isEmpty ??
                                true))
                        ? TextFont(
                            text: type == 'doc_img'
                                ? 'take_document_image'
                                : 'take_verify_image',
                            color: color_7070,
                          )
                        : SizedBox.shrink()
                  ],
                ),
              ],
            ),
          ),
        ),
        InkWell(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: color_fac0,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: TextFont(
                    text: 'take_picture',
                    color: color_primary_light,
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
