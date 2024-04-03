import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/authentication/controller/sign_up_controller.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';
import 'package:on_demand_grocery/src/utils/utils.dart';

class FormSignUpWidget extends StatelessWidget {
  FormSignUpWidget({
    super.key,
  });
  final signupController = SignUpController.instance;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: signupController.signupFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          TextFormField(
            keyboardType: TextInputType.name,
            enableSuggestions: true,
            autocorrect: true,
            controller: signupController.nameController,
            validator: (value) => HAppUtils.validateEmptyField('Tên', value),
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: HAppColor.hGreyColorShade300, width: 1),
                  borderRadius: BorderRadius.circular(10)),
              focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: HAppColor.hGreyColorShade300, width: 1),
                  borderRadius: BorderRadius.circular(10)),
              hintText: 'Nhập tên của bạn',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          gapH12,
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            enableSuggestions: true,
            autocorrect: true,
            controller: signupController.emailController,
            validator: (value) => HAppUtils.validateEmail(value),
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: HAppColor.hGreyColorShade300, width: 1),
                  borderRadius: BorderRadius.circular(10)),
              focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: HAppColor.hGreyColorShade300, width: 1),
                  borderRadius: BorderRadius.circular(10)),
              hintText: 'Nhập email của bạn',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          gapH12,
          TextFormField(
            keyboardType: TextInputType.number,
            enableSuggestions: true,
            autocorrect: true,
            controller: signupController.phoneController,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: HAppColor.hGreyColorShade300, width: 1),
                  borderRadius: BorderRadius.circular(10)),
              focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: HAppColor.hGreyColorShade300, width: 1),
                  borderRadius: BorderRadius.circular(10)),
              hintText: 'Nhập số điện thoại của bạn (tùy chọn)',
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
                obscureText: signupController.isHide.value,
                controller: signupController.passController,
                validator: (value) => HAppUtils.validatePassword(value),
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(
                        !signupController.isHide.value
                            ? EneftyIcons.eye_bold
                            : EneftyIcons.eye_slash_bold,
                        color: Colors.grey),
                    onPressed: () => signupController.isHide.value =
                        !signupController.isHide.value,
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
          gapH12,
          Row(children: [
            SizedBox(
              height: 24,
              width: 24,
              child: Obx(() => Checkbox(
                    activeColor: HAppColor.hBluePrimaryColor,
                    value: signupController.isChoseCondition.value,
                    onChanged: (value) => signupController.isChoseCondition
                        .value = !signupController.isChoseCondition.value,
                  )),
            ),
            gapW8,
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
              FocusScope.of(context).requestFocus(FocusNode());
              signupController.signup();
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: HAppColor.hBluePrimaryColor,
                fixedSize:
                    Size(HAppSize.deviceWidth - hAppDefaultPadding * 2, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50))),
            child: Text("Đăng ký",
                style: HAppStyle.label2Bold
                    .copyWith(color: HAppColor.hWhiteColor)),
          ),
        ],
      ),
    );
  }
}
