import 'package:enefty_icons/enefty_icons.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/constants/app_assets.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/authentication/controller/login_controller.dart';
import 'package:on_demand_grocery/src/features/authentication/controller/sign_up_controller.dart';
import 'package:on_demand_grocery/src/routes/app_pages.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';
import 'package:social_media_buttons/social_media_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final signupController = Get.put(SignUpController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: const Icon(EvaIcons.arrowIosBackOutline),
        ),
      ),
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(hAppDefaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                gapH10,
                const Text(
                  "Đăng ký,",
                  style: HAppStyle.heading3Style,
                ),
                gapH6,
                Text.rich(
                  TextSpan(
                    text: 'Bạn đã có tài khoản? ',
                    style: HAppStyle.paragraph2Regular
                        .copyWith(color: HAppColor.hGreyColorShade600),
                    children: [
                      WidgetSpan(
                          child: GestureDetector(
                        onTap: () => Get.back(),
                        child: Text(
                          'Đăng nhập',
                          style: HAppStyle.heading5Style
                              .copyWith(color: HAppColor.hBluePrimaryColor),
                        ),
                      ))
                    ],
                  ),
                ),
                gapH24,
                SizedBox(
                  height: 50,
                  child: TextField(
                    keyboardType: TextInputType.name,
                    enableSuggestions: true,
                    autocorrect: true,
                    controller: signupController.nameController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: HAppColor.hGreyColorShade300, width: 1),
                          borderRadius: BorderRadius.circular(10)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: HAppColor.hGreyColorShade300, width: 1),
                          borderRadius: BorderRadius.circular(10)),
                      hintText: 'Nhập tên của bạn',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                gapH12,
                SizedBox(
                  height: 50,
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    enableSuggestions: true,
                    autocorrect: true,
                    controller: signupController.emailController,
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
                ),
                gapH12,
                SizedBox(
                  height: 50,
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    enableSuggestions: true,
                    autocorrect: true,
                    controller: signupController.emailController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: HAppColor.hGreyColorShade300, width: 1),
                          borderRadius: BorderRadius.circular(10)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: HAppColor.hGreyColorShade300, width: 1),
                          borderRadius: BorderRadius.circular(10)),
                      hintText: 'Nhập số điện thoại của bạn',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                gapH12,
                SizedBox(
                  height: 50,
                  child: TextField(
                    keyboardType: TextInputType.visiblePassword,
                    enableSuggestions: false,
                    autocorrect: false,
                    obscureText: true,
                    controller: signupController.passController,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: const Icon(EneftyIcons.eye_bold,
                            color: Colors.grey),
                        onPressed: () {},
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
                  ),
                ),
                gapH12,
                Row(children: [
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: Checkbox(
                      activeColor: HAppColor.hBluePrimaryColor,
                      value: true,
                      onChanged: (value) {},
                    ),
                  ),
                  gapW4,
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        text: 'Tôi đồng ý với ',
                        style: HAppStyle.paragraph2Regular
                            .copyWith(color: HAppColor.hGreyColorShade600),
                        children: [
                          TextSpan(
                            text: 'Điều khoản dịch vụ',
                            style: HAppStyle.paragraph2Regular.copyWith(
                                color: HAppColor.hBluePrimaryColor,
                                decoration: TextDecoration.underline),
                          ),
                          const TextSpan(text: ' và '),
                          TextSpan(
                            text: 'Chính sách bảo mật',
                            style: HAppStyle.paragraph2Regular.copyWith(
                                color: HAppColor.hBluePrimaryColor,
                                decoration: TextDecoration.underline),
                          )
                        ],
                      ),
                    ),
                  )
                ]),
                gapH12,
                ElevatedButton(
                  onPressed: () {
                    Get.offAllNamed(HAppRoutes.root);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: HAppColor.hBluePrimaryColor,
                      fixedSize: Size(
                          HAppSize.deviceWidth - hAppDefaultPadding * 2, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50))),
                  child: Text("Đăng ký",
                      style: HAppStyle.label2Bold
                          .copyWith(color: HAppColor.hWhiteColor)),
                ),
              ],
            ),
          )
        ],
      )),
    );
  }
}
