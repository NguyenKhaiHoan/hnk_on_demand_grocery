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
  List<String> days = ["Th 2", "Th 3", "Th 4", "Th 5", "Th 6", "Th 7", "CN"];

  List<String> days2 = [
    "Thứ 2",
    "Thứ 3",
    "Thứ 4",
    "Thứ 5",
    "Thứ 6",
    "Thứ 7",
    "Chủ nhật"
  ];

  DateTime selectedDate = DateTime.now();

  int currentDateSelectedIndex = 0;
  ScrollController scrollController = ScrollController();

  final addressController = Get.put(AddressController());

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
                key: Key(addressController.isLoading.value.toString()),
                future: addressController.fetchAllUserAddresses(),
                builder: ((context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) => AddressInformation(
                              address: AddressModel.empty(),
                              function: () {},
                            ),
                        separatorBuilder: (context, index) => gapH12,
                        itemCount: 2);
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
                    final listAddress = getTwoAddresses(addresses);
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
                        listAddress.length < 2
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
                            : Container(),
                      ],
                    );
                  }
                }))),
            gapH24,
            Row(children: [
              const Text(
                'Ngày giao hàng',
                style: HAppStyle.heading4Style,
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {},
                child: Text(
                    '${days2[selectedDate.weekday - 1]}, ${selectedDate.day}-${selectedDate.month}-${selectedDate.year}',
                    style: HAppStyle.paragraph3Regular
                        .copyWith(color: HAppColor.hBluePrimaryColor)),
              ),
            ]),
            gapH12,
            SizedBox(
                height: 60,
                child: ListView.separated(
                  separatorBuilder: (BuildContext context, int index) {
                    return gapW10;
                  },
                  itemCount: 7,
                  controller: scrollController,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          currentDateSelectedIndex = index;
                          selectedDate =
                              DateTime.now().add(Duration(days: index));
                        });
                      },
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: currentDateSelectedIndex == index
                                ? HAppColor.hBluePrimaryColor
                                : HAppColor.hWhiteColor),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                                days[DateTime.now()
                                            .add(Duration(days: index))
                                            .weekday -
                                        1]
                                    .toString(),
                                style: HAppStyle.paragraph2Bold.copyWith(
                                    color: currentDateSelectedIndex == index
                                        ? HAppColor.hWhiteColor
                                        : HAppColor.hGreyColorShade600)),
                            Text(
                                DateTime.now()
                                    .add(Duration(days: index))
                                    .day
                                    .toString(),
                                style: HAppStyle.heading4Style.copyWith(
                                    color: currentDateSelectedIndex == index
                                        ? HAppColor.hWhiteColor
                                        : HAppColor.hGreyColorShade600)),
                          ],
                        ),
                      ),
                    );
                  },
                ))
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
    AddressModel defaultAddress = addresses.firstWhere(
        (address) => address.isDefault && address != selectedAddress,
        orElse: () => addresses.firstWhere(
            (address) => address != selectedAddress,
            orElse: () => AddressModel.empty()));
    return [selectedAddress, defaultAddress];
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
      child: Stack(children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: HAppColor.hWhiteColor),
          padding:
              const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                address.name,
                style: HAppStyle.label2Bold,
              ),
              gapH4,
              Text(address.phoneNumber, style: HAppStyle.paragraph3Regular),
              gapH4,
              Text(
                address.toString(),
                style: HAppStyle.paragraph3Regular,
              )
            ],
          ),
        ),
        Obx(
          () => addressController.selectedAddress.value.id == address.id
              ? Positioned(
                  top: 5,
                  right: 5,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      EvaIcons.checkmarkCircle,
                      color: HAppColor.hBluePrimaryColor,
                      size: 20,
                    ),
                  ))
              : Container(),
        )
      ]),
    );
  }
}
