import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/constants/app_assets.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/authentication/controller/forget_password_controller.dart';
import 'package:on_demand_grocery/src/features/authentication/views/change_password/widgets/form_change_password_widget.dart';
import 'package:on_demand_grocery/src/features/authentication/views/login/widgets/form_login_widget.dart';
import 'package:on_demand_grocery/src/features/personalization/views/change_name/widgets/form_change_name.dart';
import 'package:on_demand_grocery/src/features/shop/views/delivery_infomation/widgets/form_add_address.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final forgetPasswordController = Get.put(ForgetPasswordController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
        title: const Text("Thêm địa chỉ"),
        centerTitle: true,
      ),
      body: const SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [FormAddAddressWidget()],
      )),
    );
  }
}
