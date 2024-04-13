import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/common_widgets/cart_cirle_widget.dart';
import 'package:on_demand_grocery/src/common_widgets/custom_layout_widget.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/category_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/product_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/search_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/store_controller.dart';
import 'package:on_demand_grocery/src/features/shop/models/product_model.dart';
import 'package:on_demand_grocery/src/features/shop/views/explore/widgets/list_product_explore_builder.dart';
import 'package:on_demand_grocery/src/repositories/product_repository.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';

class SearchProductInStore extends StatefulWidget {
  const SearchProductInStore({super.key});

  @override
  State<SearchProductInStore> createState() => _SearchProductInStoreState();
}

class _SearchProductInStoreState extends State<SearchProductInStore> {
  String storeId = Get.arguments['storeId'];

  final storeController = Get.put(StoreController());
  FocusNode focusNode = FocusNode();

  var searchResetToggle = false.obs;
  var displaySearch = false.obs;

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    storeController.controller.addListener(() {
      if (storeController.controller.text.isEmpty) {
        storeController.showSuffixIcon.value = false;
      } else {
        storeController.showSuffixIcon.value = true;
      }
    });
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
                  storeController.controller.clear();
                  displaySearch.value = false;
                },
                child: const Icon(
                  Icons.arrow_back_ios,
                  size: 20,
                )),
          ),
        ),
        title: const Text("Tìm kiếm"),
        centerTitle: true,
        actions: [
          Padding(
            padding: hAppDefaultPaddingR,
            child: CartCircle(),
          )
        ],
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Padding(
            padding: hAppDefaultPaddingLR,
            child: TextField(
              focusNode: focusNode,
              textAlignVertical: TextAlignVertical.center,
              onEditingComplete: () {
                FocusScope.of(context).unfocus();
                searchResetToggle.toggle();
                displaySearch.value = true;
              },
              controller: storeController.controller,
              autofocus: true,
              decoration: InputDecoration(
                  hintStyle: HAppStyle.paragraph1Bold
                      .copyWith(color: HAppColor.hGreyColor),
                  isCollapsed: true,
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(
                          width: 2, color: HAppColor.hBluePrimaryColor)),
                  contentPadding: const EdgeInsets.all(9),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                          width: 0.8, color: HAppColor.hGreyColorShade300)),
                  hintText: "Bạn muốn tìm gì?",
                  prefixIcon: const Icon(
                    EvaIcons.search,
                    size: 25,
                  ),
                  suffixIcon: Obx(
                    () => storeController.showSuffixIcon.value
                        ? IconButton(
                            onPressed: () {
                              storeController.controller.clear();
                              searchResetToggle.toggle();
                              displaySearch.value = false;
                            },
                            icon: const Icon(
                              EvaIcons.close,
                              size: 20,
                            ))
                        : Container(
                            width: 0,
                          ),
                  )),
            ),
          ),
          gapH12,
          Obx(() => !displaySearch.value ||
                  storeController.controller.text.isEmpty
              ? Container()
              : CustomLayoutWidget(
                  widget: FutureBuilder(
                    key: Key('$storeId${searchResetToggle.value.toString()}'),
                    future: ProductRepository.instance.getSearchProducts(
                        storeController.controller.text.trim(), storeId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: ShimmerListProductExploreBuilder(),
                        );
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
                        final products = snapshot.data!;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: hAppDefaultPaddingLR,
                              child: Text(
                                  'Tìm kiếm: ${storeController.controller.text.trim()}'),
                            ),
                            gapH12,
                            ListProductExploreBuilder(
                                list: products, compare: false)
                          ],
                        );
                      }
                    },
                  ),
                  subWidget: gapH24))
        ],
      )),
    );
  }
}
