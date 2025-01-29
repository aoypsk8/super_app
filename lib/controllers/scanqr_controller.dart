import 'package:get/get.dart';

class ScanQRController extends GetxController {
  RxString qrCode = ''.obs;

  void setQRCode(String code) {
    qrCode.value = code;
  }
}
