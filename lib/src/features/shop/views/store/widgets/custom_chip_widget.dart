import 'package:flutter/material.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';

class CustomChipWidget extends StatelessWidget {
  final String title;
  final bool active;
  final Function() onTap;

  const CustomChipWidget(
      {super.key,
      required this.title,
      required this.active,
      required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Text(title, style: HAppStyle.label3Regular)),
    );
  }
}
