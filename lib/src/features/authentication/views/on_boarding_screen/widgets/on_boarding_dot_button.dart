import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:on_demand_grocery/src/constants/colors.dart';
import 'package:on_demand_grocery/src/constants/image_strings.dart';
import 'package:on_demand_grocery/src/constants/sizes.dart';
import 'package:on_demand_grocery/src/features/authentication/models/on_boarding_model.dart';
import 'package:on_demand_grocery/src/features/authentication/views/login/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingDotAndButton extends StatefulWidget {
  int currentIndex;
  OnboardingDotAndButton({super.key, required this.currentIndex});

  @override
  State<OnboardingDotAndButton> createState() => _OnboardingDotAndButtonState();
}

class _OnboardingDotAndButtonState extends State<OnboardingDotAndButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: hDefaultSize),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: List.generate(
              contentsList.length,
              (index) => buildDot(index, context),
            ),
          ),
          Container(
              padding:
                  const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
              width: 130,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    bottomLeft: Radius.circular(16.0)),
                color: hGreenPrimaryColor,
              ),
              child: TextButton(
                onPressed: () async {
                  if (widget.currentIndex == contentsList.length - 1) {
                    await _storeOnboardInfo();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  }
                },
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.currentIndex == contentsList.length - 1
                            ? "Bắt đầu"
                            : "Kế tiếp",
                        style: GoogleFonts.poppins(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            color: hWhiteColor),
                      ),
                      const SizedBox(
                        width: hDefaultSize / 4 - 1,
                      ),
                      const Icon(
                        FluentIcons.arrow_right_16_filled,
                        color: hWhiteColor,
                      ),
                    ]),
              )),
        ],
      ),
    );
  }

  AnimatedContainer buildDot(int index, BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      height: 5,
      width: widget.currentIndex == index ? 40 : 15,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: widget.currentIndex == index
            ? hGreenPrimaryColor
            : hGreenSecondaryColor,
      ),
    );
  }

  _storeOnboardInfo() async {
    int isViewed = 0;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('onBoard', isViewed);
  }
}
