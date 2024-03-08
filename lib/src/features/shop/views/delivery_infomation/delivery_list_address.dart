import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';

class DeliveryAddress extends StatelessWidget {
  const DeliveryAddress({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        leading: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: hAppDefaultPadding),
            child: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: const Icon(
                  Icons.arrow_back_ios,
                  size: 20,
                )),
          ),
        ),
        title: const Text("Địa chỉ"),
        centerTitle: true,
      ),
      body: const SingleChildScrollView(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: HAppColor.hBluePrimaryColor,
        shape: const CircleBorder(),
        onPressed: () {},
        child: const Icon(
          EvaIcons.plus,
          color: HAppColor.hWhiteColor,
        ),
      ),
    );
  }
}
