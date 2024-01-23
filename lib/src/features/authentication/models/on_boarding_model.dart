import 'package:flutter/material.dart';
import 'package:on_demand_grocery/src/constants/app_assets.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_titles.dart';
import 'package:on_demand_grocery/src/features/authentication/views/on_boarding/widgets/on_boarding_page_widget.dart';

class OnboardingModel {
  String image;
  String title;
  String discription;
  Color backgroundColor;

  OnboardingModel({
    required this.image,
    required this.title,
    required this.discription,
    required this.backgroundColor,
  });
}

final contentsList = [
  OnboardingPageWidget(
      onboardingModel: OnboardingModel(
    title: HAppText.hOnboarding1Title,
    image: HAppAsset.onboarding1Image,
    discription: HAppText.hOnboarding1Discription,
    backgroundColor: HAppColor.hBackgroundColor,
  )),
  OnboardingPageWidget(
      onboardingModel: OnboardingModel(
    title: HAppText.hOnboarding2Title,
    image: HAppAsset.onboarding2Image,
    discription: HAppText.hOnboarding2Discription,
    backgroundColor: HAppColor.hBackgroundColor,
  )),
  OnboardingPageWidget(
      onboardingModel: OnboardingModel(
    title: HAppText.hOnboarding3Title,
    image: HAppAsset.onboarding3Image,
    discription: HAppText.hOnboarding3Discription,
    backgroundColor: HAppColor.hBackgroundColor,
  )),
];
