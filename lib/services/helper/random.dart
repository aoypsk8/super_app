// ignore_for_file: camel_case_types

import 'dart:math';
import 'package:intl/intl.dart';
import 'package:super_app/services/api/dio_client.dart';
import 'package:super_app/utility/myconstant.dart';

class randomNumber {
  String? ranNumber;

  Future<String> fucRandomNumber() async {
    //https://gateway.ltcdev.la/Other/getTranid
    var rng = Random();
    String now = await getTranID();
    String value = now + rng.nextInt(999999).toString().padLeft(6, '0');
    return value;
  }

  Future<String> fucRandomNumberBank() async {
    var rng = Random();
    String now = await getTranID();
    String value =
        now.substring(2) + rng.nextInt(9999).toString().padLeft(4, '0');
    return value;
  }

  String fucRandomNumberLottery(int count) {
    String number = '';
    for (var i = 0; i < count; i++) {
      number += Random().nextInt(10).toString();
    }
    return number;
  }

  Future<String> getTranID() async {
    var res = await DioClient.postEncrypt(
        loading: false, '${MyConstant.urlOther}/getTranid', {'msisdn': '9999'});
    return res['servertime'];
  }
}

Future<String> getDatetimeAiNou() async {
  var res = await DioClient.postEncrypt(
      loading: false, '${MyConstant.urlOther}/getTranid', {'msisdn': '9999'});
  return res['servertime'];
}
