import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class GenerateCodePage extends StatefulWidget {
  const GenerateCodePage({super.key});

  @override
  State<GenerateCodePage> createState() => _GenerateCodePageState();
}

class _GenerateCodePageState extends State<GenerateCodePage> {
  String? qrData = Get.arguments['orderId'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (qrData != null)
            PrettyQrView.data(data: qrData!)
          else
            const Text("Lỗi, không tải được mã QR")
        ],
      ),
    );
  }
}
