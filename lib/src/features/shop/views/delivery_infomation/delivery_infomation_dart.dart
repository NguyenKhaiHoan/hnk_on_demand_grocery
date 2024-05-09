import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/personalization/controllers/address_controller.dart';
import 'package:on_demand_grocery/src/features/personalization/models/address_model.dart';
import 'package:on_demand_grocery/src/routes/app_pages.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';

class DeliveryInfomationScreen extends StatefulWidget {
  const DeliveryInfomationScreen({super.key});

  @override
  State<DeliveryInfomationScreen> createState() =>
      _DeliveryInfomationScreenState();
}

class _DeliveryInfomationScreenState extends State<DeliveryInfomationScreen> {
  final addressController = AddressController.instance;
  bool isExtend = false;

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
        title: const Text("Thông tin giao hàng"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: hAppDefaultPaddingLR,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              const Text(
                'Địa chỉ giao hàng',
                style: HAppStyle.heading4Style,
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  Get.toNamed(HAppRoutes.allAddress);
                },
                child: Text("Xem tất cả",
                    style: HAppStyle.paragraph3Regular
                        .copyWith(color: HAppColor.hBluePrimaryColor)),
              ),
            ]),
            gapH12,
            Obx(() => FutureBuilder(
                key: Key(
                    'Addresses${addressController.toggleRefresh.value.toString()}'),
                future: addressController.fetchAllUserAddresses(),
                builder: ((context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) => AddressInformation(
                              address: AddressModel.empty(),
                              function: () => null,
                            ),
                        separatorBuilder: (context, index) => gapH12,
                        itemCount: 3);
                  }

                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Đã xảy ra sự cố. Xin vui lòng thử lại sau.'),
                    );
                  }

                  if (!snapshot.hasData ||
                      snapshot.data == null ||
                      snapshot.data!.isEmpty) {
                    return GestureDetector(
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
                    );
                  } else {
                    final addresses = snapshot.data!;
                    addresses.sort((a, b) {
                      if (a.selectedAddress && !b.selectedAddress) {
                        return -1;
                      }
                      if (!a.selectedAddress && b.selectedAddress) {
                        return 1;
                      }
                      return 0;
                    });
                    final listAddress =
                        !isExtend ? getTwoAddresses(addresses) : addresses;
                    return Column(
                      children: [
                        ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) => AddressInformation(
                                  address: listAddress[index],
                                  function: () {
                                    addressController
                                        .selectAddress(listAddress[index]);
                                  },
                                ),
                            separatorBuilder: (context, index) => gapH12,
                            itemCount: listAddress.length),
                        listAddress.isEmpty || addresses.length < 3
                            ? Padding(
                                padding: const EdgeInsets.only(
                                    top: hAppDefaultPadding),
                                child: GestureDetector(
                                  onTap: () {
                                    Get.toNamed(HAppRoutes.addAddress);
                                  },
                                  child: Container(
                                      width: HAppSize.deviceWidth,
                                      height: 50,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: HAppColor.hWhiteColor),
                                      child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
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
                            : Padding(
                                padding: const EdgeInsets.only(
                                    top: hAppDefaultPadding),
                                child: GestureDetector(
                                  onTap: () {
                                    isExtend = !isExtend;
                                    addressController.toggleRefresh.toggle();
                                  },
                                  child: Container(
                                      width: HAppSize.deviceWidth,
                                      height: 50,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: HAppColor.hWhiteColor),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            !isExtend
                                                ? EvaIcons.arrowDownwardOutline
                                                : EvaIcons.arrowUpwardOutline,
                                            size: 15,
                                          ),
                                          gapW4,
                                          Text(!isExtend
                                              ? 'Hiển thị thêm (${addresses.length - listAddress.length} địa chỉ)'
                                              : 'Thu gọn'),
                                        ],
                                      )),
                                ),
                              ),
                      ],
                    );
                  }
                }))),
            gapH24,
          ]),
        ),
      ),
    );
  }

  List<AddressModel> getTwoAddresses(List<AddressModel> addresses) {
    if (addresses.isEmpty) {
      return [];
    }
    if (addresses.length == 1) {
      return addresses;
    }
    AddressModel selectedAddress = addresses.firstWhere(
        (address) => address.selectedAddress,
        orElse: () => addresses.first);
    AddressModel anotherAddress = addresses.reversed.firstWhere(
        (address) => address != selectedAddress,
        orElse: () => AddressModel.empty());
    return [selectedAddress, anotherAddress];
  }
}

class AddressInformation extends StatelessWidget {
  AddressInformation(
      {super.key, required this.function, required this.address});

  final Function() function;

  final AddressModel address;
  final addressController = AddressController.instance;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Container(
          width: HAppSize.deviceWidth,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: HAppColor.hWhiteColor),
          padding:
              const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
          child: Row(
            children: [
              Obx(
                () => Icon(
                  EvaIcons.checkmarkCircle,
                  color:
                      addressController.selectedAddress.value.id == address.id
                          ? HAppColor.hBluePrimaryColor
                          : HAppColor.hGreyColorShade300,
                  size: 20,
                ),
              ),
              gapW10,
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      address.name,
                      style: HAppStyle.label2Bold,
                    ),
                    gapH4,
                    Text(
                        address.phoneNumber == ''
                            ? 'Số điện thoại còn trống'
                            : address.phoneNumber,
                        style: HAppStyle.paragraph3Regular.copyWith(
                            color: address.phoneNumber == ''
                                ? HAppColor.hRedColor
                                : HAppColor.hDarkColor)),
                    gapH4,
                    Text(
                      address.toString(),
                      style: HAppStyle.paragraph3Regular,
                    )
                  ],
                ),
              ),
              gapW10,
              GestureDetector(
                onTap: () {
                  AddressController.instance.initAddressBeforeChange(address);
                  Get.toNamed(HAppRoutes.changeAddress,
                      arguments: {'address': address});
                },
                child: const Icon(
                  EvaIcons.editOutline,
                  size: 20,
                ),
              ),
            ],
          )),
    );
  }
}
