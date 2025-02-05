import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:super_app/utility/color.dart';
import 'package:webview_flutter/webview_flutter.dart';

class OpenWebView extends StatefulWidget {
  final String url;

  OpenWebView({required this.url});

  @override
  _OpenWebViewState createState() => _OpenWebViewState();
}

class _OpenWebViewState extends State<OpenWebView> {
  var loadingPercentage = 0;
  late WebViewController _controller;
  bool check = false;

  final storage = GetStorage();

  @override
  void initState() {
    super.initState();
    webView();
  }

  void webView() async {
    var msisdn = await storage.read('msisdn');
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              loadingPercentage = progress;
            });
          },
          onPageStarted: (String url) {
            // ... (handle trigger-back logic if needed)
          },
          onPageFinished: (String url) {
            setState(() {
              loadingPercentage = 100;
            });
          },
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..loadRequest(
        Uri.parse("${widget.url}/?msisdn=${msisdn}"),
        // Uri.parse("https://mmoney.la/mounoy/"),
      );
    setState(() {
      check = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            check // Use check to conditionally render WebViewWidget
                ? WebViewWidget(
                    controller: _controller,
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
            if (loadingPercentage < 100)
              LinearProgressIndicator(
                value: loadingPercentage / 100.0,
                backgroundColor: color_f63,
                valueColor: AlwaysStoppedAnimation<Color>(color_f15),
              ),
            Positioned(
              top: 5,
              left: 0,
              child: Opacity(
                opacity: 0.7,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: color_fff,
                  ),
                  onPressed: () async {
                    if (await _controller.canGoBack()) {
                      await _controller.goBack();
                    } else {
                      Get.back();
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
