import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/authentication/controller/login_controller.dart';
import 'package:on_demand_grocery/src/routes/app_pages.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';
import 'package:on_demand_grocery/src/utils/utils.dart';
import 'package:social_media_buttons/social_media_button.dart';

class FormLoginWidget extends StatelessWidget {
  FormLoginWidget({
    super.key,
  });

  final loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Form(
      key: loginController.loginFormKey,
      child: Padding(
        padding: const EdgeInsets.all(hAppDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            gapH10,
            const Text(
              "Chào mừng quay trở lại,",
              style: HAppStyle.heading3Style,
            ),
            gapH6,
            Text.rich(
              TextSpan(
                text: 'Bạn chưa có tài khoản? ',
                style: HAppStyle.paragraph2Regular
                    .copyWith(color: HAppColor.hGreyColorShade600),
                children: [
                  WidgetSpan(
                      child: GestureDetector(
                    onTap: () => Get.toNamed(HAppRoutes.signup),
                    child: Text(
                      'Đăng ký',
                      style: HAppStyle.heading5Style
                          .copyWith(color: HAppColor.hBluePrimaryColor),
                    ),
                  ))
                ],
              ),
            ),
            gapH24,
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              enableSuggestions: true,
              autocorrect: true,
              controller: loginController.emailController,
              validator: (value) => HAppUtils.validateEmail(value),
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: HAppColor.hGreyColorShade300, width: 1),
                    borderRadius: BorderRadius.circular(10)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: HAppColor.hGreyColorShade300, width: 1),
                    borderRadius: BorderRadius.circular(10)),
                hintText: 'Nhập email của bạn',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            gapH12,
            Obx(() => TextFormField(
                  keyboardType: TextInputType.visiblePassword,
                  enableSuggestions: false,
                  autocorrect: false,
                  obscureText: loginController.isHide.value,
                  controller: loginController.passController,
                  validator: (value) => HAppUtils.validatePassword(value),
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(
                          !loginController.isHide.value
                              ? EneftyIcons.eye_bold
                              : EneftyIcons.eye_slash_bold,
                          color: Colors.grey),
                      onPressed: () => loginController.isHide.value =
                          !loginController.isHide.value,
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: HAppColor.hGreyColorShade300, width: 1),
                        borderRadius: BorderRadius.circular(10)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: HAppColor.hGreyColorShade300, width: 1),
                        borderRadius: BorderRadius.circular(10)),
                    hintText: 'Nhập mật khẩu của bạn',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                )),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    Get.toNamed(HAppRoutes.forgetPassword);
                  },
                  child: Text("Quên mật khẩu?",
                      style: HAppStyle.paragraph3Regular
                          .copyWith(color: HAppColor.hBluePrimaryColor)),
                ),
              ),
            ),
            gapH12,
            ElevatedButton(
              onPressed: () {
                FocusScope.of(context).requestFocus(FocusNode());
                loginController.login();
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: HAppColor.hBluePrimaryColor,
                  fixedSize:
                      Size(HAppSize.deviceWidth - hAppDefaultPadding * 2, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50))),
              child: Obx(() => loginController.isLoading.value
                  ? const CircularProgressIndicator(
                      color: HAppColor.hWhiteColor,
                    )
                  : Text("Đăng nhập",
                      style: HAppStyle.label2Bold
                          .copyWith(color: HAppColor.hWhiteColor))),
            ),
            gapH24,
            Row(
              children: [
                Text(
                  "Hoặc tiếp tục với",
                  style: HAppStyle.label3Regular
                      .copyWith(color: HAppColor.hGreyColor),
                ),
                gapW10,
                Expanded(
                  child: Divider(
                    thickness: 1,
                    color: HAppColor.hGreyColorShade300,
                  ),
                ),
              ],
            ),
            gapH12,
            Row(
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      color: HAppColor.hBluePrimaryColor,
                      borderRadius: BorderRadius.circular(100)),
                  child: SocialMediaButton.google(
                    onTap: () => loginController.googleSignIn(),
                    size: 30,
                    color: HAppColor.hWhiteColor,
                  ),
                ),
                gapW24,
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 0, 93, 159),
                      borderRadius: BorderRadius.circular(100)),
                  child: SocialMediaButton.facebook(
                    onTap: () {},
                    size: 30,
                    color: HAppColor.hWhiteColor,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
