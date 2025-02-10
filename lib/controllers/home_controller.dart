import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:super_app/models/appinfo_model.dart';
import 'package:super_app/models/menu_model.dart';
import 'package:super_app/services/api/dio_client.dart';
import 'package:super_app/utility/myconstant.dart';

class HomeController extends GetxController {
  final box = GetStorage();
  RxString rxBgCard = ''.obs;
  RxString rxBgBill = ''.obs;

  RxString menutitle = ''.obs;
  RxList<MenuModel> menumodel = <MenuModel>[].obs;

  RxList<Menulists> menulist = <Menulists>[].obs;
  Rx<Menulists> menudetail = Menulists().obs;

  HomeController() {
    // menudetail.value.url =
    //     '/Electric/getList;/Electric/verify;/Electric/payment;/Electric/getRecent;/Electric/history;';
    // menudetail.value.url = '/Wetv/getList;/Wetv/payment;/Wetv/history;';
    menudetail.value.url =
        '/Leasing/getList;/Leasing/verify;/Leasing/payment;/Leasing/getRecent;/Leasing/history';
    // menudetail.value.url = '/Bank/getList;/Bank/getRecent;/Bank/verify;/Bank/reqCashOut;/Bank/payment';
    // menudetail.value.url =
    //     '/Digitaltv/getList;/Digitaltv/verify;/Digitaltv/payment;/Digitaltv/getRecent;/Digitaltv/history;';
    // menudetail.value.url =
    //     '/Finance/getlist;/Finance/token;/Finance/verify;/Finance/confirm';
    menudetail.value.description = 'LS';
    menudetail.value.groupNameEN = 'Leasing';
    menudetail.value.groupNameLA = 'ຈ່າຍຄ່າໄຟຟ້າ';
    menudetail.value.groupNameVT = 'Trả tiền điện';
    menudetail.value.groupNameCH = '电费';
  }

  @override
  void onReady() async {
    super.onReady();
    // storage.write('msisdn', "2052768833");

    await checkAppUpdate();
  }

  String getMenuTitle() {
    // Get the current language code, default to 'en'
    String languageCode = box.read('language') ?? 'lo';

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

  Rx<AppInfoModel> rxAppinfo = AppInfoModel().obs;
  checkAppUpdate() async {
    var url = '${MyConstant.urlLtcdev}/AppInfo/Info';
    var res = await DioClient.getNoLoading(url);
    rxAppinfo.value = AppInfoModel.fromJson(res);

    final imageCardFile =
        await downloadBackgroundImg(rxAppinfo.value.bgimage!, 'image_card');
    if (imageCardFile != null) rxBgCard.value = imageCardFile.path;

    final imageBillFile =
        await downloadBackgroundImg(rxAppinfo.value.bgimage!, 'image_bill');
    if (imageBillFile != null) rxBgBill.value = imageBillFile.path;
  }

  Future<File?> downloadBackgroundImg(String imageUrl, String type) async {
    final dio = Dio();
    final String? storedImageUrl = box.read(type);
    final documentDirectory = await getApplicationDocumentsDirectory();
    final filePath =
        '${documentDirectory.path}/$type.png'; // Fixed file name to avoid duplicates
    File file = File(filePath);
    if (storedImageUrl == imageUrl && file.existsSync()) {
      print("✅ Image already exists and URL is the same. No need to download.");
      return file;
    }
    try {
      if (file.existsSync()) {
        file.deleteSync();
      }
      final response = await dio.get(imageUrl,
          options: Options(responseType: ResponseType.bytes));
      await file.writeAsBytes(response.data);
      box.write(type, imageUrl);
      print("✅ New image downloaded and saved.");
      return file;
    } catch (e) {
      print("❌ Failed to download image: $e");
      return null;
    }
  }
}
