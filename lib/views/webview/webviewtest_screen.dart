import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:url_launcher/url_launcher.dart';

class WebViewTestScreen extends StatelessWidget {
  final String url;

  const WebViewTestScreen({super.key, required this.url});

  void _launchURL() async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Web View'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _launchURL,
          child: const Text('Open in Browser'),
        ),
      ),
    );
  }
}
