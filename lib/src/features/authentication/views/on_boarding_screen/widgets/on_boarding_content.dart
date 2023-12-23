// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:on_demand_grocery/src/constants/colors.dart';

import 'package:on_demand_grocery/src/constants/sizes.dart';

import '../../../models/on_boarding_model.dart';

class OnboardingContent extends StatefulWidget {
  int currentIndex;

  OnboardingContent({
    Key? key,
    required this.currentIndex,
  }) : super(key: key);

  @override
  State<OnboardingContent> createState() => _OnboardingContentState();
}

class _OnboardingContentState extends State<OnboardingContent> {
  PageController? _controller;
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
    return Stack(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: TextButton(
            onPressed: () {},
            child: const Text(
              "Bỏ qua",
              style: TextStyle(
                color: hGreyColor,
              ),
            ),
          ),
        ),
        PageView.builder(
          controller: _controller,
          itemCount: contentsList.length,
          onPageChanged: (int index) {
            if (index >= widget.currentIndex) {
              setState(() {
                widget.currentIndex = index;
              });
            }
          },
          itemBuilder: (context, index) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(
                  height: hDefaultSize * 4,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset(
                    contentsList[index].image,
                    scale: 0.1,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        contentsList[index].title,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            fontSize: 24.0,
                            fontWeight: FontWeight.w600,
                            color: hDarkColor),
                      ),
                      const SizedBox(height: hDefaultSize / 2),
                      Text(
                        contentsList[index].discription,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            fontSize: 14.0,
                            fontWeight: FontWeight.normal,
                            color: hDarkColor),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        )
      ],
    );
  }
}
