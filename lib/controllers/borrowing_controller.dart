// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:super_app/controllers/log_controller.dart';
import 'package:super_app/controllers/user_controller.dart';
import 'package:super_app/models/borrowing_model.dart';
import 'package:super_app/utility/myconstant.dart';
import '../services/helper/random.dart';
import '../models/menu_model.dart';
import '../services/api/dio_client.dart';
import '../utility/dialog_helper.dart';

import 'home_controller.dart';

class BorrowingController extends GetxController {
  final storage = GetStorage();
  final userController = Get.find<UserController>();
  final logController = LogController();
  final HomeController homeController = Get.find();

  RxList<BorrowingModel> borrowingModels = <BorrowingModel>[].obs;

  RxString rxPathUrl = ''.obs;

  var isLoading = false.obs;

  fetchBorrowingList(Menulists menudetail) async {
    try {
      String? menuUrl = homeController.menudetail.value.url;
      if (menuUrl == null || menuUrl.isEmpty) {
        print("Menu URL is empty or null");
        return;
      }

      List<String> urlSplit = menuUrl.split(";");
      if (urlSplit.isEmpty || urlSplit[0].isEmpty) {
        print("Invalid URL format");
        return;
      }

      // Fetch API response
      var response = await DioClient.postEncrypt(
        loading: false,
        "${MyConstant.urlBorrow}${urlSplit[0]}", // Using the first URL from the split
        key: 'lmm',
        {},
      );

      print("API Response: $response");

      if (response != null) {
        // Identify the response key dynamically
        String? responseKey;
        if (response.containsKey("airtime")) {
          responseKey = "airtime";
        } else if (response.containsKey("data")) {
          responseKey = "data";
        } else {
          print("Unexpected API response format");
          return;
        }

        // Convert the response to a list of models
        borrowingModels.value = (response[responseKey] as List)
            .map((item) => BorrowingModel.fromJson(item))
            .toList();
      } else {
        print("Invalid API Response format");
      }
    } catch (e) {
      print("Exception occurred: $e");
    }
  }

  borrowingProcess() async {
    var body = {
      "msisdn": userController.rxMsisdn.value,
    };

    var response = await DioClient.postEncrypt(
      loading: false,
      "${MyConstant.urlBorrow}${rxPathUrl.value}",
      key: 'lmm',
      body,
    );

    if (response != null && response["success"] == true) {
      // Success - Show success dialog
      DialogHelper.showSuccessWithMascot(title: "Borrowing successful!");
    } else if (response != null &&
        response["success"] == false &&
        response["resultCode" == "405"]) {
      // Show error dialog
      DialogHelper.showErrorDialogNew(description: response['sms']);
    } else if (response != null &&
        response["success"] == false &&
        response["resultCode" == "450"]) {
      // Show error dialog
      DialogHelper.showErrorDialogNew(description: response['sms']);
    } else if (response != null &&
        response["success"] == false &&
        response["resultCode" == "401"]) {
      // Show error dialog
      DialogHelper.showErrorDialogNew(description: response['sms']);
    } else {
      // Show error dialog
      DialogHelper.showErrorDialogNew(description: 'error');
    }

    // Clear the rxPathUrl after process completion
    rxPathUrl.value = "";
  }
}
