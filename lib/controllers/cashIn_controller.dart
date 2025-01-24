import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:super_app/controllers/home_controller.dart';
import 'package:super_app/controllers/log_controller.dart';
import 'package:super_app/controllers/user_controller.dart';
import 'package:super_app/models/model-bank/BankListModel.dart';
import 'package:super_app/services/api/dio_client.dart';
import 'package:super_app/utility/dialog_helper.dart';
import 'package:super_app/utility/myconstant.dart';

class CashInController extends GetxController {
  final storage = GetStorage();
  final homeController = Get.find<HomeController>();
  final userController = Get.find<UserController>();
  final logController = Get.put(LogController());
  RxList<BankListModel> banksList = <BankListModel>[].obs;
  RxList<String> prepaidAmounts = <String>[].obs;

  RxString requestId = "".obs;
  RxString txnAmount = "".obs;
  RxBool loading = false.obs;
  RxString imageURLlogo = "".obs;
  RxString titleBank = "".obs;
  RxString urlBank = "".obs;
  RxString urlLinkApp = "".obs;
  RxString urlCheckTransction = "".obs;
  RxString urlCallBack = "".obs;
  RxString timestamp = "".obs;
  RxString sourceAccount = "".obs;
  RxString refNo = "".obs;
  RxString sourceName = "".obs;
  RxString exReferenceNo = "".obs;
  RxString memo = "".obs;
  RxString emvCode = "".obs;
  //Log
  // ignore: prefer_typing_uninitialized_variables
  var logVerify;
  // ignore: prefer_typing_uninitialized_variables
  var logPaymentReq;
  // ignore: prefer_typing_uninitialized_variables
  var logPaymentRes;

  @override
  void onReady() async {
    getListAmount();
  }

  // Clear function
  clear() {
    requestId.value = "";
    txnAmount.value = "";
    loading.value = false;
    imageURLlogo.value = "";
    titleBank.value = "";
    urlBank.value = "";
    urlLinkApp.value = "";
    timestamp.value = "";
    logVerify = null;
    logPaymentReq = null;
    logPaymentRes = null;
  }

  generateDynamicQR() async {
    try {
      var data = {
        "requestId": requestId.value,
        "mechantId": "HRBR1F3VGN9FVTCOHGCIZ8NNC", //mmoneyX
        "txnAmount": txnAmount.value,
        "billNumber": requestId.value,
        "terminalId": "JDB0000066",
        "terminalLabel": "JDB0000066",
        "mobileNo": await storage.read('msisdn'),
        "owner": "MMONEYX",
        "channel": "CashIN"
      };
      var response = await DioClient.postEncrypt(
          "${MyConstant.urlDynamicQR}/generateDynamicQR", data);
      if (response['message'] == "SUCCESS") {
        requestId.value = response['transactionId'];
        emvCode.value = response['data']['emv'];
        loading.value = false;
        Get.toNamed("/confirmCashIN");
      }
      loading.value = false;
    } catch (e) {
      loading.value = false;
      // DialogHelper.showErrorDialog(description: e.toString());
    }
  }

  getListAmount() async {
    var response = await DioClient.postEncrypt(
        "${MyConstant.urlDynamicQR}/getListAmount", {});
    if (response['status'] == 'success') {
      prepaidAmounts.value = (response['data'] as List<dynamic>)
          .map((amount) => amount.toString())
          .toList();
    }
  }
}
