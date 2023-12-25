import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:on_demand_grocery/src/constants/colors.dart';
import 'package:on_demand_grocery/src/constants/sizes.dart';
import 'package:on_demand_grocery/src/features/authentication/models/on_boarding_model.dart';
import 'package:on_demand_grocery/src/features/authentication/provider/on_boarding_provider.dart';
import 'package:on_demand_grocery/src/features/authentication/views/login/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            LiquidSwipe(
              pages: contentsList,
              enableSideReveal: true,
              liquidController: context.watch<OnboardingProvider>().controller,
              onPageChangeCallback:
                  context.read<OnboardingProvider>().onPageChangedCallback,
              waveType: WaveType.circularReveal,
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: hDefaultSize, bottom: hDefaultSize),
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
                    SizedBox(
                      height: 60,
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: hDefaultSize),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  context.read<OnboardingProvider>().skipPage();
                                },
                                child: const Text(
                                  "Bỏ qua",
                                  style: TextStyle(
                                    color: hDarkColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          AnimatedContainer(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            width: context
                                .watch<OnboardingProvider>()
                                .containerWidth,
                            height: 60,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16.0),
                                  bottomLeft: Radius.circular(16.0)),
                              color: hBluePrimaryColor,
                            ),
                            duration: const Duration(seconds: 1),
                            curve: Curves.fastOutSlowIn,
                            child: context
                                        .read<OnboardingProvider>()
                                        .currentPage ==
                                    2
                                ? GestureDetector(
                                    onTap: () {
                                      storeOnboardingInstance();
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const LoginScreen()));
                                    },
                                    child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            context
                                                .read<OnboardingProvider>()
                                                .buttonText,
                                            style: GoogleFonts.poppins(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.w600,
                                                color: hWhiteColor),
                                          ),
                                          context
                                                      .read<
                                                          OnboardingProvider>()
                                                      .loadingArrow ==
                                                  true
                                              ? const Row(children: [
                                                  SizedBox(
                                                    width: hDefaultSize / 4 - 1,
                                                  ),
                                                  Icon(
                                                    FluentIcons
                                                        .arrow_right_16_filled,
                                                    color: hWhiteColor,
                                                  )
                                                ])
                                              : Container(),
                                        ]),
                                  )
                                : Container(),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> storeOnboardingInstance() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool('isViewed', false);
  }

  AnimatedContainer buildDot(int index, BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      height: 5,
      width: context.read<OnboardingProvider>().currentPage == index ? 40 : 15,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: context.read<OnboardingProvider>().currentPage == index
            ? hBluePrimaryColor
            : hBlueSecondaryColor,
      ),
    );
  }
}
