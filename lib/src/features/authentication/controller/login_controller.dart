import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:on_demand_grocery/src/features/personalization/controllers/user_controller.dart';
import 'package:on_demand_grocery/src/repositories/authentication_repository.dart';
import 'package:on_demand_grocery/src/utils/utils.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  final localStorage = GetStorage();
  var isHide = true.obs;
  var isLoading = false.obs;
  final userController = Get.put(UserController());

  @override
  void onInit() {
    emailController.text = localStorage.read('email');
    passController.text = localStorage.read('password');
    super.onInit();
  }

  void login() async {
    try {
      HAppUtils.loadingOverlays();
      if (!loginFormKey.currentState!.validate()) {
        HAppUtils.stopLoading();
        return;
      }

      localStorage.write('email', emailController.text.trim());
      localStorage.write('password', passController.text.trim());

      final userCredential = await AuthenticationRepository.instance
          .loginWithEmailAndPassword(
              emailController.text.trim(), passController.text.trim());

      HAppUtils.stopLoading();
      AuthenticationRepository.instance.screenRedirect();
    } catch (e) {
      HAppUtils.stopLoading();
      HAppUtils.showSnackBarError('Lỗi', e.toString());
    }
  }

  void googleSignIn() async {
    try {
      isLoading.value = true;
      if (!loginFormKey.currentState!.validate()) {
        HAppUtils.stopLoading();
        return;
      }

      final userCredential =
          await AuthenticationRepository.instance.signInWithGoogle();
      await userController.saveUserRecord(userCredential);
      HAppUtils.stopLoading();
      AuthenticationRepository.instance.screenRedirect();
    } catch (e) {
      HAppUtils.stopLoading();
      HAppUtils.showSnackBarError('Lỗi', e.toString());
    }
  }
}
