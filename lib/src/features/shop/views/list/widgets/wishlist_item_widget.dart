import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/common_widgets/custom_shimmer_widget.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/wishlist_controller.dart';
import 'package:on_demand_grocery/src/features/shop/models/product_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/wishlist_model.dart';
import 'package:on_demand_grocery/src/features/shop/views/home/widgets/product_list_stack.dart';
import 'package:on_demand_grocery/src/repositories/product_repository.dart';
import 'package:on_demand_grocery/src/routes/app_pages.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';

class WishlistItemWidget extends StatefulWidget {
  const WishlistItemWidget({
    super.key,
    required this.model,
  });

  final WishlistModel model;

  @override
  State<WishlistItemWidget> createState() => _WishlistItemWidgetState();
}

class _WishlistItemWidgetState extends State<WishlistItemWidget> {
  var firstPart = ''.obs;
  var secondPart = ''.obs;

  @override
  void initState() {
    super.initState();
    firstPart.value = widget.model.description;
    if (widget.model.description.contains('Tên') &&
        widget.model.description.contains('Thành phần') &&
        widget.model.description.contains('Cách làm') &&
        widget.model.description.contains('-recipe-')) {
      List<String> parts = widget.model.description.split('-recipe-');

      if (parts.length >= 2) {
        firstPart.value = parts[0];
        secondPart.value = parts[1];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<ProductModel> list = [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.model.title,
                  style: HAppStyle.heading4Style,
                ),
                gapH4,
                Obx(() => Text(
                      firstPart.value,
                      style: HAppStyle.paragraph3Regular
                          .copyWith(color: HAppColor.hGreyColorShade600),
                    )),
                Obx(() => FutureBuilder(
                    key: Key(
                        'WishlistItem${WishlistController.instance.refreshWishlistItemData.value.toString()}'),
                    future: ProductRepository.instance
                        .getProductsFromListIds(widget.model.listIds),
                    builder: ((context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CustomShimmerWidget.rectangular(height: 60);
                      }

                      if (snapshot.hasError) {
                        return const Center(
                          child: Text(
                              'Đã xảy ra sự cố. Xin vui lòng thử lại sau.'),
                        );
                      }

                      if (!snapshot.hasData ||
                          snapshot.data == null ||
                          snapshot.data!.isEmpty) {
                        return Container();
                      } else {
                        final data = snapshot.data!;
                        list.assignAll(data);
                        return Column(
                          children: [
                            gapH10,
                            ProductListStackWidget(
                              maxItems: 8,
                              items: data,
                            ),
                          ],
                        );
                      }
                    }))),
              ],
            )),
            GestureDetector(
              onTap: () => Get.toNamed(HAppRoutes.wishlistItem,
                  arguments: {'model': widget.model, 'list': list}),
              child: Text(
                'Xem tất cả',
                style: HAppStyle.paragraph3Regular
                    .copyWith(color: HAppColor.hBluePrimaryColor),
              ),
            )
          ],
        ),
        gapH4,
        Divider(
          color: HAppColor.hGreyColorShade300,
        )
      ],
    );
  }
}

class ShimmerWishlistItemWidget extends StatelessWidget {
  const ShimmerWishlistItemWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomShimmerWidget.rectangular(
                  height: 14,
                  width: 50,
                ),
                gapH4,
                CustomShimmerWidget.rectangular(
                  height: 12,
                  width: 100,
                ),
                gapH4,
                CustomShimmerWidget.rectangular(
                  height: 60,
                ),
              ],
            )),
          ],
        ),
        gapH4,
        CustomShimmerWidget.rectangular(
          height: 2,
        ),
      ],
    );
  }
}
