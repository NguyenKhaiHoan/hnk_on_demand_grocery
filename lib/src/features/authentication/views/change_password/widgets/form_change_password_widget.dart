import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/authentication/controller/change_password_controller.dart';
import 'package:on_demand_grocery/src/features/personalization/controllers/user_controller.dart';
import 'package:on_demand_grocery/src/repositories/user_repository.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';
import 'package:on_demand_grocery/src/utils/utils.dart';

class FormChangePasswordWidget extends StatelessWidget {
  FormChangePasswordWidget({super.key});

  final changePasswordController = Get.put(ChangePasswordController());

  @override
  Widget build(BuildContext context) {
    return Form(
      key: changePasswordController.changePasswordFormKey,
      child: Padding(
        padding: hAppDefaultPaddingLR,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                text:
                    'Hãy nhập đầy đủ các thông tin dưới đây để tiến hành đổi mật khẩu.',
                style: HAppStyle.paragraph2Regular
                    .copyWith(color: HAppColor.hGreyColorShade600),
                children: [],
              ),
            ),
            gapH24,
            Obx(() => TextFormField(
                  keyboardType: TextInputType.visiblePassword,
                  enableSuggestions: false,
                  autocorrect: false,
                  obscureText: changePasswordController.isHideOldPassword.value,
                  controller: changePasswordController.oldPasswordController,
                  validator: (value) => HAppUtils.validatePassword(value),
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(
                          changePasswordController.isHideOldPassword.value
                              ? EneftyIcons.eye_bold
                              : EneftyIcons.eye_slash_bold,
                          color: Colors.grey),
                      onPressed: () =>
                          changePasswordController.isHideOldPassword.value =
                              !changePasswordController.isHideOldPassword.value,
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: HAppColor.hGreyColorShade300, width: 1),
                        borderRadius: BorderRadius.circular(10)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: HAppColor.hGreyColorShade300, width: 1),
                        borderRadius: BorderRadius.circular(10)),
                    hintText: 'Nhập mật khẩu hiện tại của bạn',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                )),
            gapH12,
            Obx(() => TextFormField(
                  keyboardType: TextInputType.visiblePassword,
                  enableSuggestions: false,
                  autocorrect: false,
                  obscureText: changePasswordController.isHideNewPassword.value,
                  controller: changePasswordController.newPasswordController,
                  validator: (value) => HAppUtils.validatePassword(value),
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(
                          changePasswordController.isHideNewPassword.value
                              ? EneftyIcons.eye_bold
                              : EneftyIcons.eye_slash_bold,
                          color: Colors.grey),
                      onPressed: () =>
                          changePasswordController.isHideNewPassword.value =
                              !changePasswordController.isHideNewPassword.value,
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: HAppColor.hGreyColorShade300, width: 1),
                        borderRadius: BorderRadius.circular(10)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: HAppColor.hGreyColorShade300, width: 1),
                        borderRadius: BorderRadius.circular(10)),
                    hintText: 'Nhập mật khẩu mới của bạn',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                )),
            gapH12,
            Obx(() => TextFormField(
                  keyboardType: TextInputType.visiblePassword,
                  enableSuggestions: false,
                  autocorrect: false,
                  obscureText:
                      changePasswordController.isHideCorrectPassword.value,
                  controller:
                      changePasswordController.correctPasswordController,
                  validator: (value) => HAppUtils.validatePassword(value),
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(
                          changePasswordController.isHideCorrectPassword.value
                              ? EneftyIcons.eye_bold
                              : EneftyIcons.eye_slash_bold,
                          color: Colors.grey),
                      onPressed: () => changePasswordController
                              .isHideCorrectPassword.value =
                          !changePasswordController.isHideCorrectPassword.value,
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: HAppColor.hGreyColorShade300, width: 1),
                        borderRadius: BorderRadius.circular(10)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: HAppColor.hGreyColorShade300, width: 1),
                        borderRadius: BorderRadius.circular(10)),
                    hintText: 'Nhập lại mật khẩu mới của bạn',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                )),
            gapH12,
            ElevatedButton(
              onPressed: () {
                FocusScope.of(context).requestFocus(FocusNode());
                changePasswordController.changePassword();
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: HAppColor.hBluePrimaryColor,
                  fixedSize:
                      Size(HAppSize.deviceWidth - hAppDefaultPadding * 2, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50))),
              child: Text("Đổi",
                  style: HAppStyle.label2Bold
                      .copyWith(color: HAppColor.hWhiteColor)),
            ),
          ],
        ),
      ),
    );
  }
}
