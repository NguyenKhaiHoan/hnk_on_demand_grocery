import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/common_widgets/cart_cirle_widget.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/base/views/explore/explore_bottom_appbar.dart';
import 'package:on_demand_grocery/src/features/base/views/wishlist/wishlist_bottom_appbar.dart';
import 'package:on_demand_grocery/src/features/product/models/product_models.dart';
import 'package:on_demand_grocery/src/features/product/views/widgets/product_item.dart';
import 'package:on_demand_grocery/src/features/search/controller/search_controller.dart';
import 'package:on_demand_grocery/src/features/store/models/store_model.dart';
import 'package:on_demand_grocery/src/features/store/views/widgets/store_item_wiget.dart';
import 'package:on_demand_grocery/src/routes/app_pages.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
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
            actions: const [
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
                  bottom: const WishlistBottomAppBar(),
                )
              ];
            },
            body: TabBarView(children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    hAppDefaultPadding, 12, hAppDefaultPadding, 12),
                child: GridView.builder(
                  itemCount: isFavoritedProduct.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    mainAxisExtent: 288,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return ProductItemWidget(
                        model: isFavoritedProduct[index], storeIcon: true);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    hAppDefaultPadding, 12, hAppDefaultPadding, 12),
                child: GridView.builder(
                  itemCount: isFavoritedStore.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    mainAxisExtent: 100,
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
