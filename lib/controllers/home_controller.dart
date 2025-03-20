// ignore_for_file: invalid_use_of_protected_member, avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:flutter_cache/flutter_cache.dart' as cache;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:super_app/models/appinfo_model.dart';
import 'package:super_app/models/home_model.dart';
import 'package:super_app/models/menu_model.dart';
import 'package:super_app/models/notification_model.dart';
import 'package:super_app/services/api/dio_client.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/utility/dialog_helper.dart';
import 'package:super_app/utility/myconstant.dart';
import 'package:super_app/widget/textfont.dart';

class HomeController extends GetxController {
  final box = GetStorage();
  RxString rxBgCard = ''.obs;
  RxString rxBgBill = ''.obs;
  RxString urlwebview = ''.obs;
  RxBool TPlus_theme = false.obs;

// USD AMOUNT
  RxDouble RxamountUSD = 0.0.obs;
  RxInt RxrateUSDKIP = 0.obs;
  //version
  RxString appVersion = ''.obs;

  RxString menutitle = ''.obs;
  RxList<MenuModel> menuModel = <MenuModel>[].obs; // Model of menuModel
  RxList<Menulists> menulist = <Menulists>[].obs; // List of menu items
  Rx<Menulists> menudetail = Menulists().obs; // Selected menu item

  //notify
  RxList<MessageList> messageList = <MessageList>[].obs;
  Rx<MessageList> messageListDetail = MessageList().obs;
  RxInt messageUnread = 0.obs;

  // advertiment
  RxList<AdsList> adslist = <AdsList>[].obs;
  Rx<AdsList> hotproduct = AdsList().obs;
  Rx<AdsList> banner = AdsList().obs;
  Rx<AdsList> moreoption = AdsList().obs;
  Rx<AdsList> recommend = AdsList().obs;

  //! clear data
  clear() async {
    menutitle = ''.obs;
    menudetail = Menulists().obs;
  }
  // HomeController() {
  //   // menudetail.value.url =
  //   //     '/Electric/getList;/Electric/verify;/Electric/payment;/Electric/getRecent;/Electric/history;';
  //   // menudetail.value.url =
  //   //     '/Bank/getList;/Bank/getRecent;/Bank/verify;/Bank/reqCashOut;/Bank/payment';
  //   // menudetail.value.url =
  //   //     '/Finance/getlist;/Finance/token;/Finance/verify;/Finance/confirm';
  //   // menudetail.value.description = 'EL';
  //   // menudetail.value.groupNameEN = 'Electric';
  //   // menudetail.value.groupNameLA = 'ຈ່າຍຄ່າໄຟຟ້າ';
  //   // menudetail.value.groupNameVT = 'Trả tiền điện';
  //   // menudetail.value.groupNameCH = '电费';
  // }

  @override
  void onReady() async {
    super.onReady();
    // storage.write('msisdn', "2052768833");

    getAppVersion();
    fetchads();
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

  fetchServicesmMenu(msisdn) async {
    bool TPlusIcons = await box.read("isDarkMode") ?? false;
    print(TPlusIcons);
    TPlus_theme.value = TPlusIcons;
    try {
      var response = await DioClient.postEncrypt(
          loading: false, '/SuperApi/Info/Menus', {"msisdn": msisdn});
      if (response != null && response is List) {
        List<MenuModel> fetchedMenuModel = response
            .map<MenuModel>((json) => MenuModel.fromJson(json))
            .toList();
        menuModel.assignAll(fetchedMenuModel);
        if (fetchedMenuModel.isNotEmpty &&
            fetchedMenuModel[0].menulists != null &&
            fetchedMenuModel[0].menulists!.isNotEmpty) {
          menulist.assignAll(fetchedMenuModel[0].menulists!);
        }
      } else {
        print('Unexpected response structure');
      }
    } catch (e) {
      print("Error: $e");
      DialogHelper.showErrorDialogNew(description: e.toString());
    }
  }

  // message
  fetchMessageList() async {
    try {
      var token = await box.read('token');
      var msisdn = await box.read('msisdn');
      if (token != null && msisdn != null) {
        messageList.value = (await DioClient.postEncrypt(
          loading: false,
          '${MyConstant.urlOther}/MessageList',
          {'msisdn': msisdn},
        ) as List)
            .map((e) => MessageList.fromJson(e))
            .toList();
      }
    } catch (e) {
      print(e);
    }
  }

  updateMessageStatus(int id) async {
    await DioClient.postEncrypt(
        loading: false, '${MyConstant.urlOther}/UpdateMessage', {'msisdn': id});
    fetchMessageList();
    fetchMessageUnread();
  }

  fetchMessageUnread() async {
    var token = await box.read('token');
    var msisdn = await box.read('msisdn');
    if (token != null && msisdn != null) {
      var response = await DioClient.postEncrypt(
          loading: false,
          '${MyConstant.urlOther}/UnreadMessage',
          {'msisdn': msisdn});
      if (response != null) {
        if (response['resultCode'] == "000") {
          messageUnread.value = response['total_unread'];
        }
      }
    }
  }

  Future<void> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appVersion.value = packageInfo.version;
    print('appVersion: ${appVersion}');
  }

  convertRate(int amountkip) async {
    var response = await DioClient.postEncrypt(
        '${MyConstant.urlVisa}/ConvertRate', {'amount': amountkip});
    if (response['code'] == 0) {
      print(response);
      RxrateUSDKIP.value = response['rate'];
      return response['usd'];
    }
  }

  fetchads() async {
    //! check cache exist
    var cacheData = await cache.load('ads', null);

    if (cacheData == null) {
      print('${MyConstant.urlAddress}/Ads');
      var response = await DioClient.postEncrypt(
        '${MyConstant.urlAddress}/Ads',
        {},
        loading: false,
      );
      if (response != null) {
        //! save cache
        await cache.remember('ads', jsonEncode(response), 60 * 5);
        adslist.value =
            response.map<AdsList>((json) => AdsList.fromJson(json)).toList();
        for (var i = 0; i < adslist.value.length; i++) {
          if (adslist.value[i].index == '0') banner.value = adslist.value[i];
          if (adslist.value[i].index == '1')
            hotproduct.value = adslist.value[i];
          if (adslist.value[i].index == '2') recommend.value = adslist.value[i];
          if (adslist.value[i].index == '3')
            moreoption.value = adslist.value[i];
        }
      }
    } else {
      //! load cache
      adslist.value = jsonDecode(cacheData)
          .map<AdsList>((json) => AdsList.fromJson(json))
          .toList();
      for (var i = 0; i < adslist.value.length; i++) {
        if (adslist.value[i].index == '0') banner.value = adslist.value[i];
        if (adslist.value[i].index == '1') hotproduct.value = adslist.value[i];
        if (adslist.value[i].index == '2') recommend.value = adslist.value[i];
        if (adslist.value[i].index == '3') moreoption.value = adslist.value[i];
      }
    }
  }
}
