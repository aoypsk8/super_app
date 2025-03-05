import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/controllers/user_controller.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/utility/myIcon.dart';
import 'package:super_app/views/image_preview.dart';
import 'package:super_app/widget/buildAppBar.dart';
import 'package:super_app/widget/buildButtonBottom.dart';
import 'package:super_app/widget/buildTextField.dart';
import 'package:super_app/widget/mounoy_textfield.dart';
import 'package:super_app/widget/textfont.dart';

class VerifyAccountScreen extends StatefulWidget {
  const VerifyAccountScreen({super.key});

  @override
  State<VerifyAccountScreen> createState() => _VerifyAccountScreenState();
}

final userController = Get.find<UserController>();

class _VerifyAccountScreenState extends State<VerifyAccountScreen> {
  final userControler = Get.find<UserController>();

  final _formKey = GlobalKey<FormBuilderState>();
  final _fname = TextEditingController();
  final _lname = TextEditingController();
  final _province = TextEditingController();
  final _district = TextEditingController();
  final _village = TextEditingController();
  final _cardID = TextEditingController();
  final _birthday = TextEditingController();

  String? _gender;
  bool _genderMale = true;

  String _provinceCode = '';
  var dataProvice = [
    {"proid": 1, "Name": "ນະຄອນຫຼວງວຽງຈັນ", "Code": "VTE", "Description": "NULL"},
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
  void initState() {
    // TODO: implement initState
    super.initState();
    var kyc = userController.userProfilemodel.value;
    _fname.text = kyc.name ?? '';
    _lname.text = kyc.surname ?? '';
    _birthday.text = kyc.birthdate ?? '';
    _gender = kyc.gender!;
    _gender = kyc.gender! == 'male' ? 'male' : 'female';
    _village.text = kyc.village ?? '';
    _district.text = kyc.district ?? '';
    _province.text = kyc.provinceDesc ?? '';
    _provinceCode = kyc.provinceCode ?? '';
    _cardID.text = kyc.cardId ?? '';
  }

  final picker = ImagePicker();
  _imgFromCamera(String imgType) async {
    await picker
        .pickImage(
      source: ImageSource.camera,
      // imageQuality: 100,
    )
        .then((value) {
      if (value != null) {
        _cropImage(File(value.path), imgType);
      }
    });
  }

  _cropImage(File imgFile, String imgType) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imgFile.path,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
    );
    if (croppedFile != null) {
      imageCache.clear();
      switch (imgType) {
        case 'profile_img':
          _resizeImage(File(croppedFile.path), imgType);
          userController.uploadImgProfile(File(croppedFile.path), imgType);
          break;

        case 'doc_img':
          _resizeImage(File(croppedFile.path), imgType);
          userController.uploadDocImg(File(croppedFile.path), imgType);
          break;

        case 'verify_img':
          _resizeImage(File(croppedFile.path), imgType);
          userController.uploadVerifyImg(File(croppedFile.path), imgType);
          break;
      }
    }
  }

  void _resizeImage(File imgFile, String imgType) {
    try {
      final bytes = imgFile.readAsBytesSync();
      final img.Image? image = img.decodeImage(bytes);
      if (image == null) {
        print("Error: Unable to decode image.");
        return;
      }
      final img.Image resizedImage = img.copyResize(image, width: 600);
      imgFile.writeAsBytesSync(img.encodePng(resizedImage));
      print("Image resized successfully: ${imgFile.path}");
    } catch (e) {
      print("Error resizing image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color_fff,
      appBar: BuildAppBar(title: 'verify_account'),
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
                    buildHeader(),
                    Divider(color: color_ecec),
                    SizedBox(height: 15),
                    TextFont(text: 'input_profile', color: cr_b326),
                    SizedBox(height: 8),
                    buildTextField(controller: _fname, label: 'fname', name: 'fname', hintText: '', isEditable: true),
                    buildTextField(controller: _lname, label: 'lname', name: 'lname', hintText: '', isEditable: true),
                    buildTextField(
                        controller: _birthday, label: 'birthday', name: 'birthday', hintText: '', isEditable: false),
                    buildSelectGender(),
                    Divider(color: color_ecec),
                    SizedBox(height: 8),
                    TextFont(text: 'input_profile', color: cr_b326),
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
                    buildTextField(controller: _district, label: 'district', name: 'district'),
                    buildTextField(controller: _village, label: 'village', name: 'village'),
                    Divider(color: color_ecec),
                    SizedBox(height: 8),
                    TextFont(text: 'input_document', color: cr_b326),
                    SizedBox(height: 8),
                    buildTextField(controller: _cardID, label: 'document_id', name: 'document_id', hintText: ''),
                    SizedBox(height: 8),
                    buildImageForm(
                      'document_image',
                      'doc_img_description',
                      'doc_img',
                      () {
                        _imgFromCamera('doc_img');
                      },
                    ),
                    SizedBox(height: 15),
                    buildImageForm(
                      'verify_img',
                      'ver_img_description',
                      'verify_img',
                      () {
                        _imgFromCamera('verify_img');
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BuildButtonBottom(
          title: 'confirm',
          func: () {
            _formKey.currentState!.save();
            if (_formKey.currentState!.validate()) {
              if (userController.userProfilemodel.value.docImg != '' &&
                  userController.userProfilemodel.value.verifyImg != '') {
                userController.verificationRegister(
                  _gender,
                  _fname.text,
                  _lname.text,
                  _birthday.text,
                  _province.text,
                  _province.text,
                  _district.text,
                  _village.text,
                  _cardID.text,
                );
              }
            }
          }),
    );
  }

  Column buildImageForm(String title, String desc, String type, VoidCallback onTap) {
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
                              ? (userController.userProfilemodel.value.docImg?.isEmpty ?? true)
                              : (userController.userProfilemodel.value.verifyImg?.isEmpty ?? true))
                          ? SizedBox(
                              width: 30.w,
                              child: Image.asset(
                                type == 'doc_img' ? 'assets/images/id_card.png' : 'assets/images/verify_account.png',
                              ),
                            )
                          : SizedBox(
                              height: 85.w,
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Get.to(() => ImagepreviewScreen(
                                          imageUrl: type == 'doc_img'
                                              ? userController.userProfilemodel.value.docImg!
                                              : userController.userProfilemodel.value.verifyImg!,
                                          title: type == 'doc_img' ? 'Document Image' : 'Verify Account Image'));
                                    },
                                    child: CachedNetworkImage(
                                        imageUrl: type == 'doc_img'
                                            ? userController.userProfilemodel.value.docImg!
                                            : userController.userProfilemodel.value.verifyImg!),
                                  ),
                                ],
                              ),
                            ),
                    ),
                    (type == 'doc_img'
                            ? (userController.userProfilemodel.value.docImg?.isEmpty ?? true)
                            : (userController.userProfilemodel.value.verifyImg?.isEmpty ?? true))
                        ? TextFont(
                            text: type == 'doc_img' ? 'take_document_image' : 'take_verify_image',
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
          onTap: onTap, // ✅ เรียกใช้ฟังก์ชันที่ถูกส่งเข้ามา
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

  Row buildHeader() {
    return Row(
      children: [
        SizedBox(
          width: 50.sp,
          height: 50.sp,
          child: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(userController.userProfilemodel.value.profileImg ?? ''),
            backgroundColor: Colors.transparent, // Optional: Set a background color
          ),
        ),
        SizedBox(width: 8), // Optional spacing between image and column
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFont(
                text: userController.profileName.value,
                maxLines: 2,
                noto: true,
                color: color_7070,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              Row(
                children: [
                  TextFont(
                    text: userController.userProfilemodel.value.msisdn!,
                    poppin: true,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(color: color_f4f4, borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              userController.userProfilemodel.value.verify == "Approved"
                  ? SvgPicture.asset(MyIconOld.ic_check_circle)
                  : SvgPicture.asset(
                      MyIconOld.ic_info,
                      color: userController.userProfilemodel.value.verify == "UnApproved"
                          ? color_primary_light
                          : Colors.grey,
                    ),
              SizedBox(width: 5),
              TextFont(
                text: userController.userProfilemodel.value.verify ?? '',
                fontSize: 10,
                poppin: true,
              ),
            ],
          ),
        ),
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
                          color: _genderMale ? color_primary_light : color_blackE72, width: _genderMale ? 1 : 0),
                      color: _genderMale ? color_primary_light.withOpacity(0.1) : color_f4f4,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 40, width: 40, child: Image.asset('assets/images/man.png')),
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
                          color: !_genderMale ? color_primary_light : color_f4f4, width: !_genderMale ? 1 : 0),
                      color: !_genderMale ? color_primary_light.withOpacity(0.1) : color_f4f4,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 40, width: 40, child: Image.asset('assets/images/woman.png')),
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
}
