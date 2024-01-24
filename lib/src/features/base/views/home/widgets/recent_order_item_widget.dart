import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/base/models/recent_oder_model.dart';
import 'package:on_demand_grocery/src/features/base/views/home/widgets/product_list_stack.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';

class RecentOrderItemWidget extends StatelessWidget {
  final Function() onTap;

  final RecentOrderModel model;

  const RecentOrderItemWidget({
    super.key,
    required this.onTap,
    required this.model,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 250,
        decoration: BoxDecoration(
          color: HAppColor.hWhiteColor,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                  decoration: BoxDecoration(
                    color: model.active == "Hoàn thành"
                        ? HAppColor.hBluePrimaryColor
                        : model.active == "Đang giao"
                            ? HAppColor.hOrangeColor
                            : HAppColor.hRedColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(model.active,
                      style: HAppStyle.label4Regular
                          .copyWith(color: HAppColor.hWhiteColor))),
              GestureDetector(
                onTap: () {},
                child: model.active == "Đang giao"
                    ? Row(
                        children: [
                          Icon(
                            EvaIcons.eyeOutline,
                            size: 20,
                            color: HAppColor.hBluePrimaryColor,
                          ),
                          gapW4,
                          Text(
                            "Theo dõi",
                            style: HAppStyle.label3Bold
                                .copyWith(color: HAppColor.hBluePrimaryColor),
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Icon(
                            EvaIcons.refreshOutline,
                            size: 20,
                            color: HAppColor.hBluePrimaryColor,
                          ),
                          gapW4,
                          Text(
                            "Đặt lại",
                            style: HAppStyle.label3Bold
                                .copyWith(color: HAppColor.hBluePrimaryColor),
                          ),
                        ],
                      ),
              )
            ],
          ),
          gapH12,
          Text(
            "Id - ${model.id}",
            style: HAppStyle.heading4Style,
          ),
          Row(
            children: [
              Text(
                model.date,
                style: HAppStyle.paragraph3Regular
                    .copyWith(color: HAppColor.hGreyColor),
              ),
              model.receivedTime == ""
                  ? Container()
                  : Row(
                      children: [
                        gapW4,
                        Text("|",
                            style: HAppStyle.paragraph3Regular
                                .copyWith(color: HAppColor.hGreyColor)),
                        gapW4,
                        Text(
                          model.receivedTime,
                          style: HAppStyle.paragraph3Regular
                              .copyWith(color: HAppColor.hGreyColor),
                        ),
                      ],
                    )
            ],
          ),
          gapH6,
          ProductListStackWidget(
            maxItems: 5,
            items: model.listProduct,
          ),
          Expanded(
              child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Tổng cộng: ",
                style: HAppStyle.paragraph1Bold,
              ),
              Text(
                model.price,
                style: HAppStyle.heading5Style
                    .copyWith(color: HAppColor.hBluePrimaryColor),
              )
            ],
          ))
        ]),
      ),
    );
  }
}
