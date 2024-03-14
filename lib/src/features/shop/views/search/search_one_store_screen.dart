import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/common_widgets/cart_cirle_widget.dart';
import 'package:on_demand_grocery/src/common_widgets/custom_layout_widget.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/search_controller.dart';
import 'package:on_demand_grocery/src/features/shop/models/product_models.dart';
import 'package:on_demand_grocery/src/features/shop/views/explore/widgets/list_product_explore_builder.dart';

class SearchOneStoreScreen extends StatefulWidget {
  const SearchOneStoreScreen({super.key});

  @override
  State<SearchOneStoreScreen> createState() => _SearchOneStoreScreenState();
}

class _SearchOneStoreScreenState extends State<SearchOneStoreScreen> {
  List<ProductModel> list = Get.arguments['list'];
  String nameStore = Get.arguments['nameStore'];

  final searchController = Get.put(SearchProductController());

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
        title: Text(nameStore),
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
            child: Text('Tìm kiếm: ${searchController.controller.text}'),
          ),
          CustomLayoutWidget(
              widget: ListProductExploreBuilder(list: list, compare: false),
              subWidget: Container())
        ],
      )),
    );
  }
}
