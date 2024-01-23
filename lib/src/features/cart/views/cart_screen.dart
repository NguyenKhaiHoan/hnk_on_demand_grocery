import 'dart:ui';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/cart/views/product_cart.dart';
import 'package:on_demand_grocery/src/features/store/models/store_model.dart';
import 'package:on_demand_grocery/src/routes/app_pages.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _checkbox = true;
  bool _checkbox2 = true;

  final listStore1 = bigcstore.take(2).toList();
  final listStore2 = bigcstore.take(1).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Giỏ hàng"),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                              image: NetworkImage(listStore[0].imgStore),
                              fit: BoxFit.fill)),
                    ),
                    gapW12,
                    Text(
                      listStore[0].name + ' (2 sản phẩm)',
                      style: HAppStyle.label2Bold,
                    )
                  ],
                ),
                Checkbox(
                  activeColor: HAppColor.hBluePrimaryColor,
                  value: _checkbox,
                  onChanged: (value) {
                    setState(() {
                      _checkbox = !_checkbox;
                    });
                  },
                ),
              ],
            ),
            gapH12,
            ProductCartWidget(
              model: listStore1[0],
            ),
            gapH12,
            ProductCartWidget(
              model: listStore1[1],
            ),
            gapH12,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                              image: NetworkImage(listStore[1].imgStore),
                              fit: BoxFit.fill)),
                    ),
                    gapW12,
                    Text(
                      listStore[1].name + ' (2 sản phẩm)',
                      style: HAppStyle.label2Bold,
                    )
                  ],
                ),
                Checkbox(
                  activeColor: HAppColor.hBluePrimaryColor,
                  value: _checkbox2,
                  onChanged: (value) {
                    setState(() {
                      _checkbox2 = !_checkbox2;
                    });
                  },
                ),
              ],
            ),
            gapH12,
            ProductCartWidget(
              model: listStore2[0],
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
                      "Mã khuyến mãi",
                      style: HAppStyle.heading4Style,
                    ),
                    Text(
                      "Xem tất cả",
                      style: HAppStyle.paragraph3Regular
                          .copyWith(color: HAppColor.hBluePrimaryColor),
                    ),
                  ],
                ),
                gapH4,
                Text("Nhập hoặc áp dụng mã khuyến mãi khác"),
              ],
            ),
            gapH24,
            TextField(
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                hintStyle: HAppStyle.paragraph2Bold
                    .copyWith(color: HAppColor.hGreyColor),
                isCollapsed: true,
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(
                        width: 2, color: HAppColor.hBluePrimaryColor)),
                contentPadding: const EdgeInsets.all(9),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(
                        width: 0.8, color: HAppColor.hGreyColor)),
                hintText: "Nhập khuyến mãi",
                suffixIcon: Padding(
                  padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                  child: Container(
                    width: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: HAppColor.hBluePrimaryColor,
                    ),
                    child: Center(
                        child: Text(
                      "Áp dụng",
                      style: HAppStyle.label3Bold
                          .copyWith(color: HAppColor.hWhiteColor),
                    )),
                  ),
                ),
              ),
            ),
            gapH24,
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
                  "1.500.000 ₫",
                  style: HAppStyle.heading5Style,
                )
              ],
            ),
            ElevatedButton(
              child: Text(
                "Thanh toán",
                style:
                    HAppStyle.label3Bold.copyWith(color: HAppColor.hWhiteColor),
              ),
              onPressed: () => Get.toNamed(HAppRoutes.checkout),
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
