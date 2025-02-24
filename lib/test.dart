import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

import 'package:super_app/widget/textfont.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  static const platform = MethodChannel('device_info_channel');
  String deviceInfoText = "";

  Future<void> getDeviceInfo() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String info = '';

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      info = '''
      - Model: ${androidInfo.model}
      - DeviceID: ${androidInfo.id}
      - DeviceModel: ${androidInfo.model}
      - DeviceName: ${androidInfo.name}
      - OSversion: ${androidInfo.version.release}|SDK${androidInfo.version.sdkInt}|${androidInfo.board}
      ''';
    } else if (Platform.isIOS) {
      try {
        final Map<dynamic, dynamic> result = await platform.invokeMethod("getDeviceDetails");

        info = '''
        - Device Name (User-set): ${result["deviceName"]}
        - Model: ${result["deviceModel"]}
        - Hardware Model: ${result["hardwareModel"]}
        - OS Version: ${result["systemVersion"]}
        - Device ID (UUID): ${result["deviceID"]}
        ''';

        print(info);
      } on PlatformException catch (e) {
        info = "Error retrieving device details: ${e.message}";
      }
    }

    setState(() {
      deviceInfoText = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Device Info")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFont(
              text: deviceInfoText,
              maxLines: 10,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: getDeviceInfo,
              child: Text("Show Device Info"),
            ),
          ],
        ),
      ),
    );
  }
}
