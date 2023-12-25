import 'package:flutter/material.dart';
import 'package:on_demand_grocery/src/constants/colors.dart';
import 'package:on_demand_grocery/src/constants/text_strings.dart';
import 'package:on_demand_grocery/src/features/authentication/views/on_boarding_screen/widgets/on_boarding_page_widget.dart';

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
    title: hOnboardingTitle1,
    image: 'assets/images/on_boarding_screen/on_boarding_1.png',
    discription: hOnboardingDiscription1,
    backgroundColor: hWhiteColor,
  )),
  OnboardingPageWidget(
      onboardingModel: OnboardingModel(
    title: hOnboardingTitle2,
    image: 'assets/images/on_boarding_screen/on_boarding_2.png',
    discription: hOnboardingDiscription2,
    backgroundColor: hWhiteColor,
  )),
  OnboardingPageWidget(
      onboardingModel: OnboardingModel(
          title: hOnboardingTitle3,
          image: 'assets/images/on_boarding_screen/on_boarding_3.png',
          discription: hOnboardingDiscription3,
          backgroundColor: hWhiteColor)),
];
