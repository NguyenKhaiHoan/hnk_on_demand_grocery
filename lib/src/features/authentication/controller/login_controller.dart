import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:on_demand_grocery/src/features/authentication/controller/network_controller.dart';
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
  final userController = UserController.instance;
  final networkController = Get.put(NetworkController());

  void login() async {
    try {
      HAppUtils.loadingOverlays();
      if (!loginFormKey.currentState!.validate()) {
        HAppUtils.stopLoading();
        return;
      }
      final isConnected = await networkController.isConnected();
      if (!isConnected) {
        HAppUtils.stopLoading();
        return;
      }

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

      final isConnected = await NetworkController.instance.isConnected();
      if (!isConnected) {
        HAppUtils.stopLoading();
        return;
      }
      final userCredential =
          await AuthenticationRepository.instance.signInWithGoogle();
      await userController.saveUserRecord(userCredential, 'Google');
      HAppUtils.stopLoading();
      AuthenticationRepository.instance.screenRedirect();
    } catch (e) {
      HAppUtils.stopLoading();
      HAppUtils.showSnackBarError('Lỗi', e.toString());
    }
  }
}
