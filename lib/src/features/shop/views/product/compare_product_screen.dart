import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';

class CompareProductScreen extends StatefulWidget {
  const CompareProductScreen({super.key});

  @override
  State<CompareProductScreen> createState() => _CompareProductScreenState();
}

class _CompareProductScreenState extends State<CompareProductScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("So sánh chi tiết"),
        centerTitle: true,
        toolbarHeight: 80,
        leadingWidth: 100,
        leading: Padding(
          padding: hAppDefaultPaddingL,
          child: GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
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
        ),
      ),
      body: const SingleChildScrollView(
        child: Padding(
            padding: hAppDefaultPaddingLR,
            child: Center(
              child: Text("Chưa thiết kế xong"),
            )),
      ),
    );
  }
}
