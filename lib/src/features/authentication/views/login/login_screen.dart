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
import 'package:on_demand_grocery/src/routes/app_pages.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';
import 'package:social_media_buttons/social_media_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final loginController = Get.put(LoginController());

  // @override
  // void initState() {
  //   super.initState();
  //   loginController.phoneNumberController.text = "+84";
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipPath(
            clipper: OvalBottomBorderClipper(),
            child: Container(
              height: HAppSize.deviceHeight * 0.30,
              padding: const EdgeInsets.all(0),
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(HAppAsset.onboardingImage),
                      fit: BoxFit.fitWidth)),
            ),
          ),
          Padding(
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
                SizedBox(
                  height: 50,
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    enableSuggestions: true,
                    autocorrect: true,
                    controller: loginController.emailController,
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
                    keyboardType: TextInputType.visiblePassword,
                    enableSuggestions: false,
                    autocorrect: false,
                    obscureText: true,
                    controller: loginController.passController,
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
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {},
                      child: Text("Quên mật khẩu?",
                          style: HAppStyle.paragraph3Regular
                              .copyWith(color: HAppColor.hBluePrimaryColor)),
                    ),
                  ),
                ),
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
                  child: Text("Đăng nhập",
                      style: HAppStyle.label2Bold
                          .copyWith(color: HAppColor.hWhiteColor)),
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
                        onTap: () {},
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
          )
        ],
      )),
    );
  }
}
