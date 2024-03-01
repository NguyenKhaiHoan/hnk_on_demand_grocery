import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/features/authentication/controller/network_controller.dart';
import 'package:on_demand_grocery/src/repositories/authentication_repository.dart';
import 'package:on_demand_grocery/src/routes/app_pages.dart';
import 'package:on_demand_grocery/src/utils/utils.dart';

class ForgetPasswordController extends GetxController {
  static ForgetPasswordController get instance => Get.find();

  final TextEditingController emailController = TextEditingController();
  GlobalKey<FormState> forgetPasswordFormKey = GlobalKey<FormState>();

  sendEmail() async {
    try {
      HAppUtils.loadingOverlays();

      final isConnected = await NetworkController.instance.isConnected();
      if (!isConnected) {
        HAppUtils.stopLoading();
        return;
      }

      if (!forgetPasswordFormKey.currentState!.validate()) {
        HAppUtils.stopLoading();
        return;
      }

      await AuthenticationRepository.instance
          .sendPassword(emailController.text.trim());

      HAppUtils.stopLoading();

      Get.toNamed(HAppRoutes.sentPassword,
          arguments: {'email': emailController.text.trim()});
    } catch (e) {
      HAppUtils.stopLoading();
      HAppUtils.showSnackBarError('Lỗi', e.toString());
    }
  }

  resendEmail() async {
    try {
      HAppUtils.loadingOverlays();

      final isConnected = await NetworkController.instance.isConnected();
      if (!isConnected) {
        HAppUtils.stopLoading();
        return;
      }

      await AuthenticationRepository.instance
          .sendPassword(emailController.text.trim());

      HAppUtils.stopLoading();

      HAppUtils.showSnackBarSuccess('Đã gửi lại email',
          'Email đã được gửi lại cho bạn, hãy truy cập và đặt lại mật khẩu');
    } catch (e) {
      HAppUtils.stopLoading();
      HAppUtils.showSnackBarError('Lỗi', e.toString());
    }
  }
}
