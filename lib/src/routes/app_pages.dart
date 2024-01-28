import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/features/authentication/views/login/login_screen.dart';
import 'package:on_demand_grocery/src/features/authentication/views/on_boarding/on_boarding_screen.dart';
import 'package:on_demand_grocery/src/features/authentication/views/verify/verify_screen.dart';
import 'package:on_demand_grocery/src/features/shop/views/order/cart_screen.dart';
import 'package:on_demand_grocery/src/features/shop/views/order/checkout_screen.dart';
import 'package:on_demand_grocery/src/features/shop/views/order/voucher_screen.dart';
import 'package:on_demand_grocery/src/features/shop/views/product/product_item_detail.dart';
import 'package:on_demand_grocery/src/features/shop/views/root/root_screen.dart';
import 'package:on_demand_grocery/src/features/shop/views/search/search_screen.dart';

abstract class HAppPages {
  static final pages = [
    GetPage(
      name: HAppRoutes.onboarding,
      page: () => OnboardingScreen(),
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
    GetPage(
      name: HAppRoutes.voucher,
      page: () => const VoucherScreen(),
      transitionDuration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: HAppRoutes.detail,
      page: () => ProductDetailScreen(),
      transitionDuration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      transition: Transition.fadeIn,
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
  static const voucher = '/voucher';
  static const detail = '/detail';
}
