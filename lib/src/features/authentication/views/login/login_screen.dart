import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  @override
  void initState() {
    super.initState();
    loginController.phoneNumberController.text = "+84";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        toolbarHeight: 80,
        leading: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: hAppDefaultPadding),
            child: GestureDetector(
                onTap: () => Get.back(),
                child: const Icon(
                  Icons.arrow_back_ios,
                  size: 20,
                )),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
                padding: hAppDefaultPaddingLR,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    gapH24,
                    const Text(
                      "Nhập số điện thoại của bạn",
                      style: HAppStyle.heading2Style,
                    ),
                    gapH12,
                    const Text(
                      "Chúng tôi sẽ gửi cho bạn một mã OTP để xác nhận",
                      style: HAppStyle.paragraph1Regular,
                    ),
                    gapH40,
                    const Text(
                      "Số điện thoại",
                      style: HAppStyle.paragraph1Regular,
                    ),
                    gapH6,
                    Container(
                      height: 55,
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 1, color: HAppColor.hGreyColorShade300),
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          gapW10,
                          SizedBox(
                            width: 40,
                            child: TextField(
                              textAlignVertical: TextAlignVertical.center,
                              controller: loginController.phoneNumberController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintStyle: HAppStyle.paragraph1Bold
                                    .copyWith(color: HAppColor.hGreyColor),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          gapW10,
                          Container(
                            width: 2,
                            height: 40,
                            color: HAppColor.hGreyColorShade300,
                          ),
                          gapW10,
                          Expanded(
                              child: TextField(
                            autofocus: true,
                            textAlignVertical: TextAlignVertical.center,
                            onChanged: (value) =>
                                loginController.phoneNumber.value = value,
                            onEditingComplete: () async {
                              Get.toNamed(HAppRoutes.verify);

                              // await FirebaseAuth.instance.verifyPhoneNumber(
                              //   phoneNumber:
                              //       loginController.phoneNumberController.text +
                              //           loginController.phoneNumber.value,
                              //   verificationCompleted:
                              //       (PhoneAuthCredential credential) {},
                              //   verificationFailed:
                              //       (FirebaseAuthException e) {},
                              //   codeSent:
                              //       (String verificationId, int? resendToken) {
                              //     loginController.verificationId.value =
                              //         verificationId;
                              //     Get.toNamed(HAppRoutes.verify);
                              //   },
                              //   codeAutoRetrievalTimeout:
                              //       (String verificationId) {},
                              // );
                            },
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              hintStyle: HAppStyle.paragraph1Bold
                                  .copyWith(color: HAppColor.hGreyColor),
                              border: InputBorder.none,
                              hintText: "",
                            ),
                          )),
                        ],
                      ),
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
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                              color: HAppColor.hBluePrimaryColor,
                              borderRadius: BorderRadius.circular(100)),
                          child: SocialMediaButton.google(
                            onTap: () {},
                            size: 40,
                            color: HAppColor.hWhiteColor,
                          ),
                        ),
                        gapW24,
                        Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 0, 93, 159),
                              borderRadius: BorderRadius.circular(100)),
                          child: SocialMediaButton.facebook(
                            onTap: () {},
                            size: 40,
                            color: HAppColor.hWhiteColor,
                          ),
                        ),
                      ],
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
