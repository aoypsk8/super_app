import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:super_app/models/menu_model.dart';

class HomeController extends GetxController {
  final storage = GetStorage();
  RxString menutitle = ''.obs;
  RxList<MenuModel> menumodel = <MenuModel>[].obs;

  RxList<Menulists> menulist = <Menulists>[].obs;
  Rx<Menulists> menudetail = Menulists().obs;

  HomeController() {
    menudetail.value.url =
        '/Electric/getList;/Electric/verify;/Electric/payment;/Electric/getRecent;/Electric/history;';
    menudetail.value.description = 'EL';
    menudetail.value.groupNameEN = 'Electric';
    menudetail.value.groupNameLA = 'ຈ່າຍຄ່າໄຟຟ້າ';
    menudetail.value.groupNameVT = 'Trả tiền điện';
    menudetail.value.groupNameCH = '电费';
  }

  @override
  void onReady() {
    super.onReady();
    // storage.write('msisdn', "2052768833");
  }

  String getMenuTitle() {
    // Get the current language code, default to 'en'
    String languageCode = storage.read('language') ?? 'lo';

    // Return the title based on the language code
    switch (languageCode) {
      case 'lo':
        return menudetail.value.groupNameLA! ?? '';
      case 'zh':
        return menudetail.value.groupNameCH! ?? '';
      case 'vi':
        return menudetail.value.groupNameVT! ?? '';
      default:
        return menudetail.value.groupNameEN! ?? '';
    }
  }
}
