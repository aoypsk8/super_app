import 'dart:convert';
import 'package:crypto/crypto.dart';

String checkSum(
  String transID,
  String fromAccNo,
  String toAccNo,
  String amount,
  String remarks,
) {
  String inputStr = "Xmml,$transID,$toAccNo,$fromAccNo,₭,$amount,$remarks,lmmX";
  List<int> bytes = utf8.encode(inputStr);
  Digest hash = sha256.convert(bytes);
  return base64.encode(hash.bytes);
}
