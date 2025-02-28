import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:super_app/models/telecomsrv_model.dart';
import 'package:super_app/services/api/dio_client.dart';
import 'package:super_app/utility/myconstant.dart';

class TelecomsrvController extends GetxController {
  Rx<NetworktypeModel> networktypeModel = NetworktypeModel().obs;
  Rx<AirtimeModel> airtimeModel = AirtimeModel().obs;
  Rx<PackageModel> inusePackageModel = PackageModel().obs;
  RxList<PackageModel> packageModel = <PackageModel>[].obs;
  RxList<PhoneListModel> phoneListModel = <PhoneListModel>[].obs;
  RxString msisdn = '2055xxxxxx'.obs;
  RxString airtime = '0'.obs;
  final storage = GetStorage();

  @override
  void onReady() async {
    super.onReady();
    await getNetworktype();
    await getAirtime();
    await getPackage();
    await phoneList();
  }

  getNetworktype() async {
    var url =
        '${MyConstant.mservicesUrl}/CheckNetworkType?msisdn=${await storage.read('msisdn')}';
    var res = await DioClient.getNoLoading(url);
    networktypeModel.value = NetworktypeModel.fromJson(res);
  }

  getAirtime() async {
    var url =
        '${MyConstant.mservicesUrl}/CheckBalance?msisdn=${await storage.read('msisdn')}';
    var res = await DioClient.getNoLoading(url);
    airtimeModel.value = AirtimeModel.fromJson(res);
    checkAirtime();
  }

  checkAirtime() {
    String type = '';
    switch (airtimeModel.value.networkType) {
      case 'G':
      case 'F':
        type = 'Debit';
        break;
      default:
        type = 'C_MAIN_ACCOUNT';
    }

    airtime.value = airtimeModel.value.balances!
        .firstWhere((i) => i.balanceType == type)
        .balance
        .toString();
  }

  getPackage() async {
    var url =
        '${MyConstant.mservicesUrl}/QueryPackage?msisdn=${await storage.read('msisdn')}&language=en';
    var res = await DioClient.getNoLoading(url);
    packageModel.value =
        (res as List).map((e) => PackageModel.fromJson(e)).toList();
    //set value to chart
    if (packageModel.isNotEmpty) {
      inusePackageModel.value = packageModel.first;
    }
  }

  phoneList() async {
    var url =
        '${MyConstant.mservicesUrl}/ManageUser?msisdn=${await storage.read('msisdn')}';
    var res = await DioClient.getNoLoading(url, key: 'mservices');
    phoneListModel.value =
        (res as List).map((e) => PhoneListModel.fromJson(e)).toList();
  }
}
