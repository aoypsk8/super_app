// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:super_app/controllers/home_controller.dart';
import 'package:super_app/utility/color.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewScreen extends StatefulWidget {
  const WebviewScreen({super.key});

  @override
  State<WebviewScreen> createState() => _WebviewScreenState();
}

class _WebviewScreenState extends State<WebviewScreen> {
  final HomeController homeController = Get.find();
  var loadingPercentage = 0;
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..loadRequest(
        Uri.parse(homeController.urlwebview.value),
      )
      ..setJavaScriptMode(
        JavaScriptMode.unrestricted,
      )
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() {
              loadingPercentage = 0;
            });
          },
          onProgress: (progress) {
            setState(() {
              loadingPercentage = progress;
            });
          },
          onPageFinished: (url) {
            setState(() {
              loadingPercentage = 100;
            });
          },
        ),
      );
    // ..addJavaScriptChannel(
    //   'CHANNEL_NAME',
    //   onMessageReceived: (JavaScriptMessage message) {
    //     print(message.message.runtimeType);
    //     print(message.message);
    //     var test = jsonDecode(message.message);
    //     print(test.runtimeType);
    //     print(test);
    //     var test2 = jsonEncode(test);
    //     print(test2.runtimeType);
    //     print(test2);

    //     // Get.close(1);
    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
      ),
      body: Builder(builder: (BuildContext context) {
        return Stack(
          children: [
            WebViewWidget(
              controller: controller,
            ),
            if (loadingPercentage < 100)
              LinearProgressIndicator(
                value: loadingPercentage / 100.0,
                backgroundColor: color_f63,
                valueColor: AlwaysStoppedAnimation<Color>(color_f15),
              ),
          ],
        );
      }),
      // floatingActionButton: favoriteButton(),
    );
  }
}
