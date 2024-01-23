import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/common_widgets/cart_cirle_widget.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/product/models/product_models.dart';

class ProductItemScreen extends StatelessWidget {
  const ProductItemScreen({super.key, required this.model});

  final ProductItem model;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            child: Image.network(model.imgPath,
                height: HAppSize.deviceHeight * 0.5, fit: BoxFit.fitHeight),
          ),
          AppBar(
            forceMaterialTransparency: true,
            backgroundColor: HAppColor.hTransparentColor,
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
            actions: const [
              Padding(
                padding: hAppDefaultPaddingR,
                child: CartCircle(),
              )
            ],
          ),
          scroll(),
        ],
      ),
    ));
  }

  scroll() {
    return DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 1.0 - 80 / HAppSize.deviceHeight,
        minChildSize: 0.6,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            clipBehavior: Clip.hardEdge,
            decoration: const BoxDecoration(
              color: HAppColor.hBackgroundColor,
              borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20)),
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [],
              ),
            ),
          );
        });
  }
}
