import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/authentication/controller/forget_password_controller.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';
import 'package:on_demand_grocery/src/utils/utils.dart';

class FormEnterEmailWidget extends StatelessWidget {
  FormEnterEmailWidget({
    super.key,
  });

  final forgetPasswordController = Get.put(ForgetPasswordController());

  @override
  Widget build(BuildContext context) {
    return Form(
      key: forgetPasswordController.forgetPasswordFormKey,
      child: Padding(
        padding: const EdgeInsets.all(hAppDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            gapH10,
            const Text(
              "Quên mật khẩu",
              style: HAppStyle.heading3Style,
            ),
            gapH6,
            Text.rich(
              TextSpan(
                text:
                    'Đừng lo lắng, chúng tôi sẽ gửi 1 đường dẫn đến email của bạn đặt lại mật khẩu.',
                style: HAppStyle.paragraph2Regular
                    .copyWith(color: HAppColor.hGreyColorShade600),
                children: const [],
              ),
            ),
            gapH12,
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              enableSuggestions: true,
              autocorrect: true,
              controller: forgetPasswordController.emailController,
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
            ElevatedButton(
              onPressed: () {
                FocusScope.of(context).requestFocus(FocusNode());
                forgetPasswordController.sendEmail();
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: HAppColor.hBluePrimaryColor,
                  fixedSize:
                      Size(HAppSize.deviceWidth - hAppDefaultPadding * 2, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50))),
              child: Text("Tiếp tục",
                  style: HAppStyle.label2Bold
                      .copyWith(color: HAppColor.hWhiteColor)),
            ),
          ],
        ),
      ),
    );
  }
}
