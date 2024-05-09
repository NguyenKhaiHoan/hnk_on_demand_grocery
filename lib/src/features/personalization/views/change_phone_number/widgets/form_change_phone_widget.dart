import 'package:flutter/material.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/personalization/controllers/change_phone_controller.dart';
import 'package:on_demand_grocery/src/features/personalization/controllers/user_controller.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';
import 'package:on_demand_grocery/src/utils/utils.dart';

class FormChangePhoneWidget extends StatelessWidget {
  FormChangePhoneWidget({super.key});

  final changePhoneController = ChangePhoneController.instance;
  final userController = UserController.instance;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: changePhoneController.changePhoneFormKey,
      child: Padding(
        padding: hAppDefaultPaddingLR,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                text:
                    'Hãy nhập đầy đủ các thông tin dưới đây để tiến hành đổi tên.',
                style: HAppStyle.paragraph2Regular
                    .copyWith(color: HAppColor.hGreyColorShade600),
                children: const [],
              ),
            ),
            gapH24,
            TextFormField(
              keyboardType: TextInputType.phone,
              enableSuggestions: true,
              autocorrect: true,
              controller: changePhoneController.phoneController,
              validator: (value) => HAppUtils.validatePhoneNumber(value),
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
            gapH12,
            ElevatedButton(
              onPressed: () {
                FocusScope.of(context).requestFocus(FocusNode());
                changePhoneController.changePhone();
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
