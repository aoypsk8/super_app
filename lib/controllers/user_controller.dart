// ignore_for_file: avoid_print

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:super_app/models/balance_model.dart';
import 'package:super_app/models/user_profile_model.dart';
import 'package:super_app/services/api/dio_client.dart';
import 'package:super_app/utility/myconstant.dart';

class UserController extends GetxController {
  final storage = GetStorage();
  RxString walletid = ''.obs;
  RxString profileName = ''.obs;
  RxString birthday = ''.obs;

  // profile
  Rx<UserProfileModel> userProfilemodel = UserProfileModel().obs;

  // balance
  Rx<BalanceModel> balanceModel = BalanceModel().obs;
  RxInt totalBalance = 0.obs;
  RxInt mainBalance = 0.obs;
  RxInt pointBalance = 0.obs;

  //auth
  RxString rxMsisdn = '2052768833'.obs;

  RxString rxLat = ''.obs;
  RxString rxLong = ''.obs;

  RxString rxToken = ''.obs;

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

  Future checktoken({String? name}) async {
    getCurrentLocation();
  }

  Future<void> loginpincode(String msisdn, String pincode) async {
    try {
      final response = await DioClient.postEncrypt('${MyConstant.urlGateway}/login', {"msisdn": msisdn, "pin": pincode});
      if (response != null && response["resultCode"] == 0) {
        final token = response['token'];
        if (token != null) {
          await storage.write('token', token);
          rxToken.value = token;
          print('Token: $token');
        }
      } else {
        print('Error: Login failed with resultCode ${response?["resultCode"] ?? "unknown"}');
      }
    } catch (e) {
      print('Error during login: $e');
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print("Location permission denied");
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        print("Location permission permanently denied. Please enable it in settings.");
        return;
      }
      Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
        forceAndroidLocationManager: true,
      );
      // Update latitude and longitude
      rxLat.value = currentPosition.latitude.toString();
      rxLong.value = currentPosition.longitude.toString();
      print('Latitude: ${rxLat.value}, Longitude: ${rxLong.value}');
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  Future<void> fetchBalance() async {
    try {
      // Retrieve token and msisdn from storage
      var token = await storage.read('token');
      var msisdn = await storage.read('msisdn');

      if (token == null || msisdn == null) {
        print('Error: Missing token or msisdn');
        return;
      }
      var url = '${MyConstant.urlConsumerInfo}/UserProfile';
      var data = {"msisdn": msisdn};

      var response = await DioClient.postEncrypt(loading: false, url, data, key: 'lmm-key');

      if (response["resultCode"] == 0) {
        balanceModel.value = BalanceModel.fromJson(response);

        var result = balanceModel.value.data;
        if (result != null) {
          walletid.value = result.walletIds ?? '';
          birthday.value = result.birthday ?? '';
          totalBalance.value = result.amount ?? 0;
          mainBalance.value = result.fiat ?? 0;
          pointBalance.value = result.point ?? 0;
          profileName.value = '${result.firstname ?? ''} ${result.lastname ?? ''}'.trim();
        }
      } else {
        print('Error: ${response["resultMessage"] ?? "Unknown error occurred"}');
      }
    } catch (e) {
      print('Error in fetchBalance: $e');
    }
  }

  queryUserProfile() async {
    try {
      // Retrieve the token from storage
      var token = await storage.read('token');
      var msisdn = await storage.read('msisdn');

      // Check if token and msisdn are valid
      if (token == null || msisdn == null) {
        print('Error: Missing token or msisdn');
        return;
      }
      var url = '${MyConstant.urlUser}/query';
      var data = {"msisdn": msisdn};
      var response = await DioClient.postEncrypt(loading: false, url, data, key: 'lmm');
      if (response != null) {
        userProfilemodel.value = UserProfileModel.fromJson(response);
      } else {
        print('Error: Response is null');
      }
    } catch (e) {
      print('Error in queryKyc: $e');
    }
  }
}
