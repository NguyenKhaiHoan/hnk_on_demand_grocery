import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/features/personalization/views/change_password/change_password_screen.dart';
import 'package:on_demand_grocery/src/features/authentication/views/forget_password/forget_password_screen.dart';
import 'package:on_demand_grocery/src/features/authentication/views/forget_password/sent_password_screen.dart';
import 'package:on_demand_grocery/src/features/authentication/views/login/login_screen.dart';
import 'package:on_demand_grocery/src/features/authentication/views/on_boarding/on_boarding_screen.dart';
import 'package:on_demand_grocery/src/features/authentication/views/signup/sign_up_screen.dart';
import 'package:on_demand_grocery/src/features/authentication/views/verify/complete_create_account_screen.dart';
import 'package:on_demand_grocery/src/features/authentication/views/verify/verify_screen.dart';
import 'package:on_demand_grocery/src/features/personalization/views/change_name/change_name_screen.dart';
import 'package:on_demand_grocery/src/features/personalization/views/change_phone_number/change_phone_screen.dart';
import 'package:on_demand_grocery/src/features/personalization/views/no_deliver/no_deliver_screen.dart';
import 'package:on_demand_grocery/src/features/personalization/views/profile/profile_detail.dart';
import 'package:on_demand_grocery/src/features/shop/views/chat/chat_screen.dart';
import 'package:on_demand_grocery/src/features/shop/views/delivery_infomation/add_address_screen.dart';
import 'package:on_demand_grocery/src/features/shop/views/delivery_infomation/all_address_screen.dart';
import 'package:on_demand_grocery/src/features/shop/views/delivery_infomation/change_address_screen.dart';
import 'package:on_demand_grocery/src/features/shop/views/delivery_infomation/delivery_infomation_dart.dart';
import 'package:on_demand_grocery/src/features/shop/views/list/widgets/list_item_screen.dart';
import 'package:on_demand_grocery/src/features/shop/views/list/wishlist_screen.dart';
import 'package:on_demand_grocery/src/features/shop/views/live_tracking/live_tracking_screen.dart';
import 'package:on_demand_grocery/src/features/shop/views/order/cart_screen.dart';
import 'package:on_demand_grocery/src/features/shop/views/order/checkout_screen.dart';
import 'package:on_demand_grocery/src/features/shop/views/order/complete_order_screen.dart';
import 'package:on_demand_grocery/src/features/shop/views/order/list_all_order_screen.dart';
import 'package:on_demand_grocery/src/features/shop/views/order/voucher_screen.dart';
import 'package:on_demand_grocery/src/features/shop/views/product/compare_product_screen.dart';
import 'package:on_demand_grocery/src/features/shop/views/product/product_item_detail.dart';
import 'package:on_demand_grocery/src/features/shop/views/review/review_screen.dart';
import 'package:on_demand_grocery/src/features/shop/views/root/root_screen.dart';
import 'package:on_demand_grocery/src/features/shop/views/search/search_one_store_screen.dart';
import 'package:on_demand_grocery/src/features/shop/views/search/search_screen.dart';
import 'package:on_demand_grocery/src/features/shop/views/store/search_product_in_store.dart';
import 'package:on_demand_grocery/src/features/shop/views/store/show_more_product_in_store.dart';
import 'package:on_demand_grocery/src/features/shop/views/store/store_detail_screen.dart';

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
      name: HAppRoutes.completeAccount,
      page: () => const CompleteCreateAccountScreen(),
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
      name: HAppRoutes.productDetail,
      page: () => ProductDetailScreen(),
      transitionDuration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: HAppRoutes.compare,
      page: () => const CompareProductScreen(),
      transitionDuration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: HAppRoutes.storeDetail,
      page: () => const StoreDetailScreen(),
      transitionDuration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: HAppRoutes.complete,
      page: () => const CompleteCheckoutScreen(),
      transitionDuration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: HAppRoutes.wishlist,
      page: () => const WishlistScreen(),
      transitionDuration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      transition: Transition.downToUp,
    ),
    GetPage(
      name: HAppRoutes.wishlistItem,
      page: () => const WishlistItemScreen(),
      transitionDuration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: HAppRoutes.chat,
      page: () => const ChatScreen(),
      transitionDuration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: HAppRoutes.searchOnStore,
      page: () => const SearchOneStoreScreen(),
      transitionDuration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: HAppRoutes.signup,
      page: () => const SignUpScreen(),
      transitionDuration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: HAppRoutes.review,
      page: () => const ReviewScreen(),
      transitionDuration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: HAppRoutes.deliveryInfomation,
      page: () => const DeliveryInfomationScreen(),
      transitionDuration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: HAppRoutes.listOrder,
      page: () => ListAllOrderScreen(),
      transitionDuration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: HAppRoutes.forgetPassword,
      page: () => const ForgetPasswordScreen(),
      transitionDuration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: HAppRoutes.sentPassword,
      page: () => const SentPasswordScreen(),
      transitionDuration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: HAppRoutes.profileDetail,
      page: () => const ProfileDetailScreen(),
      transitionDuration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: HAppRoutes.changePassword,
      page: () => const ChangePasswordScreen(),
      transitionDuration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: HAppRoutes.changeName,
      page: () => const ChangeNameScreen(),
      transitionDuration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: HAppRoutes.changePhone,
      page: () => const ChangePhoneScreen(),
      transitionDuration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: HAppRoutes.addAddress,
      page: () => const AddAddressScreen(),
      transitionDuration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: HAppRoutes.changeAddress,
      page: () => const ChangeAddressScreen(),
      transitionDuration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: HAppRoutes.allAddress,
      page: () => const AllAddressScreen(),
      transitionDuration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: HAppRoutes.liveTracking,
      page: () => const LiveTrackingScreen(),
      transitionDuration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: HAppRoutes.noDeliver,
      page: () => const NoDeliverScreen(),
      transitionDuration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      transition: Transition.fadeIn,
    ),
    // GetPage(
    //   name: HAppRoutes.selectDeliveryAddress,
    //   page: () => const SelectDeliveryAddressScreen(),
    //   transitionDuration: const Duration(milliseconds: 500),
    //   curve: Curves.easeOut,
    //   transition: Transition.fadeIn,
    // ),
    GetPage(
      name: HAppRoutes.showMoreProductInStore,
      page: () => const ShowMoreProductInStore(),
      transitionDuration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: HAppRoutes.searchProductInStore,
      page: () => const SearchProductInStore(),
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
  static const completeAccount = '/completeAccount';
  static const cart = '/cart';
  static const checkout = '/checkout';
  static const compare = '/compare';
  static const productDetail = '/productDetail';
  static const voucher = '/voucher';
  static const storeDetail = '/storeDetail';
  static const complete = '/complete';
  static const wishlist = '/wishlist';
  static const wishlistItem = '/wishlistItem';
  static const chat = '/chat';
  static const searchOnStore = '/searchOnStore';
  static const signup = '/signup';
  static const review = '/review';
  static const deliveryInfomation = '/deliveryInfomation';
  static const listOrder = '/listOrder';
  static const forgetPassword = '/forgetPassword';
  static const sentPassword = '/sentPassword';
  static const profileDetail = '/profileDetail';
  static const changePassword = '/changePassword';
  static const changeName = '/changeName';
  static const addAddress = '/addAddress';
  static const allAddress = '/allAddress';
  static const changePhone = '/changePhone';
  static const liveTracking = '/liveTracking';
  static const noDeliver = '/noDeliver';
  static const selectDeliveryAddress = '/selectDeliveryAddress';
  static const changeAddress = '/changeAddress';
  static const showMoreProductInStore = '/showMoreProductInStore';
  static const searchProductInStore = '/searchProductInStore';
}
