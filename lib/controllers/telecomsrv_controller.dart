import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:super_app/models/telecomsrv_model.dart';
import 'package:super_app/services/api/dio_client.dart';
import 'package:super_app/utility/dialog_helper.dart';
import 'package:super_app/utility/myconstant.dart';

class TelecomsrvController extends GetxController {
  Rx<NetworktypeModel> networktypeModel = NetworktypeModel().obs;
  Rx<AirtimeModel> airtimeModel = AirtimeModel().obs;
  Rx<TelQueryPackage> inusePackageModel = TelQueryPackage().obs;
  RxList<PhoneListModel> phoneListModel = <PhoneListModel>[].obs;
  RxList<TelQueryPackage> telQueryPackage = <TelQueryPackage>[].obs;
  RxList<MainMenuInfo> mainMenuInfo = <MainMenuInfo>[].obs;
  RxString msisdn = '2055xxxxxx'.obs;
  RxString mainAirtime = '0'.obs;
  RxString airtime = '0'.obs;
  RxString inHouseAirtime = '0'.obs;
  RxString point = '0'.obs;
  final storage = GetStorage();
  //slide up control
  final PanelController panelController = PanelController();
  //package detail
  RxString msisdnDetail = ''.obs;

  @override
  void onReady() async {
    super.onReady();
    await getNetworktype();
    await getAirtime(await storage.read('msisdn'));
    await queryTelPackage(await storage.read('msisdn'));
    await phoneList();
    // await fetchMainMenu();
  }

  getNetworktype() async {
    var url =
        '${MyConstant.mservicesUrl}/CheckNetworkType?msisdn=${await storage.read('msisdn')}';
    var res = await DioClient.getNoLoading(url, key: 'mservices');
    networktypeModel.value = NetworktypeModel.fromJson(res);
  }

  getAirtime(String msisdn) async {
    var url = '${MyConstant.mservicesUrl}/CheckBalance?msisdn=$msisdn';
    var res = await DioClient.getNoLoading(url, key: 'mservices');
    airtimeModel.value = AirtimeModel.fromJson(res);
    checkAirtimeType();
  }

  checkAirtimeType() async {
    String type = '';
    switch (airtimeModel.value.networkType) {
      case 'G':
      case 'F':
        type = 'Debit';
        break;
      default:
        type = 'C_MAIN_ACCOUNT';
    }

    var balance = airtimeModel.value.balances!
        .firstWhere((i) => i.balanceType == type)
        .balance
        .toString();
    if (airtimeModel.value.msisdn == await storage.read('msisdn')) {
      mainAirtime.value = balance;
    }
    airtime.value = balance;

    inHouseAirtime.value = airtimeModel.value.balances!
        .firstWhere(
          (i) => i.balanceType == 'C_ONNET_OFFNET_BON_2103',
          orElse: () => Balances(balance: '0'),
        )
        .balance
        .toString();
  }

  queryTelPackage(String msisdn) async {
    var url =
        '${MyConstant.mservicesUrl}/QueryPackage?msisdn=$msisdn&language=en';
    var res = await DioClient.getNoLoading(url, key: 'mservices');
    telQueryPackage.value =
        (res as List).map((e) => TelQueryPackage.fromJson(e)).toList();
    if (telQueryPackage.isNotEmpty) {
      if (msisdn == await storage.read('msisdn')) {
        inusePackageModel.value = telQueryPackage.first;
      }
    }
  }

  phoneList() async {
    var url =
        '${MyConstant.mservicesUrl}/ManageUser?msisdn=${await storage.read('msisdn')}';
    var res = await DioClient.getNoLoading(url, key: 'mservices');
    phoneListModel.value =
        (res as List).map((e) => PhoneListModel.fromJson(e)).toList();
  }

  delPhone(String submsisdn) async {
    var url = '${MyConstant.mservicesUrl}/ManageUser';
    var body = {
      "main_msisdn": await storage.read('msisdn'),
      "destrination_msisdn": submsisdn,
      "language": 'en',
    };
    var res = await DioClient.delete(url, body, key: 'mservices');
    if (res != null) {
      phoneList();
      DialogHelper.showErrorDialogNew(
        title: res,
        description: '',
      );
    }
  }

  reqOtp(String reqMsisdn, String reqType) async {
    var url = '${MyConstant.mservicesUrl}/RequestOTP';
    var body = {
      "msisdn": reqMsisdn,
      "otpType": reqType,
      "language": 'en',
    };
    await DioClient.postNoLoading(url, body, key: 'mservices');
  }

  confirmOtp(String reqMsisdn, String reqType, String otp) async {
    var url = '${MyConstant.mservicesUrl}/ConfirmOTP';
    var body = {
      "msisdn": reqMsisdn,
      "otp": otp,
      "type": reqType,
      "language": "en"
    };
    var res = await DioClient.postNoLoading(url, body,
        loading: true, key: 'mservices');
    if (res['resultStatus'] == 'True') {
      return true;
    } else {
      DialogHelper.showErrorDialogNew(
        title: res['resultDesc'].toString(),
        description: '',
      );
    }
  }

  addPhone(
    String addMsisdn,
  ) async {
    var url = '${MyConstant.mservicesUrl}/ManageUser';
    var body = {
      "main_msisdn": await storage.read('msisdn'),
      "destrination_msisdn": addMsisdn,
      "language": 'en',
    };
    var res = await DioClient.postNoLoading(url, body,
        loading: true, key: 'mservices');
    if (res != null) {
      phoneList();
      Get.back();
    }
  }

  getPoint(String msisdn) async {
    var url = '${MyConstant.mservicesUrl}/CheckPoint?msisdn=$msisdn';
    var res = await DioClient.getNoLoading(url, key: 'mservices');
    if (res['resultCode'] == '200') {
      point.value = res['point'];
    }
  }

  fetchMainMenu() async {
    mainMenuInfo.value = (await DioClient.getNoLoading(
            '${MyConstant.mservicesUrl}/ListMainMenu',
            key: 'mservices') as List)
        .map((e) => MainMenuInfo.fromJson(e))
        .toList();
  }
}
