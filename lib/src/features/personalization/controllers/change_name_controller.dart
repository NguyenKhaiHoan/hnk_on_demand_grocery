import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:on_demand_grocery/src/features/authentication/controller/network_controller.dart';
import 'package:on_demand_grocery/src/features/personalization/controllers/user_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/root_controller.dart';
import 'package:on_demand_grocery/src/repositories/authentication_repository.dart';
import 'package:on_demand_grocery/src/repositories/user_repository.dart';
import 'package:on_demand_grocery/src/routes/app_pages.dart';
import 'package:on_demand_grocery/src/utils/utils.dart';

class ChangeNameController extends GetxController {
  static ChangeNameController get instance => Get.find();

  final TextEditingController nameController = TextEditingController();
  GlobalKey<FormState> changeNameFormKey = GlobalKey<FormState>();
  final userController = UserController.instance;
  final userRepository = Get.put(UserRepository());
  final rootController = RootController.instance;
  var isLoading = false.obs;

  @override
  void onInit() {
    initNameField();
    super.onInit();
  }

  Future<void> initNameField() async {
    nameController.text = userController.user.value.name;
  }

  changeName() async {
    try {
      isLoading.value = true;
      HAppUtils.loadingOverlays();

      final isConnected = await NetworkController.instance.isConnected();
      if (!isConnected) {
        HAppUtils.stopLoading();
        return;
      }

      if (!changeNameFormKey.currentState!.validate()) {
        HAppUtils.stopLoading();
        return;
      }

      var name = {'Name': nameController.text.trim()};
      await userRepository.updateSingleField(name);

      userController.user.value.name = nameController.text.trim();

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
    nameController.clear();
    changeNameFormKey.currentState?.reset();
  }
}
