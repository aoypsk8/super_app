// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/widget/textfont.dart';

class QRScannerScreen extends StatelessWidget {
  final MobileScannerController scannerController = MobileScannerController();
  final ImagePicker _imagePicker = ImagePicker();
  bool isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // QR code scanner view
          MobileScanner(
            controller: scannerController,
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                if (!isProcessing && barcode.rawValue != null) {
                  isProcessing = true; // Set flag to true to prevent duplicates.
                  String code = barcode.rawValue!;
                  Get.back(result: code); // Send scanned data back.
                  break;
                }
              }
            },
          ),
          // Overlay and controls
          Stack(
            children: [
              // Dim background outside the scan area
              Container(
                color: Colors.black.withOpacity(0.4),
              ),
              // Transparent scan area with a border
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 85.w,
                  height: 85.w,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    border: Border.all(color: Theme.of(context).primaryColor, width: 4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              // Gallery button
              Positioned(
                bottom: 40,
                left: 20,
                right: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () async {
                        final XFile? image = await _imagePicker.pickImage(
                          source: ImageSource.gallery,
                        );
                        if (image != null) {
                          final code = await _scanQRCodeFromImage(image.path);
                          if (code != null) {
                            Get.back(result: code);
                          } else {
                            Get.snackbar(
                              'Error',
                              'No QR code found in the image.',
                              backgroundColor: Theme.of(context).primaryColor,
                              colorText: color_fff,
                            );
                          }
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Icon(Icons.image, color: color_fff, size: 30.sp),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        Get.back();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Icon(Icons.close, color: color_fff, size: 30.sp),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Scan QR code from an image
  Future<String?> _scanQRCodeFromImage(String imagePath) async {
    try {
      final BarcodeCapture? capture = await scannerController.analyzeImage(imagePath);
      if (capture != null && capture.barcodes.isNotEmpty) {
        return capture.barcodes.first.rawValue;
      }
    } catch (e) {
      debugPrint('Error scanning QR code from image: $e');
    }
    return null;
  }
}
