import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/features/authentication/controller/network_controller.dart';
import 'package:on_demand_grocery/src/features/personalization/controllers/user_controller.dart';
import 'package:on_demand_grocery/src/repositories/user_repository.dart';
import 'package:on_demand_grocery/src/utils/utils.dart';

class ChangePhoneController extends GetxController {
  static ChangePhoneController get instance => Get.find();

  final TextEditingController phoneController = TextEditingController();
  GlobalKey<FormState> changePhoneFormKey = GlobalKey<FormState>();
  final userController = UserController.instance;
  final userRepository = Get.put(UserRepository());
  var isLoading = false.obs;

  @override
  void onInit() {
    initPhoneField();
    super.onInit();
  }

  Future<void> initPhoneField() async {
    if (userController.user.value.phoneNumber.isNotEmpty) {
      phoneController.text = userController.user.value.phoneNumber;
    }
  }

  changePhone() async {
    try {
      isLoading.value = true;
      HAppUtils.loadingOverlays();

      final isConnected = await NetworkController.instance.isConnected();
      if (!isConnected) {
        HAppUtils.stopLoading();
        return;
      }

      if (!changePhoneFormKey.currentState!.validate()) {
        HAppUtils.stopLoading();
        return;
      }

      var phoneNumber = {'PhoneNumber': phoneController.text.trim()};
      await userRepository.updateSingleField(phoneNumber);

      userController.user.value.phoneNumber = phoneController.text.trim();
      userController.user.refresh();

      HAppUtils.stopLoading();
      HAppUtils.showSnackBarSuccess(
          'Thành công', 'Bạn đã thay đổi tên của bạn thành công.');

      isLoading.value = false;
      resetFormChangeName();
      Navigator.of(Get.context!).pop();
    } catch (e) {
      isLoading.value = false;
      HAppUtils.stopLoading();
      HAppUtils.showSnackBarError('Lỗi', e.toString());
    }
  }

  void resetFormChangeName() {
    phoneController.clear();
    changePhoneFormKey.currentState?.reset();
  }
}
