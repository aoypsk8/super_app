import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class UserController extends GetxController {
  final storage = GetStorage();
  RxString walletid = ''.obs;
  RxString name = ''.obs;
  RxString birthday = ''.obs;

  //auth
  RxString rxMsisdn = '2052768833'.obs;

  RxString rxLat = ''.obs;
  RxString rxLong = ''.obs;

  //number page to close
  RxInt pageclose = 0.obs;
  increasepage() {
    pageclose++;
    print('pages : $pageclose');
  }

  decreasepage() {
    pageclose--;
    print('pages : $pageclose');
  }
}
