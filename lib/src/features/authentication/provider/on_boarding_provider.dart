import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:liquid_swipe/PageHelpers/LiquidController.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingProvider with ChangeNotifier {
  final controller = LiquidController();

  bool? isViewed;
  bool? isLoading;

  String buttonText = "";
  bool loadingArrow = false;

  double containerWidth = 0;

  late final SharedPreferences prefs;

  OnboardingProvider() {
    checkIsViewed();
    notifyListeners();
  }

  checkIsViewed() async {
    isLoading = true;
    notifyListeners();
    prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('isViewed') ?? true) {
      isViewed = true;
    } else {
      isViewed = false;
    }
    isLoading = false;
    notifyListeners();
  }

  int currentPage = 0;

  int get page => currentPage;

  void skipPage() {
    controller.jumpToPage(page: 2);
    notifyListeners();
  }

  void onPageChangedCallback(int activePageIndex) {
    currentPage = activePageIndex;
    if (activePageIndex == 2) {
      containerWidth = 135;
      Timer(const Duration(milliseconds: 1100), () {
        buttonText = "Bắt đầu";
        notifyListeners();
      });
      Timer(const Duration(milliseconds: 1100), () {
        loadingArrow = true;
        notifyListeners();
      });
    } else {
      containerWidth = 0;
      buttonText = "";
      loadingArrow = false;
    }
    notifyListeners();
  }
}
