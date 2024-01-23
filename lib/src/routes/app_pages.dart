import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/features/authentication/views/login/login_screen.dart';
import 'package:on_demand_grocery/src/features/authentication/views/on_boarding/on_boarding_screen.dart';
import 'package:on_demand_grocery/src/features/authentication/views/verify/verify_screen.dart';
import 'package:on_demand_grocery/src/features/base/views/root/root_screen.dart';
import 'package:on_demand_grocery/src/features/cart/views/cart_screen.dart';
import 'package:on_demand_grocery/src/features/cart/views/checkout_screen.dart';
import 'package:on_demand_grocery/src/features/search/view/search_screen.dart';

abstract class HAppPages {
  static final pages = [
    GetPage(
      name: HAppRoutes.onboarding,
      page: () => const OnboardingScreen(),
      transitionDuration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: HAppRoutes.login,
      page: () => const LoginScreen(),
      transitionDuration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: HAppRoutes.root,
      page: () => const RootScreen(),
      transitionDuration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: HAppRoutes.search,
      page: () => const SearchScreen(),
      transitionDuration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: HAppRoutes.verify,
      page: () => const VerifyScreen(),
      transitionDuration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: HAppRoutes.cart,
      page: () => const CartScreen(),
      transitionDuration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: HAppRoutes.checkout,
      page: () => const CheckoutScreen(),
      transitionDuration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      transition: Transition.rightToLeftWithFade,
    ),
  ];
}

abstract class HAppRoutes {
  static const onboarding = '/onboarding';
  static const root = '/root';
  static const search = '/search';
  static const login = '/login';
  static const verify = '/verify';
  static const cart = '/cart';
  static const checkout = '/checkout';
}
