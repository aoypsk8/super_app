import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:super_app/controllers/user_controller.dart';
import 'package:super_app/services/helper/random.dart';
import 'package:super_app/utility/Device.dart';
import 'package:super_app/utility/myconstant.dart';

import '../services/api/dio_client.dart';

class LogController extends GetxController {
  final userController = Get.find<UserController>();
  final storage = GetStorage();

  insertLog(chanel, transID, logRequest, logResponse) async {
    var data = {
      "collection": chanel,
      "data": {
        "transid": transID,
        "Request": {"data": logRequest},
        "Response": {"data": logResponse}
      }
    };
    var url = "${MyConstant.urlAddress}/InsertLog";
    var response =
        await DioClient.postEncrypt(loading: false, url, data, key: 'lmm');
  }

  insertCashOutLog(transID, msisdn, chanel, logResponse) async {
    var data = {
      "collection": 'mmoney_x_cashout',
      "data": {
        "transid": transID,
        "msisdn": msisdn,
        "chanel": chanel,
        "Response": {"data": logResponse}
      }
    };
    var url = "${MyConstant.urlAddress}/InsertLog";
    var response =
        await DioClient.postEncrypt(url, data, key: 'lmm', loading: false);
  }

  insertAllLog(chanel, transID, logo, provider, toAcc, accName, amount, point,
      fee, ramark, verifyRes, paymentReq, paymentRes) async {
    String date = await getDatetimeAiNou();
    String datetime =
        '${date.substring(0, 4)}-${date.substring(4, 6)}-${date.substring(6, 8)} '
        '${date.substring(8, 10)}:${date.substring(10, 12)}:${date.substring(12, 14)}';

    var data = {
      "collection": 'mmoney_x_log',
      "data": {
        "timestamp": datetime,
        "chanel": chanel,
        "transid": transID,
        "logo": logo,
        "provider": provider,
        "from_acc": storage.read('msisdn'),
        "from_acc_name": userController.name.value,
        "to_acc": toAcc,
        "to_acc_name": accName,
        "amount": amount,
        "point": point,
        "fee": fee,
        "ramark": ramark,
        "lat": userController.rxLat.value,
        "long": userController.rxLong.value,
        // "verify_res": {"data": verifyRes},
        // "payment_req": {"data": paymentReq},
        "payment_res": {"data": paymentRes}
      }
    };
    var url = "${MyConstant.urlAddress}/InsertLog";
    var response =
        await DioClient.postEncrypt(loading: false, url, data, key: 'lmm');
  }

  insertCashOutPointLog(chanel, transID, logRequest, logResponse) async {
    var data = {
      "collection": 'x_cashout_point_log',
      "data": {
        "transid": transID,
        "chanel": chanel,
        "Request": {"data": logRequest},
        "Response": {"data": logResponse}
      }
    };
    var url = "${MyConstant.urlAddress}/InsertLog";
    var response =
        await DioClient.postEncrypt(loading: false, url, data, key: 'lmm');
  }

  insertCashOutLogBefore(chanel, transID, logRequest) async {
    var data = {
      "collection": 'x_before_cashout_log',
      "data": {
        "transid": transID,
        "chanel": chanel,
        "Request": {"data": logRequest}
      }
    };
    var url = "${MyConstant.urlAddress}/InsertLog";
    var response =
        await DioClient.postEncrypt(loading: false, url, data, key: 'lmm');
  }

  insertCashInLog(transID, amount, fee, resCashin) async {
    String date = await getDatetimeAiNou();
    String datetime =
        '${date.substring(0, 4)}-${date.substring(4, 6)}-${date.substring(6, 8)} '
        '${date.substring(8, 10)}:${date.substring(10, 12)}:${date.substring(12, 14)}';

    var data = {
      "collection": 'mmoney_x_cashin_log',
      "data": {
        "timestamp": datetime,
        "transid": transID,
        "amount": amount,
        "fee": fee,
        "cashin_res": {"data": resCashin},
      }
    };
    var url = "${MyConstant.urlAddress}/InsertLog";
    var response =
        await DioClient.postEncrypt(loading: false, url, data, key: 'lmm');
  }

  insertLoginLog() async {
    // userController.getCurrentLocation();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    var data = {
      "msisdn": await storage.read('msisdn'),
      "deviceModel": await Device.getDeviceModel(),
      "IMEI": await Device.getDeviceKey(),
      "osVersion": await Device.getOsVersion(),
      "lat": userController.rxLat.value,
      "long": userController.rxLong.value,
      "appVersion": packageInfo.version
    };
    var url = "${MyConstant.urlInsertLog}/InsertLog";
    var response =
        await DioClient.postEncrypt(loading: false, url, data, key: 'lmm');
  }
}
