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
import 'package:on_demand_grocery/src/features/shop/models/store_model.dart';
import 'package:on_demand_grocery/src/features/shop/views/explore/widgets/list_product_explore_builder.dart';
import 'package:on_demand_grocery/src/features/shop/views/root/gesture_detector_screen.dart';

class ShowMoreProductInStore extends StatefulWidget {
  const ShowMoreProductInStore({super.key});

  @override
  State<ShowMoreProductInStore> createState() => _ShowMoreProductInStoreState();
}

class _ShowMoreProductInStoreState extends State<ShowMoreProductInStore> {
  int categoryId = Get.arguments['id'];
  StoreModel store = Get.arguments['store'];

  @override
  Widget build(BuildContext context) {
    return GestureDetectorScreen(
        screen: Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        leading: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: hAppDefaultPaddingL,
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
        title: Text(
          store.name,
          overflow: TextOverflow.ellipsis,
        ),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: hAppDefaultPaddingLR,
            child: Text(
                'Danh mục: ${categoryId == 0 ? 'Bán chạy' : categoryId == 1 ? 'Giảm giá' : CategoryController.instance.listOfCategory[categoryId].name}'),
          ),
          gapH12,
          CustomLayoutWidget(
              widget: FutureBuilder(
                future: ProductController.instance.fetchProductsByQuery(
                    StoreController.instance
                        .getProductCategoryForStore(categoryId),
                    store.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: ShimmerListProductExploreBuilder(),
                    );
                  }

                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Đã xảy ra sự cố. Xin vui lòng thử lại sau.'),
                    );
                  }

                  if (!snapshot.hasData ||
                      snapshot.data == null ||
                      snapshot.data!.isEmpty) {
                    return gapH12;
                  } else {
                    final products = snapshot.data!;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: ListProductExploreBuilder(
                          list: products, compare: false),
                    );
                  }
                },
              ),
              subWidget: gapH24)
        ],
      )),
    ));
  }
}
