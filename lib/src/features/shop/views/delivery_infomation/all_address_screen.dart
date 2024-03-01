import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/constants/app_assets.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/authentication/controller/forget_password_controller.dart';
import 'package:on_demand_grocery/src/features/authentication/views/change_password/widgets/form_change_password_widget.dart';
import 'package:on_demand_grocery/src/features/authentication/views/login/widgets/form_login_widget.dart';
import 'package:on_demand_grocery/src/features/personalization/controllers/address_controller.dart';
import 'package:on_demand_grocery/src/features/personalization/models/address_model.dart';
import 'package:on_demand_grocery/src/features/personalization/views/change_name/widgets/form_change_name.dart';
import 'package:on_demand_grocery/src/features/shop/views/delivery_infomation/delivery_infomation_dart.dart';
import 'package:on_demand_grocery/src/features/shop/views/delivery_infomation/widgets/form_add_address.dart';
import 'package:on_demand_grocery/src/routes/app_pages.dart';

class AllAddressScreen extends StatefulWidget {
  const AllAddressScreen({super.key});

  @override
  State<AllAddressScreen> createState() => _AllAddressScreenState();
}

class _AllAddressScreenState extends State<AllAddressScreen> {
  final forgetPasswordController = Get.put(ForgetPasswordController());

  final addressController = AddressController.instance;
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
        title: const Text("Tất cả địa chỉ"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: hAppDefaultPaddingLR,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => FutureBuilder(
                key: Key(addressController.isLoading.value.toString()),
                future: addressController.fetchAllUserAddresses(),
                builder: ((context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                          color: HAppColor.hBluePrimaryColor),
                    );
                  }

                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Đã xảy ra sự cố. Xin vui lòng thử lại sau.'),
                    );
                  }

                  if (!snapshot.hasData ||
                      snapshot.data == null ||
                      snapshot.data!.isEmpty) {
                    return Container();
                  } else {
                    final addresses = snapshot.data!;

                    return Column(
                      children: [
                        ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) => AddressInformation(
                                  address: addresses[index],
                                  function: () {
                                    addressController
                                        .selectAddress(addresses[index]);
                                  },
                                ),
                            separatorBuilder: (context, index) => gapH12,
                            itemCount: addresses.length),
                      ],
                    );
                  }
                }))),
            gapH12,
            Padding(
              padding: const EdgeInsets.only(top: hAppDefaultPadding),
              child: GestureDetector(
                onTap: () {
                  Get.toNamed(HAppRoutes.addAddress);
                },
                child: Container(
                    width: HAppSize.deviceWidth,
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: HAppColor.hWhiteColor),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          EvaIcons.plusCircleOutline,
                          size: 15,
                        ),
                        gapW4,
                        Text("Thêm địa chỉ giao hàng"),
                      ],
                    )),
              ),
            )
          ],
        ),
      )),
    );
  }
}
