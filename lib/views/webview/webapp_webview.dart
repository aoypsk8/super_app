// // ignore_for_file: deprecated_member_use

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:screenshot/screenshot.dart';
// import 'package:super_app/controllers/home_controller.dart';
// import 'package:super_app/controllers/user_controller.dart';
// import 'package:super_app/widget/textfont.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class WebappWebviewScreen extends StatefulWidget {
//   const WebappWebviewScreen({super.key, required this.isMenu});
//   final bool isMenu;

//   @override
//   State<WebappWebviewScreen> createState() => _WebappWebviewScreenState();
// }

// class _WebappWebviewScreenState extends State<WebappWebviewScreen> {
//   late WebViewController controller;
//   var loadingPercentage = 0;
//   HomeController homeController = Get.find();
//   UserController userController = Get.find();

//   void _launchURL(String url) async {
//     if (await canLaunch(url)) {
//       await launch(url);
//     } else {
//       throw 'Could not launch $url';
//     }
//   }

//   Future<void> _launchInBrowser(Uri url) async {
//     if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
//       throw Exception('Could not launch $url');
//     }
//   }

//   void sendDataToWeb(String data) {
//     controller.runJavaScript('window.receiveNewToken("$data")');
//   }

//   @override
//   void initState() {
//     super.initState();
//     String url = 'https://qrs1n5sd-3000.asse.devtunnels.ms/ftth/';
//     var param = '?token=${userController.rxToken.value}&custPhone=${userController.rxMsisdn.value}';
//     debugPrint('param: $param');

//     url += param;

//     debugPrint('url: $url');
//     controller = WebViewController()
//       //..loadRequest(Uri.parse('https://splus.app/?app=scn'))
//       ..loadRequest(Uri.parse(url))
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setBackgroundColor(const Color(0x00000000))
//       ..addJavaScriptChannel('closeWebview', onMessageReceived: (JavaScriptMessage message) async {
//         debugPrint('message: ${message.message}');
//         Get.back();
//       })
//       ..addJavaScriptChannel('refreshToken', onMessageReceived: (JavaScriptMessage message) async {
//         debugPrint('message: ${message.message}');
//         userController.isRenewToken.value = true;
//         bool isValidToken = await userController.checktokenSuperApp();
//         if (!isValidToken) sendDataToWeb(userController.rxToken.value);
//       })
//       ..addJavaScriptChannel('dowloadImage', onMessageReceived: (JavaScriptMessage message) async {
//         debugPrint('message: ${message.message}');
//       })
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onProgress: (int progress) {
//             setState(() {
//               loadingPercentage = progress;
//             });
//           },
//           onPageStarted: (String url) {
//             // ... (handle trigger-back logic if needed)
//           },
//           onPageFinished: (String url) {
//             setState(() {
//               loadingPercentage = 100;
//             });
//           },
//           onNavigationRequest: (NavigationRequest request) {
//             if (request.url.startsWith('https://splus.app')) {
//               return NavigationDecision.navigate;
//             } else if (request.url.startsWith('http') || request.url.startsWith('https')) {
//               if (Platform.isIOS) {
//                 return NavigationDecision.navigate;
//               }
//               if (Platform.isAndroid) {
//                 final uri = Uri.parse(request.url);
//                 _launchInBrowser(uri);
//                 return NavigationDecision.prevent;
//               }
//               _launchURL(request.url);
//               return NavigationDecision.prevent;
//             } else if (request.url.startsWith('tel:') || request.url.startsWith('mailto:')) {
//               _launchURL(request.url);
//               return NavigationDecision.prevent;
//             } else {
//               final uri = Uri.parse(request.url);
//               _launchInBrowser(uri);
//               return NavigationDecision.prevent;
//             }
//           },
//         ),
//       );
//   }

//   final ScreenshotController screenshotController = ScreenshotController();

//   @override
//   Widget build(BuildContext context) {
//     final TextEditingController _searchController = TextEditingController();
//     return Scaffold(
//       backgroundColor: Colors.grey.shade300,
//       appBar: AppBar(
//         title: Obx(
//           () => TextFont(
//             text: userController.rxToken.value,
//             maxLines: 3,
//           ),
//         ),
//       ),
//       body:
//           loadingPercentage != 100 ? Center(child: CircularProgressIndicator()) : WebViewWidget(controller: controller),
//     );
//   }
// }

// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:screenshot/screenshot.dart';
import 'package:super_app/controllers/home_controller.dart';
import 'package:super_app/controllers/user_controller.dart';
import 'package:super_app/views/login/temp/temp_userprofile_model.dart';
import 'package:super_app/views/webview/refresh_token.dart';
import 'package:super_app/widget/textfont.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebappWebviewScreen extends StatefulWidget {
  const WebappWebviewScreen({super.key, required this.urlWidget});
  final String urlWidget;

  @override
  State<WebappWebviewScreen> createState() => _WebappWebviewScreenState();
}

class _WebappWebviewScreenState extends State<WebappWebviewScreen> {
  late WebViewController controller;
  var loadingPercentage = 0;
  HomeController homeController = Get.find();
  UserController userController = Get.find();
  final ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  /// ✅ Initializes the WebView with the correct URL
  void _initializeWebView() {
    String url = widget.urlWidget;
    var param = '?token=${userController.rxToken.value}&custPhone=${userController.rxMsisdn.value}';
    // url += param;
    debugPrint('WebView URL: $url');

    controller = WebViewController()
      ..loadRequest(Uri.parse(url))
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..addJavaScriptChannel('closeWebview', onMessageReceived: (JavaScriptMessage message) async {
        debugPrint('Message: ${message.message}');
        Get.back();
      })
      ..addJavaScriptChannel('refreshToken', onMessageReceived: (JavaScriptMessage message) async {
        debugPrint('Received refreshToken request from WebView');
        _handleTokenRefresh();
      })
      ..addJavaScriptChannel('downloadImage', onMessageReceived: (JavaScriptMessage message) async {
        debugPrint('Message: ${message.message}');
      })
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              loadingPercentage = progress;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              loadingPercentage = 100;
            });
          },
          // onNavigationRequest: (NavigationRequest request) {
          //   return _handleNavigation(request);
          // },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('http') || request.url.startsWith('https')) {
              if (Platform.isIOS) {
                return NavigationDecision.navigate;
              }
              if (Platform.isAndroid) {
                final uri = Uri.parse(request.url);
                _launchInBrowser(uri);
                return NavigationDecision.prevent;
              }
              _launchURL(request.url);
              return NavigationDecision.prevent;
            } else if (request.url.startsWith('tel:') || request.url.startsWith('mailto:')) {
              _launchURL(request.url);
              return NavigationDecision.prevent;
            } else {
              final uri = Uri.parse(request.url);
              _launchInBrowser(uri);
              return NavigationDecision.prevent;
            }
          },
        ),
      );
  }

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $url');
    }
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      debugPrint('Could not launch $url');
    }
  }

  Future<void> _handleTokenRefresh() async {
    userController.isRenewToken.value = true;
    final storage = GetStorage();
    TempUserProfileStorage boxUser = TempUserProfileStorage();
    TempUserProfile? lastUser = boxUser.getLastLoggedInUser();

    bool? loginSuccess =
        await Get.to(() => RefreshTokenWebview(user: lastUser!.toJson()), transition: Transition.downToUp);

    if (loginSuccess == true) {
      debugPrint("✅ Login successful, sending new token to WebView");
      sendDataToWeb(userController.rxToken.value);
    } else {
      debugPrint("❌ Login failed, WebView remains unchanged");
    }
  }

  void sendDataToWeb(String newToken) {
    controller.runJavaScript('window.receiveNewToken("$newToken")');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      // appBar: AppBar(
      //   title: Obx(
      //     () => TextFont(
      //       text: userController.rxToken.value,
      //       maxLines: 3,
      //     ),
      //   ),
      // ),
      body: SafeArea(
        child: loadingPercentage != 100
            ? const Center(child: CircularProgressIndicator())
            : WebViewWidget(controller: controller),
      ),
    );
  }
}
