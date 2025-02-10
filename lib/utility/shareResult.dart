import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

sharedScreenshot(ScreenshotController screenshotController) async {
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
