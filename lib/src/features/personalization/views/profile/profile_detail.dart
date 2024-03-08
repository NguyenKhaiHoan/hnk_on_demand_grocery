import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/common_widgets/user_image_logo.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/personalization/controllers/change_name_controller.dart';
import 'package:on_demand_grocery/src/features/personalization/controllers/change_phone_controller.dart';
import 'package:on_demand_grocery/src/features/personalization/controllers/user_controller.dart';
import 'package:on_demand_grocery/src/features/personalization/views/profile/widgets/section_profile.dart';
import 'package:on_demand_grocery/src/routes/app_pages.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';

class ProfileDetailScreen extends StatefulWidget {
  const ProfileDetailScreen({super.key});

  @override
  State<ProfileDetailScreen> createState() => _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends State<ProfileDetailScreen> {
  final userController = UserController.instance;
  final changeNameController = ChangeNameController.instance;

  var changePhoneController = Get.put(ChangePhoneController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        leading: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: hAppDefaultPadding),
            child: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: const Icon(
                  Icons.arrow_back_ios,
                  size: 20,
                )),
          ),
        ),
        title: const Text("Hồ sơ"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: hAppDefaultPaddingLR,
        child: Column(children: [
          Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                UserImageLogoWidget(
                  size: 80,
                  hasFunction: false,
                ),
                gapH12,
                GestureDetector(
                  onTap: () {
                    userController.uploadUserProfileImage();
                  },
                  child: Text(
                    'Đổi ảnh hồ sơ',
                    style: HAppStyle.heading5Style
                        .copyWith(color: HAppColor.hBluePrimaryColor),
                  ),
                )
              ])),
          gapH24,
          Container(
            padding: const EdgeInsets.all(hAppDefaultPadding),
            width: HAppSize.deviceWidth,
            decoration: BoxDecoration(
                color: HAppColor.hWhiteColor,
                borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: [
                Obx(() => SectionProfileWidget(
                      title: 'Tên',
                      showIcon: true,
                      function: () {
                        Get.toNamed(HAppRoutes.changeName);
                      },
                      title2: userController.user.value.name,
                      isSubLoading: changeNameController.isLoading.value,
                    )),
                gapH6,
                Divider(
                  color: HAppColor.hGreyColorShade300,
                ),
                gapH6,
                SectionProfileWidget(
                  title: 'Id',
                  showIcon: true,
                  title2: userController.user.value.id,
                  isSubLoading: false,
                ),
                gapH6,
                Divider(
                  color: HAppColor.hGreyColorShade300,
                ),
                gapH6,
                Obx(() => SectionProfileWidget(
                      title: 'Số điện thoại',
                      showIcon: true,
                      function: () {
                        Get.toNamed(HAppRoutes.changePhone);
                      },
                      title2: userController.user.value.phoneNumber,
                      isSubLoading: changePhoneController.isLoading.value,
                    )),
                gapH6,
                Divider(
                  color: HAppColor.hGreyColorShade300,
                ),
                gapH6,
                SectionProfileWidget(
                  title: 'Email',
                  showIcon: false,
                  title2: userController.user.value.email,
                  isSubLoading: false,
                ),
                gapH6,
                Divider(
                  color: HAppColor.hGreyColorShade300,
                ),
                gapH6,
                SectionProfileWidget(
                  title: 'Ngày tạo',
                  showIcon: false,
                  title2: userController.user.value.creationDate,
                  isSubLoading: false,
                ),
              ],
            ),
          ),
          gapH12,
          Container(
            padding: const EdgeInsets.all(hAppDefaultPadding),
            width: HAppSize.deviceWidth,
            decoration: BoxDecoration(
                color: HAppColor.hWhiteColor,
                borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: [
                SectionProfileWidget(
                  title: 'Hình thức đăng nhập',
                  showIcon: false,
                  title2: userController.user.value.authenticationBy,
                  isSubLoading: false,
                ),
                userController.user.value.authenticationBy == 'Email'
                    ? Column(
                        children: [
                          gapH6,
                          Divider(
                            color: HAppColor.hGreyColorShade300,
                          ),
                          gapH6,
                          SectionProfileWidget(
                            title: 'Đổi mật khẩu',
                            title2: '',
                            showIcon: true,
                            function: () {
                              Get.toNamed(HAppRoutes.changePassword);
                            },
                            isSubLoading: false,
                          )
                        ],
                      )
                    : Container(),
              ],
            ),
          ),
          gapH12,
          Container(
            padding: const EdgeInsets.all(hAppDefaultPadding),
            width: HAppSize.deviceWidth,
            decoration: BoxDecoration(
                color: HAppColor.hWhiteColor,
                borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: [
                SectionProfileWidget(
                  title: 'Xóa tài khoản',
                  showIcon: true,
                  function: () {},
                  title2: '',
                  isSubLoading: false,
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
