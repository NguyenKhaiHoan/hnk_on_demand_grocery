import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/authentication/controller/change_password_controller.dart';
import 'package:on_demand_grocery/src/features/personalization/controllers/address_controller.dart';
import 'package:on_demand_grocery/src/features/personalization/controllers/change_name_controller.dart';
import 'package:on_demand_grocery/src/features/personalization/controllers/user_controller.dart';
import 'package:on_demand_grocery/src/features/personalization/models/district_ward_model.dart';
import 'package:on_demand_grocery/src/features/shop/views/delivery_infomation/add_address_screen.dart';
import 'package:on_demand_grocery/src/repositories/user_repository.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';
import 'package:on_demand_grocery/src/utils/utils.dart';

class FormAddAddressWidget extends StatefulWidget {
  const FormAddAddressWidget({super.key});

  @override
  State<FormAddAddressWidget> createState() => _FormAddAddressWidgetState();
}

class _FormAddAddressWidgetState extends State<FormAddAddressWidget> {
  final addressController = AddressController.instance;

  String? valueDistrict;
  String? valueWard;
  String? valueCity;
  List<String> list = [];

  @override
  Widget build(BuildContext context) {
    return Form(
      key: addressController.addAddressFormKey,
      child: Padding(
        padding: hAppDefaultPaddingLR,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                text:
                    'Hãy nhập đầy đủ các thông tin dưới đây để tiến hành thêm địa chỉ mới.',
                style: HAppStyle.paragraph2Regular
                    .copyWith(color: HAppColor.hGreyColorShade600),
                children: [],
              ),
            ),
            gapH24,
            TextFormField(
              keyboardType: TextInputType.name,
              enableSuggestions: true,
              autocorrect: true,
              controller: addressController.nameController,
              validator: (value) => HAppUtils.validateEmptyField('Tên', value),
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
            gapH12,
            TextFormField(
              keyboardType: TextInputType.number,
              enableSuggestions: true,
              autocorrect: true,
              controller: addressController.phoneController,
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
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 60,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: HAppColor.hGreyColorShade300,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      underline: Container(),
                      value: valueCity,
                      hint: const Text('Chọn Thành phố'),
                      onChanged: (String? newValue) {
                        valueCity = newValue!;
                        valueDistrict = null;
                        valueWard = null;
                        addressController.city.value = valueCity!;
                        addressController.district.value = '';
                        addressController.ward.value = '';
                        setState(() {});
                      },
                      items: <String>['Hà Nội']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                gapH12,
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 60,
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: HAppColor.hGreyColorShade300,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            underline: Container(),
                            value: valueDistrict,
                            hint: const Text('Chọn Quận/Huyện'),
                            onChanged: (String? newValue) {
                              valueDistrict = newValue!;
                              valueWard = null;
                              addressController.district.value = valueDistrict!;
                              addressController.ward.value = '';
                              list.assignAll(listOfDistrictWard
                                  .firstWhere((DistrictWardModel model) =>
                                      model.district == valueDistrict)
                                  .ward);
                              setState(() {});
                            },
                            items: listOfDistrictWard
                                .map<DropdownMenuItem<String>>(
                                    (DistrictWardModel model) {
                              return DropdownMenuItem<String>(
                                value: model.district,
                                child: Text(model.district),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                    gapW10,
                    Expanded(
                      child: Container(
                        height: 60,
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: HAppColor.hGreyColorShade300,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            underline: Container(),
                            value: valueWard,
                            hint: const Text('Chọn Phường/Xã'),
                            onChanged: (String? newValue) {
                              valueWard = newValue!;
                              addressController.ward.value = valueWard!;
                              setState(() {});
                            },
                            items: list
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
            gapH12,
            TextFormField(
              keyboardType: TextInputType.text,
              enableSuggestions: true,
              autocorrect: true,
              controller: addressController.streetController,
              validator: (value) =>
                  HAppUtils.validateEmptyField('Số nhà, ngõ, đường', value),
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: HAppColor.hGreyColorShade300, width: 1),
                    borderRadius: BorderRadius.circular(10)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: HAppColor.hGreyColorShade300, width: 1),
                    borderRadius: BorderRadius.circular(10)),
                hintText: 'Nhập số nhà, ngõ, đường của bạn',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Obx(() => SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  'Đặt làm mặc định',
                  style: HAppStyle.paragraph2Regular,
                ),
                trackOutlineColor: MaterialStateProperty.resolveWith(
                  (final Set<MaterialState> states) {
                    if (states.contains(MaterialState.selected)) {
                      return null;
                    }
                    return HAppColor.hGreyColorShade300;
                  },
                ),
                activeColor: HAppColor.hBluePrimaryColor,
                activeTrackColor: HAppColor.hBlueSecondaryColor,
                inactiveThumbColor: HAppColor.hWhiteColor,
                inactiveTrackColor: HAppColor.hGreyColorShade300,
                value: addressController.isDefault.value,
                onChanged: (changed) {
                  addressController.isDefault.value = changed;
                })),
            gapH6,
            ElevatedButton(
              onPressed: () {
                FocusScope.of(context).requestFocus(FocusNode());
                addressController.addAddress();
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: HAppColor.hBluePrimaryColor,
                  fixedSize:
                      Size(HAppSize.deviceWidth - hAppDefaultPadding * 2, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50))),
              child: Text("Thêm",
                  style: HAppStyle.label2Bold
                      .copyWith(color: HAppColor.hWhiteColor)),
            ),
          ],
        ),
      ),
    );
  }
}
