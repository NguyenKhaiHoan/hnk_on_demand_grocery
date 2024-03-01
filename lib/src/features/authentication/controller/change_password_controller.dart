import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/features/authentication/controller/network_controller.dart';
import 'package:on_demand_grocery/src/features/personalization/controllers/user_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/root_controller.dart';
import 'package:on_demand_grocery/src/repositories/authentication_repository.dart';
import 'package:on_demand_grocery/src/routes/app_pages.dart';
import 'package:on_demand_grocery/src/utils/utils.dart';

class ChangePasswordController extends GetxController {
  static ChangePasswordController get instance => Get.find();

  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController correctPasswordController =
      TextEditingController();

  GlobalKey<FormState> changePasswordFormKey = GlobalKey<FormState>();

  var isHideOldPassword = false.obs;
  var isHideNewPassword = false.obs;
  var isHideCorrectPassword = false.obs;

  final userController = UserController.instance;

  changePassword() async {
    try {
      HAppUtils.loadingOverlays();

      final isConnected = await NetworkController.instance.isConnected();
      if (!isConnected) {
        HAppUtils.stopLoading();
        return;
      }

      if (!changePasswordFormKey.currentState!.validate()) {
        HAppUtils.stopLoading();
        return;
      }

      await AuthenticationRepository.instance
          .changePasswordWithEmailAndPassword(
              userController.user.value.email,
              oldPasswordController.text.trim(),
              newPasswordController.text.trim());

      HAppUtils.stopLoading();
      HAppUtils.showSnackBarSuccess(
          'Thành công', 'Bạn đã thay đổi mật khẩu của bạn thành công.');

      resetFormChangePassword();
      Navigator.of(Get.context!).pop();
    } catch (e) {
      HAppUtils.stopLoading();
      HAppUtils.showSnackBarError('Lỗi', e.toString());
    }
  }

  void resetFormChangePassword() {
    oldPasswordController.clear();
    newPasswordController.clear();
    correctPasswordController.clear();
    isHideOldPassword.value = false;
    isHideNewPassword.value = false;
    isHideCorrectPassword.value = false;
    changePasswordFormKey.currentState?.reset();
  }
}
