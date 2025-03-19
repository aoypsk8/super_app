// import 'dart:io';
// import 'package:get/get.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:image_cropper/image_cropper.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:sizer/sizer.dart';
// import 'package:super_app/controllers/esim_controller.dart';
// import 'package:super_app/controllers/home_controller.dart';
// import 'package:super_app/models/esim_mode.dart';
// import 'package:super_app/services/helper/random.dart';
// import 'package:super_app/utility/color.dart';
// import 'package:super_app/utility/dialog_helper.dart';
// import 'package:super_app/views/other_service/esim/build_card_esim.dart';
// import 'package:super_app/widget/buildAppBar.dart';
// import 'package:super_app/widget/buildBottomAppbar.dart';
// import 'package:super_app/widget/buildTextField.dart';
// import 'package:super_app/widget/build_pay_visa.dart';
// import 'package:super_app/widget/textfont.dart';

// class Vertify_kyc_ESIM extends StatefulWidget {
//   final ESIMPackage esimData;

//   const Vertify_kyc_ESIM({super.key, required this.esimData});

//   @override
//   State<Vertify_kyc_ESIM> createState() => _Vertify_kyc_ESIMState();
// }

// class _Vertify_kyc_ESIMState extends State<Vertify_kyc_ESIM> {
//   final TextEditingController emailController = TextEditingController();
//   final HomeController homeController = Get.find();
//   final esimController = Get.put(ESIMController());
//   final _formKey = GlobalKey<FormState>();
//   File? docImage;
//   File? verifyImage;
//   final ImagePicker _imagePicker = ImagePicker();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: color_fff,
//       appBar: BuildAppBar(title: "vertify_kyc"),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: SingleChildScrollView(
//           child: GestureDetector(
//             onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
//             behavior: HitTestBehavior.opaque,
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Hero(
//                     tag: "${widget.esimData.id}_${widget.esimData.phoneNumber}",
//                     child: Material(
//                       color: Colors.transparent,
//                       child: CardWidgetESIM(
//                         btn: false,
//                         packagename: widget.esimData.phoneNumber,
//                         code: widget.esimData.phoneNumber,
//                         amount: widget.esimData.price.toString(),
//                         detail:
//                             "${widget.esimData.data} / ${widget.esimData.time}",
//                         onTap: () {},
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 30),
//                   buildEmailValidateV2(
//                     controller: emailController,
//                     fillcolor: color_f4f4,
//                     bordercolor: color_f4f4,
//                     isEmail: true,
//                     label: 'email',
//                     name: 'email',
//                     hintText: '@gmail.com',
//                     textType: TextInputType.emailAddress,
//                   ),
//                   const SizedBox(height: 30),
//                   buildHeadLine('Document Image'),
//                   const SizedBox(height: 10),
//                   buildThumbnailImage('doc_img'),
//                   const SizedBox(height: 20),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Expanded(
//                         child: buildTakePhoto('doc_img'),
//                       ),
//                       Expanded(
//                         child: buildTakePhoto('doc_img', opencamera: false),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 30),
//                   buildHeadLine('Verification Image'),
//                   const SizedBox(height: 10),
//                   buildThumbnailImage('verify_img'),
//                   const SizedBox(height: 10),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Expanded(
//                         child: buildTakePhoto('verify_img'),
//                       ),
//                       Expanded(
//                         child: buildTakePhoto('verify_img', opencamera: false),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 50),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//       bottomNavigationBar: buildBottomAppbar(
//         bgColor: Theme.of(context).primaryColor,
//         title: 'Next',
//         func: () async {
//           _formKey.currentState!.save();
//           if (_formKey.currentState!.validate()) {
//             if (docImage != null && verifyImage != null) {
//               esimController.docImg.value = docImage;
//               esimController.verifyImg.value = verifyImage;
//               esimController.RxTransID.value =
//                   'XXESIM${await randomNumber().fucRandomNumber()}';

//               esimController.RxMail.value = emailController.text;
//               esimController.RxPrice.value = widget.esimData.price;
//               esimController.RxPhoneNumber.value = widget.esimData.phoneNumber;
//               esimController.RxDescription.value =
//                   "${widget.esimData.data} / ${widget.esimData.time}";
//               esimController.RxUSD.value = double.parse(
//                   (double.parse(widget.esimData.price.toString()) /
//                           homeController.RxrateUSDKIP.value)
//                       .toStringAsFixed(2));

//               //Get to VISA PAy
//               Get.to(PaymentVisaMasterCard(
//                 function: () {
//                   esimController.esimProcess(emailController.text);
//                 },
//                 trainID: esimController.RxTransID.value,
//                 description: "BUY ESIM",
//                 amount: widget.esimData.price,
//               ));
//             } else {
//               DialogHelper.showErrorDialogNew(
//                 title: "Error",
//                 description: "please_upload_both_images",
//                 onClose: () {
//                   Get.back();
//                 },
//               );
//             }
//           }
//         },
//       ),
//     );
//   }

//   Container buildThumbnailImage(String imgType) {
//     File? selectedImage = imgType == 'doc_img' ? docImage : verifyImage;

//     return Container(
//       height: 30.h,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(5),
//         color: color_f2f2,
//       ),
//       child: selectedImage != null
//           ? ClipRRect(
//               borderRadius: BorderRadius.circular(5),
//               child: Image.file(
//                 selectedImage,
//                 width: double.infinity,
//                 fit: BoxFit.cover,
//               ),
//             )
//           : Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 SvgPicture.asset('assets/icons/img_verify_card.svg'),
//               ],
//             ),
//     );
//   }

//   Row buildHeadLine(String title) {
//     return Row(
//       children: [
//         TextFont(text: title, fontWeight: FontWeight.w500),
//       ],
//     );
//   }

//   Container buildTakePhoto(String type, {bool opencamera = true}) {
//     return Container(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 10),
//         child: InkWell(
//           onTap: () async {
//             if (opencamera) {
//               _imgFromCamera(type);
//             } else {
//               final XFile? image = await _imagePicker.pickImage(
//                 source: ImageSource.gallery,
//               );
//               if (image != null) {
//                 _cropImage(File(image.path), type);
//               }
//             }
//           },
//           child: Container(
//             padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
//             decoration: BoxDecoration(
//               color: color_ed1,
//               borderRadius: BorderRadius.circular(5),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(opencamera ? Icons.camera_alt_rounded : Icons.image,
//                     color: color_fff),
//                 const SizedBox(width: 10),
//                 Flexible(
//                   child: TextFont(
//                     text: opencamera ? 'Take Picture' : 'Pick from Gallery',
//                     color: color_fff,
//                     maxLines: 1,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   _imgFromCamera(String imgType) async {
//     final XFile? pickedFile = await _imagePicker.pickImage(
//       source: ImageSource.camera,
//     );

//     if (pickedFile != null) {
//       _cropImage(File(pickedFile.path), imgType);
//     }
//   }

//   _cropImage(File imgFile, String imgType) async {
//     final croppedFile = await ImageCropper().cropImage(
//       sourcePath: imgFile.path,
//       aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
//     );

//     if (croppedFile != null) {
//       setState(() {
//         if (imgType == 'doc_img') {
//           docImage = File(croppedFile.path);
//         } else if (imgType == 'verify_img') {
//           verifyImage = File(croppedFile.path);
//         }
//       });
//     }
//   }
// }
