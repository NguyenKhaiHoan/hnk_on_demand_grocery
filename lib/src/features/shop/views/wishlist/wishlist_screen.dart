import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/common_widgets/cart_cirle_widget.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/product_controller.dart';
import 'package:on_demand_grocery/src/features/shop/models/store_model.dart';
import 'package:on_demand_grocery/src/features/shop/views/product/widgets/product_item.dart';
import 'package:on_demand_grocery/src/features/shop/views/store/widgets/store_item_wiget.dart';
import 'package:on_demand_grocery/src/features/shop/views/wishlist/wishlist_bottom_appbar.dart';
import 'package:on_demand_grocery/src/routes/app_pages.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  final orderController = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 80,
            leadingWidth: 100,
            leading: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: hAppDefaultPadding),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    image: const DecorationImage(
                        image: AssetImage('assets/logos/logo.png'),
                        fit: BoxFit.fill),
                  ),
                ),
              ),
            ),
            title: const Text("Yêu thích"),
            centerTitle: true,
            actions: [
              Padding(
                padding: hAppDefaultPaddingR,
                child: CartCircle(),
              )
            ],
          ),
          body: NestedScrollView(
            headerSliverBuilder: (_, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  pinned: true,
                  floating: true,
                  expandedHeight: 100,
                  flexibleSpace: Padding(
                    padding: hAppDefaultPaddingLR,
                    child: ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                                child: Container(
                                  padding: const EdgeInsets.all(9),
                                  decoration: BoxDecoration(
                                      color: HAppColor.hWhiteColor,
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(
                                          width: 1,
                                          color: HAppColor.hGreyColorShade300)),
                                  child: Row(children: [
                                    const Icon(
                                      EvaIcons.search,
                                      size: 25,
                                    ),
                                    Expanded(
                                        child: Center(
                                      child: Text("Bạn muốn tìm gì?",
                                          style: HAppStyle.paragraph2Bold
                                              .copyWith(
                                                  color: HAppColor.hGreyColor)),
                                    ))
                                  ]),
                                ),
                                onTap: () => Get.toNamed(HAppRoutes.search)),
                            gapH12,
                          ],
                        )
                      ],
                    ),
                  ),
                  bottom: WishlistBottomAppBar(),
                )
              ];
            },
            body: TabBarView(children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    hAppDefaultPadding, 12, hAppDefaultPadding, 0),
                child: GridView.builder(
                  itemCount: orderController.isFavoritedProducts.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    mainAxisExtent: 295,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return Obx(
                      () => ProductItemWidget(
                        model: orderController.isFavoritedProducts[index],
                        storeIcon: true,
                        list: orderController.isFavoritedProducts,
                        compare: false,
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    hAppDefaultPadding, 12, hAppDefaultPadding, 0),
                child: GridView.builder(
                  itemCount: isFavoritedStore.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    mainAxisExtent: 110,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return StoreItemWidget(model: isFavoritedStore[index]);
                  },
                ),
              ),
            ]),
          ),
        ));
  }
}
