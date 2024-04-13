import 'dart:typed_data';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';

class ScanQrCodeScreen extends StatelessWidget {
  const ScanQrCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        titleSpacing: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        backgroundColor: HAppColor.hTransparentColor,
        toolbarHeight: 80,
        title: Padding(
          padding: hAppDefaultPaddingL,
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: HAppColor.hGreyColorShade300,
                        width: 1.5,
                      ),
                      color: HAppColor.hBackgroundColor),
                  child: const Center(
                    child: Icon(
                      EvaIcons.arrowBackOutline,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: MobileScanner(
        controller: MobileScannerController(
          detectionSpeed: DetectionSpeed.noDuplicates,
          returnImage: true,
        ),
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          final Uint8List? image = capture.image;
          for (final barcode in barcodes) {
            print('Barcode found! ${barcode.rawValue}');
          }
          if (image != null) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(
                    "Mã đơn hàng: ${barcodes.first.rawValue ?? "Lỗi"}",
                  ),
                  content: Image(
                    image: MemoryImage(image),
                  ),
                  actions: [],
                );
              },
            );
          }
        },
      ),
    );
  }
}
