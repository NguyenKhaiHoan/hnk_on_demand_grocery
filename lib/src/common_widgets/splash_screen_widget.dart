import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class SplashScreenWidget extends StatelessWidget {
  const SplashScreenWidget({super.key, required this.screen});

  final Widget screen;

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splashIconSize: 5000,
      duration: 3000,
      splash: Center(
          child: Image.asset(
        "assets/logos/grofast_splash.gif",
        gaplessPlayback: true,
        fit: BoxFit.fill,
        height: 400,
        width: 400,
      )),
      nextScreen: screen,
      splashTransition: SplashTransition.fadeTransition,
      pageTransitionType: PageTransitionType.fade,
    );
  }
}
