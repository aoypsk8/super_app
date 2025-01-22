import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

class Device {
  static Future<String> getOsVersion() async {
    var osVersion = '';
    if (Platform.isAndroid) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      osVersion = 'Android ${androidInfo.version.release}';
      // print('xxx-deviceInfo $deviceInfo');
      // print('xxx-androidInfo $androidInfo');
    } else {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      osVersion = '${iosInfo.systemName} ${iosInfo.systemVersion}';
      // print('xxx-deviceInfo $deviceInfo');
      // print('xxx-iosInfo $iosInfo');
    }
    return osVersion;
  }

  static Future<String> getDeviceModel() async {
    var deviceModel = '';
    if (Platform.isAndroid) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceModel = '${androidInfo.manufacturer} ${androidInfo.model}';
      // print('xxx-deviceInfo $deviceInfo');
      // print('xxx-androidInfo $androidInfo');
    } else {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceModel = '${iosInfo.name} ${iosInfo.model}';
      // print('xxx-deviceInfo $deviceInfo');
      // print('xxx-iosInfo $iosInfo');
    }
    return deviceModel;
  }

  static Future<String> getDeviceKey() async {
    var deviceKey = '';
    if (Platform.isAndroid) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceKey = 'Android ${androidInfo.id}';
    } else {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceKey = 'IOS ${iosInfo.localizedModel}';
    }
    return deviceKey;
  }
}
