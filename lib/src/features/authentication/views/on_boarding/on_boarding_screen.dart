import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:get/get.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:on_demand_grocery/src/constants/app_assets.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/authentication/controller/on_boarding_controller.dart';
import 'package:on_demand_grocery/src/features/authentication/models/on_boarding_model.dart';
import 'package:on_demand_grocery/src/routes/app_pages.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';

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

  final onboardingController = Get.put(OnboardingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              ClipPath(
                clipper: OvalBottomBorderClipper(),
                child: Container(
                  height: HAppSize.deviceHeight * 0.7,
                  padding: const EdgeInsets.all(0),
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(HAppAsset.onboardingImage),
                          fit: BoxFit.fitWidth)),
                  child: Stack(children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Obx(() => Image.asset(
                            contentsList[onboardingController.currentPage.value]
                                .onboardingModel
                                .image,
                            scale: 1 / 2.3,
                          )),
                    ),
                  ]),
                ),
              ),
              Expanded(
                  child: Container(
                color: HAppColor.hBackgroundColor,
                child: Stack(
                  children: [
                    LiquidSwipe(
                      pages: contentsList,
                      enableSideReveal: true,
                      liquidController: onboardingController.controller,
                      onPageChangeCallback:
                          onboardingController.onPageChangedCallback,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                            hAppDefaultPadding, 0, 0, hAppDefaultPadding),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: List.generate(
                                contentsList.length,
                                (index) => Obx(() => buildDot(index, context)
                                    .animate()
                                    .fade(duration: 1000.ms)),
                              ),
                            ),
                            Obx(() => SizedBox(
                                  height: 60,
                                  child: Stack(
                                    children: [
                                      onboardingController.currentPage.value !=
                                              2
                                          ? !onboardingController
                                                  .loadingArrow.value
                                              ? Padding(
                                                  padding: const EdgeInsets
                                                      .only(
                                                      right:
                                                          hAppDefaultPadding),
                                                  child: Center(
                                                    child: TextButton(
                                                      onPressed: () {
                                                        onboardingController
                                                            .skipPage();
                                                      },
                                                      child: const Text(
                                                        "Bỏ qua",
                                                        style: HAppStyle
                                                            .paragraph2Bold,
                                                        textDirection:
                                                            TextDirection.ltr,
                                                      ).animate().fade(
                                                          duration: 1000.ms),
                                                    ),
                                                  ))
                                              : Container()
                                          : Container(),
                                      AnimatedContainer(
                                        alignment: Alignment.centerRight,
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10),
                                        width: onboardingController
                                            .containerWidth.value,
                                        height: 60,
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(16.0),
                                              bottomLeft:
                                                  Radius.circular(16.0)),
                                          color: HAppColor.hBluePrimaryColor,
                                        ),
                                        duration: const Duration(seconds: 1),
                                        curve: Curves.fastOutSlowIn,
                                        child: onboardingController
                                                    .currentPage.value ==
                                                2
                                            ? GestureDetector(
                                                onTap: () => Get.toNamed(
                                                    HAppRoutes.login),
                                                child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        onboardingController
                                                            .buttonText.value,
                                                        style: HAppStyle
                                                            .label2Bold
                                                            .copyWith(
                                                                color: HAppColor
                                                                    .hWhiteColor),
                                                      ),
                                                      onboardingController
                                                              .loadingArrow
                                                              .value
                                                          ? const Row(
                                                              children: [
                                                                  gapW6,
                                                                  Icon(
                                                                    EvaIcons
                                                                        .arrowRightOutline,
                                                                    color: HAppColor
                                                                        .hWhiteColor,
                                                                  )
                                                                ])
                                                          : Container(),
                                                    ]),
                                              )
                                            : Container(),
                                      )
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ))
            ],
          )
        ],
      ),
    );
  }

  AnimatedContainer buildDot(int index, BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      height: 5,
      width: onboardingController.currentPage.value == index ? 40 : 16,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: onboardingController.currentPage.value == index
            ? HAppColor.hBluePrimaryColor
            : HAppColor.hBlueSecondaryColor,
      ),
    );
  }
}
