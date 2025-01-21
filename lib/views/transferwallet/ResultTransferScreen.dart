import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:super_app/widget/myIcon.dart';
import 'package:saver_gallery/saver_gallery.dart';

class Resulttransferscreen extends StatefulWidget {
  const Resulttransferscreen({super.key});

  @override
  State<Resulttransferscreen> createState() => _ResulttransferscreenState();
}

class _ResulttransferscreenState extends State<Resulttransferscreen>
    with SingleTickerProviderStateMixin {
  final screenshotController = ScreenshotController();
  final GlobalKey _globalKey = GlobalKey();

  final storage = GetStorage();

  @override
  void initState() {
    super.initState();
    _saveScreen();
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// Take a screenshot and share it
  void _takeScreenshot() async {
    try {
      final image = await screenshotController.capture();
      if (image != null) {
        final directory = await getApplicationDocumentsDirectory();
        final imagePath = File('${directory.path}/image.png');
        await imagePath.writeAsBytes(image);
        await Share.shareXFiles([XFile(imagePath.path)]);
      }
    } catch (e) {
      print("Error taking screenshot: $e");
    }
  }

  Future<void> _saveScreen() async {
    try {
      RenderRepaintBoundary boundary = _globalKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage();
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData != null) {
        String picturesPath = "${DateTime.now().millisecondsSinceEpoch}.jpg";
        final result = await SaverGallery.saveImage(
          byteData.buffer.asUint8List(),
          fileName: picturesPath,
          skipIfExists: false,
        );
        print(result.toString());
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RepaintBoundary(
        key: _globalKey,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(MyIcon.bg_backgroundTrnasfer),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Text(
              'Result Transfer Screen',
              style: const TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
        ),
      ),
    );
  }
}
