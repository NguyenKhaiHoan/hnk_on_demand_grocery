import 'package:flutter/material.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/shop/models/chat_message_model.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';

class TextMessage extends StatelessWidget {
  const TextMessage({
    super.key,
    this.message,
  });

  final ChatMessage? message;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: HAppSize.deviceWidth * 0.6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: message!.isSender
            ? HAppColor.hBluePrimaryColor
            : HAppColor.hGreyColor.shade300,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        message!.text,
        style: HAppStyle.paragraph2Regular.copyWith(
            color: message!.isSender
                ? HAppColor.hWhiteColor
                : HAppColor.hDarkColor),
      ),
    );
  }
}
