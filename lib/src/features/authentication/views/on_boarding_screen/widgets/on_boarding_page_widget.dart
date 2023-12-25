import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:on_demand_grocery/src/constants/colors.dart';
import 'package:on_demand_grocery/src/constants/sizes.dart';
import 'package:on_demand_grocery/src/features/authentication/models/on_boarding_model.dart';

class OnboardingPageWidget extends StatelessWidget {
  const OnboardingPageWidget({super.key, required this.onboardingModel});

  final OnboardingModel onboardingModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: onboardingModel.backgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, bottom: 40),
                child: Image.asset(
                  onboardingModel.image,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        onboardingModel.title,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            fontSize: 24.0,
                            fontWeight: FontWeight.w600,
                            color: hDarkColor),
                      ),
                      const SizedBox(height: hDefaultSize / 2),
                      Text(
                        onboardingModel.discription,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            fontSize: 14.0,
                            fontWeight: FontWeight.normal,
                            color: hDarkColor),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
