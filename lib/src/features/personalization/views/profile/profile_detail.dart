import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/common_widgets/user_image_logo.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/personalization/controllers/user_controller.dart';
import 'package:on_demand_grocery/src/routes/app_pages.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';
import 'package:shimmer/shimmer.dart';

class ProfileDetailScreen extends StatefulWidget {
  const ProfileDetailScreen({super.key});

  @override
  State<ProfileDetailScreen> createState() => _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends State<ProfileDetailScreen> {
  final userController = UserController.instance;
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
                Obx(() => userController.isUploadImageLoading.value
                    ? Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: UserImageLogoWidget(size: 80))
                    : UserImageLogoWidget(size: 80)),
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
                SectionProfileWidget(
                  title: 'Tên',
                  showIcon: true,
                  function: () {
                    Get.toNamed(HAppRoutes.changeName);
                  },
                  title2: userController.user.value.name,
                ),
                gapH6,
                Divider(
                  color: HAppColor.hGreyColorShade300,
                ),
                gapH6,
                SectionProfileWidget(
                  title: 'Id',
                  showIcon: true,
                  title2: userController.user.value.id,
                ),
                gapH6,
                Divider(
                  color: HAppColor.hGreyColorShade300,
                ),
                gapH6,
                SectionProfileWidget(
                  title: 'Số điện thoại',
                  showIcon: true,
                  function: () {},
                  title2: userController.user.value.phoneNumber,
                ),
                gapH6,
                Divider(
                  color: HAppColor.hGreyColorShade300,
                ),
                gapH6,
                SectionProfileWidget(
                  title: 'Email',
                  showIcon: false,
                  title2: userController.user.value.email,
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
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}

class SectionProfileWidget extends StatelessWidget {
  SectionProfileWidget({
    super.key,
    required this.title,
    required this.title2,
    required this.showIcon,
    this.function,
  });

  final userController = UserController.instance;
  final String title2;
  final Function()? function;
  final bool showIcon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: HAppStyle.paragraph2Bold,
        ),
        const Spacer(),
        Obx(
          () => userController.isLoading.value
              ? Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Text(
                    title,
                    style: HAppStyle.paragraph2Regular
                        .copyWith(color: HAppColor.hGreyColorShade600),
                  ),
                )
              : Text(
                  title2,
                  style: HAppStyle.paragraph2Regular
                      .copyWith(color: HAppColor.hGreyColorShade600),
                ),
        ),
        showIcon
            ? title == 'Id'
                ? Row(
                    children: [
                      gapW6,
                      GestureDetector(
                        onTap: function,
                        child: const Icon(
                          EvaIcons.copyOutline,
                          size: 20,
                        ),
                      )
                    ],
                  )
                : Row(
                    children: [
                      gapW6,
                      GestureDetector(
                        onTap: function,
                        child: const Icon(
                          EvaIcons.arrowIosForwardOutline,
                          size: 20,
                        ),
                      )
                    ],
                  )
            : Container()
      ],
    );
  }
}
