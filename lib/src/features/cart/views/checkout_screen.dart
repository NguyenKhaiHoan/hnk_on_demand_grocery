import 'dart:ui';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/cart/views/product_cart.dart';
import 'package:on_demand_grocery/src/features/store/models/store_model.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final listStore1 = bigcstore.take(2).toList();
  final listStore2 = bigcstore.take(1).toList();

  String _selected = 'Tiền mặt';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Thanh toán"),
        centerTitle: true,
        toolbarHeight: 80,
        leading: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: hAppDefaultPadding),
            child: GestureDetector(
                onTap: () => Get.back(),
                child: const Icon(
                  Icons.arrow_back_ios,
                  size: 20,
                )),
          ),
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
                    Text(
                      "Thay đổi địa chỉ",
                      style: HAppStyle.heading4Style,
                    ),
                    Text(
                      "Sửa",
                      style: HAppStyle.paragraph3Regular
                          .copyWith(color: HAppColor.hBluePrimaryColor),
                    ),
                  ],
                ),
                gapH16,
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          width: 1.5, color: HAppColor.hGreyColorShade300)),
                  padding:
                      EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Nơi làm việc",
                        style: HAppStyle.label2Bold,
                      ),
                      gapH4,
                      Row(
                        children: [
                          gapW6,
                          Icon(
                            EvaIcons.phone,
                            size: 20,
                          ),
                          gapW4,
                          Text("+84 388 586 955",
                              style: HAppStyle.paragraph3Regular
                                  .copyWith(overflow: TextOverflow.ellipsis))
                        ],
                      ),
                      gapH4,
                      Row(
                        children: [
                          gapW6,
                          Icon(EvaIcons.pinOutline),
                          gapW4,
                          Text(
                            "Đại học quốc gia Hà nỘi, Cầu Giấy",
                            style: HAppStyle.paragraph3Regular
                                .copyWith(overflow: TextOverflow.ellipsis),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
            gapH24,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Phương thức thanh toán",
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
                  padding:
                      EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Radio<String>(
                            value: 'Cash',
                            groupValue: _selected,
                            onChanged: (value) {
                              setState(() {
                                _selected = value!;
                              });
                            },
                          ),
                          gapW4,
                          Text('Tiền Mặt')
                        ],
                      ),
                      Row(
                        children: [
                          Radio<String>(
                            value: 'MoMo',
                            groupValue: _selected,
                            onChanged: (value) {
                              setState(() {
                                _selected = value!;
                              });
                            },
                          ),
                          gapW4,
                          Text('Ví điện tử MoMo')
                        ],
                      ),
                      Row(
                        children: [
                          Radio<String>(
                            value: 'ApplePay',
                            groupValue: _selected,
                            onChanged: (value) {
                              setState(() {
                                _selected = value!;
                              });
                            },
                          ),
                          gapW4,
                          Text('Apple Pay')
                        ],
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Chi tiết",
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
                  padding:
                      EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Tổng cộng (1 sản phẩm)'),
                          Text('1.500.000₫'),
                        ],
                      ),
                      gapH10,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Phí giao hàng'),
                          Text('50.000₫'),
                        ],
                      ),
                      gapH10,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Tổng cộng: ',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('1.550.000₫',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ]),
        ),
      ),
      // bottomNavigationBar: Container(
      //   color: HAppColor.hBackgroundColor,
      //   padding: EdgeInsets.fromLTRB(hAppDefaultPadding, 5, 24, 10),
      //   child: Column(children: [
      //     Row(
      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //       children: [
      //         Text(
      //           "3 Sản phẩm",
      //           style: HAppStyle.label3Regular,
      //         ),
      //         Row(
      //           children: [
      //             Text("Tiền hàng: ", style: HAppStyle.label3Regular),
      //             gapW6,
      //             Text(
      //               "1.500.000 ₫",
      //               style: HAppStyle.heading4Style,
      //             )
      //           ],
      //         )
      //       ],
      //     ),
      //     ElevatedButton(
      //       child: Text(
      //         "Thanh toán",
      //         style:
      //             HAppStyle.label3Bold.copyWith(color: HAppColor.hWhiteColor),
      //       ),
      //       onPressed: () {},
      //       style: ElevatedButton.styleFrom(
      //         backgroundColor: HAppColor.hBluePrimaryColor,
      //       ),
      //     )
      //   ]),
      // ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(24, 10, 24, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  "Tổng cộng:  ",
                  style: HAppStyle.paragraph3Regular,
                ),
                Text(
                  "1.550.000 ₫",
                  style: HAppStyle.heading5Style,
                )
              ],
            ),
            ElevatedButton(
              child: Text(
                "Đặt hàng",
                style:
                    HAppStyle.label3Bold.copyWith(color: HAppColor.hWhiteColor),
              ),
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: HAppColor.hBluePrimaryColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
