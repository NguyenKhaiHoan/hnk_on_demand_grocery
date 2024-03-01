import 'dart:math';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/data/dummy_data.dart';
import 'package:on_demand_grocery/src/features/personalization/controllers/address_controller.dart';
import 'package:on_demand_grocery/src/features/personalization/models/address_model.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/date_delivery_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/order_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/product_controller.dart';
import 'package:on_demand_grocery/src/features/shop/models/recent_oder_model.dart';
import 'package:on_demand_grocery/src/features/shop/views/home/widgets/product_list_stack.dart';
import 'package:on_demand_grocery/src/routes/app_pages.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';
import 'package:shimmer/shimmer.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String selected = 'Tiền mặt';
  final productController = Get.put(ProductController());
  final addressController = AddressController.instance;
  final dateDeliveryController = Get.put(DateDeliveryController());
  final orderController = OrderController.instance;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.scheduleFrameCallback((_) {});
  }

  Random random = Random();

  String letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  String digits = '0123456789';

  String generateId(int length) {
    String result = '';
    for (int i = 0; i < length ~/ 2; i++) {
      int letterIndex = random.nextInt(letters.length);
      result += letters[letterIndex];
      int digitIndex = random.nextInt(digits.length);
      result += digits[digitIndex];
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thanh toán"),
        centerTitle: true,
        toolbarHeight: 80,
        leadingWidth: 100,
        leading: Row(
          children: [
            gapW12,
            GestureDetector(
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
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: hAppDefaultPaddingLR,
          child: Column(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Thông tin giao hàng",
                      style: HAppStyle.heading4Style,
                    ),
                    GestureDetector(
                      onTap: () => Get.toNamed(HAppRoutes.deliveryInfomation),
                      child: Text(
                        "Sửa",
                        style: HAppStyle.paragraph3Regular
                            .copyWith(color: HAppColor.hBluePrimaryColor),
                      ),
                    ),
                  ],
                ),
                gapH16,
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          width: 1.5, color: HAppColor.hGreyColorShade300)),
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, top: 10, bottom: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() => FutureBuilder(
                          key:
                              Key(addressController.isLoading.value.toString()),
                          future: addressController.fetchAllUserAddresses(),
                          builder: ((context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Shimmer.fromColors(
                                  baseColor: Colors.grey.shade300,
                                  highlightColor: Colors.grey.shade100,
                                  child: AddressCheckoutWidget(
                                    model: AddressModel.empty(),
                                  ));
                            }

                            if (snapshot.hasError) {
                              return const Center(
                                child: Text(
                                    'Đã xảy ra sự cố. Xin vui lòng thử lại sau.'),
                              );
                            }

                            if (!snapshot.hasData ||
                                snapshot.data == null ||
                                snapshot.data!.isEmpty) {
                              return const Text(
                                  'Địa chỉ giao hàng trống, hãy thêm đia chỉ giao hàng.');
                            } else {
                              final addresses = snapshot.data!;
                              return AddressCheckoutWidget(
                                  model: addresses.firstWhere(
                                      (address) => address.selectedAddress,
                                      orElse: () => addresses.first));
                            }
                          }))),
                      Divider(
                        color: HAppColor.hGreyColorShade300,
                      ),
                      gapH4,
                      Obx(() => dateDeliveryController.date.value == ''
                          ? Text(DateFormat('EEEE, d-M-y', 'vi')
                              .format(DateTime.now())
                              .toString())
                          : Text(dateDeliveryController.date.value)),
                    ],
                  ),
                )
              ],
            ),
            gapH24,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Phương thức thanh toán",
                  style: HAppStyle.heading4Style,
                ),
                gapH16,
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          width: 1.5, color: HAppColor.hGreyColorShade300)),
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, top: 10, bottom: 10),
                  child: Column(
                    children: [
                      RadioListTile<String>(
                        contentPadding: EdgeInsets.zero,
                        visualDensity: const VisualDensity(
                            horizontal: VisualDensity.minimumDensity,
                            vertical: VisualDensity.minimumDensity),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        value: 'Cash',
                        groupValue: selected,
                        activeColor: HAppColor.hBluePrimaryColor,
                        onChanged: (value) {
                          setState(() {
                            selected = value!;
                          });
                        },
                        title: const Text(
                          "Trả tiền khi nhận hàng",
                          style: HAppStyle.paragraph2Regular,
                        ),
                      ),
                      RadioListTile<String>(
                        activeColor: HAppColor.hBluePrimaryColor,
                        contentPadding: EdgeInsets.zero,
                        visualDensity: const VisualDensity(
                            horizontal: VisualDensity.minimumDensity,
                            vertical: VisualDensity.minimumDensity),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        value: 'Momo',
                        groupValue: selected,
                        onChanged: (value) {
                          setState(() {
                            selected = value!;
                          });
                        },
                        title: const Text(
                          "Ví điện tử Momo",
                          style: HAppStyle.paragraph2Regular,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            gapH24,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Chi tiết đơn hàng",
                      style: HAppStyle.heading4Style,
                    ),
                  ],
                ),
                gapH16,
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          width: 1.5, color: HAppColor.hGreyColorShade300)),
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, top: 20, bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Obx(() => Text(
                                'Tiền hàng (${productController.isInCart.length} sản phẩm)',
                                style: HAppStyle.label2Bold,
                              )),
                          Text(DummyData.vietNamCurrencyFormatting(
                              productController.productMoney.value)),
                        ],
                      ),
                      Divider(
                        color: HAppColor.hGreyColorShade300,
                      ),
                      gapH6,
                      Row(children: [
                        Expanded(
                          child: ProductListStackWidget(
                            maxItems: 8,
                            items: productController.isInCart
                                .map((product) => product.imgPath)
                                .toList(),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: GestureDetector(
                            onTap: () => Get.back(),
                            child: const Icon(Icons.arrow_forward_ios),
                          ),
                        )
                      ]),
                      gapH16,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Phí giao hàng',
                            style: HAppStyle.paragraph2Regular
                                .copyWith(color: HAppColor.hGreyColorShade600),
                          ),
                          const Text('100.000₫'),
                        ],
                      ),
                      gapH10,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Giảm giá phí giao hàng',
                              style: HAppStyle.paragraph2Regular.copyWith(
                                  color: HAppColor.hGreyColorShade600)),
                          const Text('-50.000₫'),
                        ],
                      ),
                      gapH10,
                      Divider(
                        color: HAppColor.hGreyColorShade300,
                      ),
                      gapH4,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Tổng cộng', style: HAppStyle.label2Bold),
                          Text(
                              DummyData.vietNamCurrencyFormatting(
                                  productController.productMoney.value + 50000),
                              style: HAppStyle.label2Bold.copyWith(
                                  color: HAppColor.hBluePrimaryColor)),
                        ],
                      ),
                    ],
                  ),
                ),
                gapH24
              ],
            ),
          ]),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(
            hAppDefaultPadding, 20, hAppDefaultPadding, 16),
        decoration: BoxDecoration(
          color: HAppColor.hBackgroundColor,
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, -15),
              blurRadius: 20,
              color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.1),
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => Get.toNamed(HAppRoutes.voucher),
              child: Row(
                children: [
                  const Icon(
                    Icons.discount_outlined,
                    color: HAppColor.hBluePrimaryColor,
                  ),
                  gapW12,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Áp dụng mã ưu đãi",
                            style: HAppStyle.paragraph1Bold),
                        productController.voucherAppliedTextAppear!.value &&
                                productController.applied.value
                            ? Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Text(
                                  productController.voucherAppliedText.value,
                                  style: HAppStyle.paragraph3Regular.copyWith(
                                    color: HAppColor.hBluePrimaryColor,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  maxLines: 2,
                                ),
                              )
                            : Text("Bạn đang có 2 mã ưu đãi.",
                                style: HAppStyle.paragraph3Regular.copyWith(
                                    color: HAppColor.hRedColor,
                                    decoration: TextDecoration.none)),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                  )
                ],
              ),
            ),
            gapH24,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text.rich(
                  TextSpan(
                    text: "Tổng cộng:\n",
                    children: [
                      TextSpan(
                        text: productController.productMoney.value != 0
                            ? DummyData.vietNamCurrencyFormatting(
                                productController.productMoney.value + 50000)
                            : "0₫",
                        style: HAppStyle.heading4Style
                            .copyWith(color: HAppColor.hBluePrimaryColor),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Get.toNamed(HAppRoutes.complete);
                    orderController.listOder.add(OrderModel(
                        orderId: generateId(6),
                        active: 'Đang chờ',
                        date: dateDeliveryController.date.value,
                        listProduct: productController.isInCart,
                        price: DummyData.vietNamCurrencyFormatting(
                            productController.productMoney.value)));
                    productController.removeAllProductInCart();
                    productController.refreshAllList();
                    productController.addMapProductInCart();
                    productController.productMoney.value = 0;
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(HAppSize.deviceWidth * 0.45, 50),
                    backgroundColor: HAppColor.hBluePrimaryColor,
                  ),
                  child: Text(
                    "Đặt hàng",
                    style: HAppStyle.label2Bold
                        .copyWith(color: HAppColor.hWhiteColor),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AddressCheckoutWidget extends StatelessWidget {
  const AddressCheckoutWidget({
    super.key,
    required this.model,
  });

  final AddressModel model;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          model.name,
          style: HAppStyle.label2Bold,
        ),
        gapH8,
        Row(
          children: [
            gapW8,
            const Icon(
              EvaIcons.phoneOutline,
              size: 20,
            ),
            gapW8,
            Text(model.phoneNumber,
                style: HAppStyle.paragraph2Regular
                    .copyWith(overflow: TextOverflow.ellipsis))
          ],
        ),
        gapH8,
        Row(
          children: [
            gapW6,
            Icon(EvaIcons.homeOutline),
            gapW8,
            Expanded(
              child: Text(
                model.toString(),
                style: HAppStyle.paragraph2Regular,
              ),
            )
          ],
        ),
      ],
    );
  }
}
