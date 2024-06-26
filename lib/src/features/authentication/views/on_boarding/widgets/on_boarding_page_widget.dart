import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/authentication/models/on_boarding_model.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';

class OnboardingPageWidget extends StatelessWidget {
  const OnboardingPageWidget({super.key, required this.onboardingModel});

  final OnboardingModel onboardingModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: onboardingModel.backgroundColor,
      padding: const EdgeInsets.fromLTRB(
          hAppDefaultPadding, 40, hAppDefaultPadding, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            onboardingModel.title,
            style: HAppStyle.heading3Style,
          ).animate().fade(duration: 1000.ms).slideY(curve: Curves.easeOut),
          gapH12,
          Text(
            onboardingModel.discription,
            style: HAppStyle.paragraph1Regular
                .copyWith(color: HAppColor.hGreyColorShade600),
          ),
        ],
      ),
    );
  }
}
