import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/authentication/controller/login_controller.dart';
import 'package:on_demand_grocery/src/routes/app_pages.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';
import 'package:pinput/pinput.dart';
import 'package:social_media_buttons/social_media_button.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({super.key});

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;

  final loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: HAppColor.hBluePrimaryColor),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Color.fromRGBO(234, 239, 243, 1),
      ),
    );

    return Scaffold(
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
                    const Column(
                      children: [
                        const Text(
                          "Xác minh số điện thoại của bạn",
                          style: HAppStyle.heading2Style,
                        ),
                        gapH12,
                        Text(
                          "Chúng tôi vừa gửi một mã code đến số điện thoại",
                          style: HAppStyle.paragraph1Regular,
                        ),
                      ],
                    ),
                    gapH40,
                    Pinput(
                      length: 6,
                      defaultPinTheme: defaultPinTheme,
                      focusedPinTheme: focusedPinTheme,
                      submittedPinTheme: submittedPinTheme,
                      validator: (s) {
                        return s == loginController.smsOtp.value
                            ? null
                            : 'Nhập sai mã OTP';
                      },
                      onChanged: (value) {
                        loginController.smsOtp.value = value;
                      },
                      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                      showCursor: true,
                      onCompleted: ((pin) => print(pin)),
                    ),
                    gapH24,
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: HAppColor.hBluePrimaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          onPressed: () async {
                            PhoneAuthCredential credential =
                                PhoneAuthProvider.credential(
                                    verificationId:
                                        loginController.verificationId.value,
                                    smsCode: loginController.smsOtp.value);

                            await auth.signInWithCredential(credential);
                            Get.offNamed(HAppRoutes.root);
                          },
                          child: Text(
                            "Xác thực",
                            style: HAppStyle.label2Bold
                                .copyWith(color: HAppColor.hWhiteColor),
                          )),
                    ),
                    gapH24,
                    Row(
                      children: [
                        Text(
                          "Không nhận được mã?  ",
                          style: HAppStyle.paragraph2Regular,
                        ),
                        GestureDetector(
                          child: Text(
                            "Gửi lại",
                            style: HAppStyle.label2Bold
                                .copyWith(color: HAppColor.hBluePrimaryColor),
                          ),
                          onTap: () {},
                        )
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
