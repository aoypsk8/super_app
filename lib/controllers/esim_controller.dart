// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:io';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:super_app/models/esim_mode.dart';
import 'package:super_app/services/api/dio_client.dart';
import 'package:super_app/utility/dialog_helper.dart';
import 'package:super_app/views/other_service/esim/showqr_esim.dart';

class ESIMController extends GetxController {
  Rx<File?> docImg = Rx<File?>(null);
  Rx<File?> verifyImg = Rx<File?>(null);
  RxString RxTransID = ''.obs;
  RxList<ESIMPackage> esimModel = <ESIMPackage>[].obs;
  RxList<ESIMPackage> esimDetailModel = <ESIMPackage>[].obs;

  RxInt RxPrice = 0.obs;
  RxDouble RxUSD = 0.0.obs;
  RxString RxTitle = ''.obs;
  RxString RxPhoneNumber = ''.obs;
  RxString RxDescription = ''.obs;
  RxString RxMail = ''.obs;

  @override
  void onReady() {
    super.onReady();
    fetchESIM();
  }

  fetchESIM() async {
    try {
      var responseUpload = await DioClient.postEncrypt('/ESIM/GetAllESIM', {});
      esimModel.value = responseUpload['data']
          .map<ESIMPackage>((json) => ESIMPackage.fromJson(json))
          .toList();
    } catch (e) {
      DialogHelper.showErrorDialogNew(description: e.toString());
      print("❌ $e");
    }
  }

  /// ✅ **Upload KYC Data**
  Future<void> esimProcess(String email) async {
    if (docImg.value == null || verifyImg.value == null) {
      DialogHelper.showErrorDialogNew(
          description: "❌ Please select both images before uploading");
      return;
    }
    try {
      var formData = dio.FormData.fromMap({
        "path": "ESIM_KYC",
        "email": email,
        "transId": RxTransID.value,
        "doc_img": await dio.MultipartFile.fromFile(docImg.value!.path,
            filename: "doc_img.png"),
        "verify_img": await dio.MultipartFile.fromFile(verifyImg.value!.path,
            filename: "verify_img.png"),
      });
      var responseUpload = await DioClient.postEncrypt(
        '/ESIM/ESIM_upload_kyc',
        formData,
        image: true,
      );
      if (responseUpload['success'] == true) {
        // ShowQR
        Get.to(ShowQRESIMScreen());
      } else {
        DialogHelper.showErrorDialogNew(description: responseUpload['message']);
      }
    } catch (e) {
      DialogHelper.showErrorDialogNew(description: e.toString());
      print("❌ Exception occurred: $e");
    }
  }
}
