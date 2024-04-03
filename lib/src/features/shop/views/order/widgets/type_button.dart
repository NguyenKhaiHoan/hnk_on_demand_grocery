import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/check_out_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/type_button_controller.dart';
import 'package:on_demand_grocery/src/utils/utils.dart';

class TypeButton extends StatelessWidget {
  const TypeButton({
    super.key,
    required this.value,
    required this.title,
    required this.price,
    required this.isFree,
    required this.isOrder,
  });

  final String value;
  final String title;
  final int price;
  final bool isFree;
  final bool isOrder;

  @override
  Widget build(BuildContext context) {
    final typeButtonController = Get.put(TypeButtonController());
    return Obx(
      () => Row(children: [
        Radio(
          value: value,
          groupValue: isOrder
              ? typeButtonController.orderType
              : typeButtonController.paymentMethodType,
          onChanged: (String? valueString) {
            typeButtonController.setType(value, isOrder);
          },
          activeColor: HAppColor.hBluePrimaryColor,
        ),
        gapW10,
        Text(title),
        const Spacer(),
        Text(isFree
            ? '(Miễn phí)'
            : price != -1
                ? '(${isOrder ? '+' : ''}${HAppUtils.vietNamCurrencyFormatting(price)})'
                : '')
      ]),
    );
  }
}

class TypeTimeButton extends StatelessWidget {
  const TypeTimeButton({
    super.key,
    required this.value,
    required this.title,
    required this.price,
    required this.isFree,
  });

  final String value;
  final String title;
  final int price;
  final bool isFree;

  @override
  Widget build(BuildContext context) {
    final typeButtonController = Get.put(TypeButtonController());
    return Obx(() => Row(children: [
          Radio(
            value: value,
            groupValue: typeButtonController.timeType,
            onChanged: (String? valueString) {
              typeButtonController.setTimeType(value);
            },
            activeColor: HAppColor.hBluePrimaryColor,
          ),
          gapW10,
          Text(title),
          const Spacer(),
          Text(isFree
              ? '(Miễn phí)'
              : price != -1
                  ? '(+${HAppUtils.vietNamCurrencyFormatting(price)})'
                  : '')
        ]));
  }
}
