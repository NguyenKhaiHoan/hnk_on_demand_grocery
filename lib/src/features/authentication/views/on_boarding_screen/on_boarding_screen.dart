import 'package:flutter/material.dart';
import 'package:on_demand_grocery/src/features/authentication/views/on_boarding_screen/widgets/on_boarding_content.dart';
import 'package:on_demand_grocery/src/features/authentication/views/on_boarding_screen/widgets/on_boarding_dot_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  PageController? _controller;
  int currentIndex = 0;
  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: OnboardingContent(currentIndex: currentIndex),
            ),
            Expanded(
              child: OnboardingDotAndButton(currentIndex: currentIndex),
            ),
          ],
        ),
      ),
    );
  }
}
