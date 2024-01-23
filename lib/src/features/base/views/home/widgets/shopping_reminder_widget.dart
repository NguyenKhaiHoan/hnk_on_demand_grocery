import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/base/views/home/widgets/product_list_stack.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';

class ShoppingReminderWidget extends StatelessWidget {
  ShoppingReminderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: HAppColor.hWhiteColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(width: 2, color: HAppColor.hBlueSecondaryColor)),
      padding: EdgeInsets.fromLTRB(16, 20, 16, 20),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Tiếp tục mua sắm",
              style: HAppStyle.heading4Style,
            ),
            Icon(
              EvaIcons.closeCircle,
              size: 20,
              color: HAppColor.hGreyColor,
            )
          ],
        ),
        gapH12,
        Text(
          "Giỏ hàng của bạn đang chờ bạn. Bạn còn chần chừ gì nữa? Hãy tiếp tục mua sắm và khám phá những sản phẩm tuyệt vời khác!",
          style: HAppStyle.paragraph3Regular,
        ),
        gapH20,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  EvaIcons.shoppingBag,
                  size: 30,
                ),
                gapW4,
                Text(
                  "Sản phẩm trong giỏ hàng (3)",
                  style: HAppStyle.label3Bold,
                )
              ],
            ),
            Icon(
              EvaIcons.arrowIosForward,
              size: 20,
            )
          ],
        ),
        gapH6,
        ProductListStackWidget(
          maxItems: 8,
          items: [
            'https://images.unsplash.com/photo-1688920556232-321bd176d0b4?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80',
            'https://images.unsplash.com/photo-1689085781839-2e1ff15cb9fe?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80',
            'https://images.unsplash.com/photo-1688920556232-321bd176d0b4?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80',
          ],
        ),
      ]),
    );
  }
}
