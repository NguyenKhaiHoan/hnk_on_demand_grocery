import 'package:enefty_icons/enefty_icons.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';
import 'package:toastification/toastification.dart';

class HAppUtils {
  // static String formatTimeAgo(DateTime dateTime) {
  //   final Duration difference = DateTime.now().difference(dateTime);
  //   if (difference.inDays > 0) {
  //     return '${difference.inDays} ngày trước';
  //   } else if (difference.inHours > 0) {
  //     return '${difference.inHours} giờ trước';
  //   } else if (difference.inMinutes > 0) {
  //     return '${difference.inMinutes} phút trước';
  //   } else {
  //     return 'Ngay bây giờ';
  //   }
  // }

  static int roundValue(int value) {
    int lastThreeDigits = value % 1000;
    if (lastThreeDigits >= 500) {
      return value + (1000 - lastThreeDigits);
    } else {
      return value - lastThreeDigits;
    }
  }

  static String maskName(String name) {
    if (name.length <= 1) {
      return name;
    }
    String firstChar = name[0];
    String maskedChars = '*' * (name.length - 1);
    return '$firstChar$maskedChars';
  }

  static String getTitlePaymentMethod(String value) {
    switch (value) {
      case 'tien_mat':
        return 'Tiền mặt';
      case 'momo_vn':
        return 'Ví điện tử MoMo';
      case 'tin_dung':
        return 'Thanh toán bằng thẻ';
      default:
        return 'Không biết';
    }
  }

  static orderStatus(int status) {
    switch (status) {
      case 0:
        return 'Đơn đặt hàng thành công';
      case 1:
        return 'Cửa hàng tạp hóa xác nhận';
      case 2:
        return 'Người giao hàng xác nhận';
      case 3:
        return 'Người giao hàng đã lấy hàng';
      case 4:
        return 'Đơn giao tới nơi';
    }
  }

  static String vietNamCurrencyFormatting(int amount) {
    return '${amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (match) => '${match[1]}.')}₫';
  }

  static String metersToKilometers(double distanceInMeters) {
    double distanceInKilometers = distanceInMeters / 1000;
    return distanceInKilometers.toStringAsFixed(2);
  }

  static void showLostMobileDataConnection(String title, String message) {
    Get.snackbar(
      title,
      message,
      icon: const Icon(EvaIcons.wifiOffOutline, color: Colors.white),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: HAppColor.hRedColor.shade400,
      borderRadius: 10,
      margin: const EdgeInsets.all(hAppDefaultPadding),
      colorText: Colors.white,
      duration: const Duration(days: 1),
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutBack,
    );
  }

  static void showConnectedToMobileData(String title, String message) {
    Get.snackbar(
      title,
      message,
      icon: const Icon(EvaIcons.wifi, color: Colors.white),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: HAppColor.hBluePrimaryColor,
      borderRadius: 10,
      margin: const EdgeInsets.all(hAppDefaultPadding),
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutBack,
    );
  }

  static void showSnackBarSuccess(String title, String message) {
    Get.snackbar(
      title,
      message,
      icon: const Icon(EneftyIcons.check_outline, color: Colors.white),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: HAppColor.hBluePrimaryColor,
      borderRadius: 10,
      margin: const EdgeInsets.all(hAppDefaultPadding),
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutBack,
    );
  }

  static void showSnackBarWarning(String title, String message) {
    Get.snackbar(
      title,
      message,
      icon: const Icon(EneftyIcons.warning_2_outline, color: Colors.white),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: HAppColor.hOrangeColor,
      borderRadius: 10,
      margin: const EdgeInsets.all(hAppDefaultPadding),
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutBack,
    );
  }

  static void showSnackBarError(String title, String message) {
    Get.snackbar(
      title,
      message,
      icon: const Icon(EneftyIcons.warning_2_outline, color: Colors.white),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: HAppColor.hRedColor.shade400,
      borderRadius: 10,
      margin: const EdgeInsets.all(hAppDefaultPadding),
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutBack,
    );
  }

  static void showToastSuccess(Widget title, Widget description, int seconds,
      BuildContext context, ToastificationCallbacks callbacks) {
    toastification.show(
      callbacks: callbacks,
      progressBarTheme:
          const ProgressIndicatorThemeData(color: HAppColor.hBluePrimaryColor),
      context: context,
      type: ToastificationType.success,
      style: ToastificationStyle.flat,
      autoCloseDuration: Duration(seconds: seconds),
      title: title,
      description: description,
      alignment: Alignment.topCenter,
      animationDuration: const Duration(milliseconds: 300),
      animationBuilder: (context, animation, alignment, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      icon: const Icon(
        Icons.check,
        color: HAppColor.hBluePrimaryColor,
      ),
      backgroundColor: HAppColor.hBackgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(
          color: Color(0x07000000),
          blurRadius: 16,
          offset: Offset(0, 16),
          spreadRadius: 0,
        )
      ],
      showProgressBar: true,
      closeButtonShowType: CloseButtonShowType.onHover,
      closeOnClick: false,
      pauseOnHover: true,
      dragToClose: true,
    );
  }

  static void showToastError(Widget title, Widget description, int seconds,
      BuildContext context, ToastificationCallbacks callbacks) {
    toastification.show(
      callbacks: callbacks,
      progressBarTheme:
          const ProgressIndicatorThemeData(color: HAppColor.hRedColor),
      context: context,
      type: ToastificationType.success,
      style: ToastificationStyle.flat,
      autoCloseDuration: Duration(seconds: seconds),
      title: title,
      description: description,
      alignment: Alignment.topCenter,
      animationDuration: const Duration(milliseconds: 300),
      animationBuilder: (context, animation, alignment, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      icon: const Icon(
        Icons.close,
        color: HAppColor.hRedColor,
      ),
      backgroundColor: HAppColor.hBackgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(
          color: Color(0x07000000),
          blurRadius: 16,
          offset: Offset(0, 16),
          spreadRadius: 0,
        )
      ],
      showProgressBar: true,
      closeButtonShowType: CloseButtonShowType.onHover,
      closeOnClick: false,
      pauseOnHover: true,
      dragToClose: true,
    );
  }

  static String? validateEmptyField(String? fieldName, String? value) {
    if (value == null || value.isEmpty) {
      return '$fieldName chưa được điền.';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    validateEmptyField('Email', value);

    final emailRegExp = RegExp(r'^[\w\-\.]+@([\w-]+\.)+[\w-]{2,}$');

    if (!emailRegExp.hasMatch(value!)) {
      return 'Email không hợp lệ';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    validateEmptyField('Mật khẩu', value);

    if (value!.length < 8) {
      return 'Mật khẩu phải có ít nhất 8 ký tự';
    }

    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Mật khẩu phải có ít nhất 1 ký tự số.';
    }

    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Mật khẩu phải có ít nhất 1 ký tự in hoa.';
    }

    if (!value.contains(RegExp(r'[@%/\+!#$^)(~_ ,.?]'))) {
      return 'Mật khẩu phải có ít nhất 1 ký tự đặc biệt.';
    }
    return null;
  }

  static String? validateCorrectPassword(String? value, String password) {
    validatePassword(value);
    if (value != password) {
      return 'Mật khẩu không khớp nhau.';
    }
    return null;
  }

  static String? validatePhoneNumber(String? value) {
    validateEmptyField('Số điện thoại', value);

    final phoneNumberRegExp = RegExp(
        r'^(0|84)(2(0[3-9]|1[0-6|8|9]|2[0-2|5-9]|3[2-9]|4[0-9]|5[1|2|4-9]|6[0-3|9]|7[0-7]|8[0-9]|9[0-4|6|7|9])|3[2-9]|5[5|6|8|9]|7[0|6-9]|8[0-6|8|9]|9[0-4|6-9])([0-9]{7})$');

    if (!phoneNumberRegExp.hasMatch(value!)) {
      return 'Số điện thoại không hợp lệ.';
    }
    return null;
  }

  static void loadingOverlaysAddress() {
    showDialog(
        context: Get.overlayContext!,
        barrierDismissible: false,
        builder: (_) => PopScope(
              canPop: false,
              child: Container(
                color: HAppColor.hBackgroundColor,
                width: HAppSize.deviceWidth,
                height: HAppSize.deviceHeight,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Lottie.asset(
                          'assets/animations/loading_address_animation.json',
                          height: 200,
                          width: 200,
                          fit: BoxFit.cover),
                      gapH20,
                      Text(
                        'Đang tìm vị trí ...',
                        style: HAppStyle.paragraph2Bold
                            .copyWith(color: HAppColor.hGreyColorShade600),
                      )
                    ]),
              ),
            ));
  }

  static void loadingOverlays() {
    showDialog(
        context: Get.overlayContext!,
        barrierDismissible: false,
        builder: (_) => PopScope(
              canPop: false,
              child: Container(
                color: HAppColor.hWhiteColor,
                height: HAppSize.deviceHeight,
                width: HAppSize.deviceWidth,
                alignment: Alignment.center,
                child: Lottie.asset('assets/animations/loading_animation.json',
                    height: 80, width: 80, fit: BoxFit.cover),
              ),
            ));
  }

  static void stopLoading() {
    Navigator.of(Get.overlayContext!).pop();
  }
}
