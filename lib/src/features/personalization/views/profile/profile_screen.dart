import 'package:enefty_icons/enefty_icons.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:on_demand_grocery/src/common_widgets/cart_cirle_widget.dart';
import 'package:on_demand_grocery/src/common_widgets/custom_shimmer_widget.dart';
import 'package:on_demand_grocery/src/common_widgets/user_image_logo.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/personalization/controllers/change_name_controller.dart';
import 'package:on_demand_grocery/src/features/personalization/controllers/change_password_controller.dart';
import 'package:on_demand_grocery/src/features/personalization/controllers/change_phone_controller.dart';
import 'package:on_demand_grocery/src/features/personalization/controllers/user_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/root_controller.dart';
import 'package:on_demand_grocery/src/features/shop/views/chat/all_chat_screen.dart';
import 'package:on_demand_grocery/src/features/shop/views/order/all_voucher_screen.dart';
import 'package:on_demand_grocery/src/repositories/authentication_repository.dart';
import 'package:on_demand_grocery/src/routes/app_pages.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin<ProfileScreen> {
  @override
  bool get wantKeepAlive => true;
  final chanegPasswordController = Get.put(ChangePasswordController());
  final changeNameController = Get.put(ChangeNameController());
  final changePhoneController = Get.put(ChangePhoneController());

  final userController = UserController.instance;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Obx(() => userController.isLoading.value
        ? Center(
            child: PopScope(
              canPop: false,
              child: Lottie.asset('assets/animations/loading_animation.json',
                  height: 80, width: 80, fit: BoxFit.cover),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              actions: [
                Padding(
                  padding: hAppDefaultPaddingR,
                  child: CartCircle(),
                )
              ],
              toolbarHeight: 80,
              automaticallyImplyLeading: false,
              titleSpacing: 0,
              title: const Padding(
                padding: hAppDefaultPaddingL,
                child: Text(
                  'GroFast',
                  style: HAppStyle.heading3Style,
                ),
              ),
              centerTitle: false,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: hAppDefaultPaddingLR,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          Get.toNamed(HAppRoutes.profileDetail);
                          // await userController.loadingUserRecord();
                        },
                        child: Row(
                          children: [
                            UserImageLogoWidget(
                              size: 80,
                              hasFunction: false,
                            ),
                            gapW10,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Obx(() => userController.isLoading.value
                                    ? CustomShimmerWidget.rectangular(
                                        height: 10)
                                    : Text(
                                        userController.user.value.name,
                                        style: HAppStyle.heading4Style,
                                      )),
                                gapH4,
                                Text(
                                  'Xem hồ sơ',
                                  style: HAppStyle.paragraph3Regular.copyWith(
                                      color: HAppColor.hGreyColorShade600),
                                )
                              ],
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.arrow_forward_ios,
                              size: 15,
                            )
                          ],
                        ),
                      ),
                      gapH20,
                      const Text(
                        'Tài khoản',
                        style: HAppStyle.heading4Style,
                      ),
                      GestureDetector(
                        onTap: () => Get.toNamed(HAppRoutes.listOrder),
                        child: const ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(EvaIcons.shoppingBagOutline),
                          title: Text('Đơn hàng'),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Get.toNamed(HAppRoutes.cart),
                        child: const ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(EvaIcons.shoppingCartOutline),
                          title: Text('Giỏ hàng'),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Get.toNamed(HAppRoutes.allAddress),
                        child: const ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(EneftyIcons.location_outline),
                          title: Text('Địa chỉ'),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Get.to(AllChatScreen()),
                        child: const ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(EvaIcons.messageSquareOutline),
                          title: Text('Tin nhắn'),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.to(const AllVoucherScreen());
                        },
                        child: const ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(EvaIcons.pricetagsOutline),
                          title: Text('Mã ưu đãi'),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                          ),
                        ),
                      ),
                      const ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(EvaIcons.bellOutline),
                        title: Text('Thông báo'),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                        ),
                      ),
                      const ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(EvaIcons.externalLinkOutline),
                        title: Text('Giới thiệu với bạn bè'),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                        ),
                      ),
                      const ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(EvaIcons.settingsOutline),
                        title: Text('Cài đặt'),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                        ),
                      ),
                      gapH20,
                      const Text(
                        'Trợ giúp và hỗ trợ',
                        style: HAppStyle.heading4Style,
                      ),
                      const ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(EvaIcons.headphonesOutline),
                        title: Text('Liên hệ'),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                        ),
                      ),
                      const ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(EvaIcons.questionMarkCircleOutline),
                        title: Text('Câu hỏi thường gặp'),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                        ),
                      ),
                      gapH6,
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            AuthenticationRepository.instance.logOut();
                            RootController.instance.animateToScreen(0);
                          },
                          child: const Text('Đăng xuất'),
                        ),
                      ),
                      gapH100,
                    ]),
              ),
            )));
  }
}
