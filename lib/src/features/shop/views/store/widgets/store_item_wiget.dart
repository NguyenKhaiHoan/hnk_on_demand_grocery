import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/common_widgets/custom_shimmer_widget.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/personalization/controllers/user_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/category_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/store_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/wishlist_controller.dart';
import 'package:on_demand_grocery/src/features/shop/models/store_location_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/store_model.dart';
import 'package:on_demand_grocery/src/repositories/user_repository.dart';
import 'package:on_demand_grocery/src/services/location_service.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';
import 'package:on_demand_grocery/src/utils/utils.dart';

class StoreItemWidget extends StatefulWidget {
  const StoreItemWidget({super.key, required this.model});
  final StoreModel model;

  @override
  State<StoreItemWidget> createState() => _StoreItemWidgetState();
}

class _StoreItemWidgetState extends State<StoreItemWidget> {
  var storeLocation = StoreLocationModel.empty().obs;

  final storeController = Get.put(StoreController());
  final wishlistController = Get.put(WishlistController());

  var checkStatus = false.obs;

  bool checkFollowStore(String storeId) {
    return UserController.instance.user.value.listOfFavoriteStore!
        .contains(storeId);
  }

  Future<void> addAndRemoveFollowStore(String storeId) async {
    checkStatus.value = checkFollowStore(storeId);
    final userRepository = Get.put(UserRepository());
    if (checkStatus.value) {
      UserController.instance.user.value.listOfFavoriteStore!
          .removeWhere((element) => element == storeId);
      UserController.instance.user.refresh();
      userRepository.updateSingleField({
        'ListOfFavoriteStore':
            UserController.instance.user.value.listOfFavoriteStore!
      }).then((value) {
        DatabaseReference ref =
            FirebaseDatabase.instance.ref().child('FollowedStores/$storeId');
        ref.child(UserController.instance.user.value.id).remove().then((_) {
          print('Xóa thành công');
          HAppUtils.showSnackBarSuccess('Hủy nhận thông báo thành công',
              'Bạn đã hủy nhận thông báo khi cửa hàng có thông báo mới');
        }).catchError((error) {
          print('Có lỗi xảy ra: $error');
        });
      });
    } else {
      UserController.instance.user.value.listOfFavoriteStore!.add(storeId);
      UserController.instance.user.refresh();
      userRepository.updateSingleField({
        'ListOfFavoriteStore':
            UserController.instance.user.value.listOfFavoriteStore!
      }).then((value) {
        DatabaseReference ref =
            FirebaseDatabase.instance.ref().child('FollowedStores/$storeId');
        ref.update({
          UserController.instance.user.value.id:
              UserController.instance.user.value.cloudMessagingToken
        }).then((_) {
          print('Cập nhật thành công');
          HAppUtils.showSnackBarSuccess('Đăng ký nhận thông báo thành công',
              'Chúng tôi sẽ gửi cho bạn thông báo khi cửa hàng có thông báo mới');
        }).catchError((error) {
          print('Có lỗi xảy ra: $error');
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      storeLocation.value =
          await HLocationService.getLocationOneStore(widget.model.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: HAppSize.deviceWidth - hAppDefaultPadding * 2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: HAppColor.hWhiteColor,
      ),
      padding: const EdgeInsets.all(10),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Stack(
            children: [
              Container(
                height: 130,
                width: 130,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                        image: NetworkImage(widget.model.storeImage),
                        fit: BoxFit.fill)),
              ),
              Positioned(
                top: 5,
                left: 5,
                child: GestureDetector(
                  onTap: () => addAndRemoveFollowStore(widget.model.id),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: HAppColor.hBackgroundColor),
                    child: Center(
                        child: Obx(
                      () => !UserController
                              .instance.user.value.listOfFavoriteStore!
                              .contains(widget.model.id)
                          ? const Icon(
                              EvaIcons.heartOutline,
                              color: HAppColor.hGreyColor,
                            )
                          : const Icon(
                              EvaIcons.heart,
                              color: HAppColor.hRedColor,
                            ),
                    )),
                  ),
                ),
              ),
            ],
          ),
          gapW10,
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  widget.model.name,
                  style: HAppStyle.heading4Style,
                ),
                gapH10,
                Text(
                  CategoryController.instance.listOfCategory
                      .where((category) =>
                          widget.model.listOfCategoryId.contains(category.id))
                      .map((e) => e.name)
                      .join(', '),
                  maxLines: 2,
                  style: HAppStyle.paragraph3Regular.copyWith(
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                gapH10,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      EvaIcons.star,
                      color: HAppColor.hOrangeColor,
                      size: 20,
                    ),
                    gapW2,
                    Text(
                      widget.model.rating.toStringAsFixed(1),
                      style: HAppStyle.paragraph3Regular,
                    ),
                    Text(
                      ' /5',
                      style: HAppStyle.paragraph3Regular
                          .copyWith(color: HAppColor.hGreyColorShade600),
                    ),
                    gapW2,
                    Text(" • ",
                        style: HAppStyle.paragraph3Regular
                            .copyWith(color: HAppColor.hGreyColorShade600)),
                    gapW2,
                    Obx(() => storeLocation.value == StoreLocationModel.empty()
                        ? CustomShimmerWidget.rectangular(
                            height: 12,
                            width: 30,
                          )
                        : Text.rich(TextSpan(
                            text: HAppUtils.metersToKilometers(
                                storeLocation.value.distance),
                            style: HAppStyle.paragraph3Regular,
                            children: [
                                TextSpan(
                                    text: ' Km',
                                    style: HAppStyle.paragraph3Regular.copyWith(
                                        color: HAppColor.hGreyColorShade600))
                              ])))
                  ],
                ),
              ],
            ),
          ),
        ]),
      ]),
    );
  }
}

class ShimmerStoreItemWidget extends StatelessWidget {
  const ShimmerStoreItemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: HAppSize.deviceWidth - hAppDefaultPadding * 2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: HAppColor.hWhiteColor,
      ),
      padding: const EdgeInsets.all(10),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          CustomShimmerWidget.rectangular(
            height: 130,
            width: 130,
          ),
          gapW10,
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomShimmerWidget.rectangular(
                  height: 14,
                ),
                gapH10,
                CustomShimmerWidget.rectangular(
                  height: 16,
                ),
                gapH10,
                CustomShimmerWidget.rectangular(
                  height: 14,
                  width: 100,
                ),
              ],
            ),
          ),
        ]),
      ]),
    );
  }
}
