import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/personalization/controllers/address_controller.dart';
import 'package:on_demand_grocery/src/features/personalization/models/district_ward_model.dart';
import 'package:on_demand_grocery/src/services/location_service.dart';
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
                children: const [],
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
                        selectCity(newValue);
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
                              selectDistrict(newValue);
                            },
                            items: addressController.hanoiData
                                .map<DropdownMenuItem<String>>(
                                    (DistrictModel model) {
                              return DropdownMenuItem<String>(
                                value: model.name,
                                child: Text(model.name!),
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
                              selectWard(newValue);
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
            gapH12,
            Obx(() => SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  'Lấy vị trí hiện tại',
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
                value: addressController.isChoseCurrentPosition.value,
                onChanged: (changed) async {
                  addressController.isChoseCurrentPosition.value = changed;
                  if (addressController.isChoseCurrentPosition.value) {
                    final currentPosition =
                        await HLocationService.getGeoLocationPosition();
                    addressController.latitude.value = currentPosition.latitude;
                    addressController.longitude.value =
                        currentPosition.longitude;
                  }
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

  void selectWard(String? newValue) {
    valueWard = newValue!;
    addressController.ward.value = valueWard!;
    setState(() {});
  }

  void selectCity(String? newValue) {
    valueCity = newValue!;
    valueDistrict = null;
    valueWard = null;
    addressController.city.value = valueCity!;
    addressController.district.value = '';
    addressController.ward.value = '';
    setState(() {});
  }

  void selectDistrict(String? newValue) {
    valueDistrict = newValue!;
    valueWard = null;
    addressController.district.value = valueDistrict!;
    addressController.ward.value = '';
    list.assignAll(List<String>.from(addressController.hanoiData
        .firstWhere((DistrictModel model) => model.name == valueDistrict)
        .children!
        .map((WardModel model) => model.name)
        .toList()));
    setState(() {});
  }
}
