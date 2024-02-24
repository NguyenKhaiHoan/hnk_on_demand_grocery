import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/explore_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/product_controller.dart';
import 'package:on_demand_grocery/src/features/shop/models/product_models.dart';
import 'package:on_demand_grocery/src/features/shop/models/tag_model.dart';
import 'package:on_demand_grocery/src/features/shop/views/home/widgets/custom_chip_widget.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';

class ExploreBottomAppBar extends StatefulWidget
    implements PreferredSizeWidget {
  const ExploreBottomAppBar({super.key});

  @override
  State<ExploreBottomAppBar> createState() => _ExploreBottomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(114);
}

class _ExploreBottomAppBarState extends State<ExploreBottomAppBar> {
  final exploreController = Get.put(ExploreController());

  // final productController = Get.put(StoreController());
  final productController = Get.put(ProductController());

  final itemsSort = ['Nổi bật', 'Thấp - Cao', 'Cao - Thấp'];

  late bool historySelfCategory;
  late List<Tag> historyTagsCategory;

  @override
  void initState() {
    super.initState();
    productController.tagsCategoryObs.value = tagsCategory;
    productController.tagsProductObs.value = tagsProduct;
    historySelfCategory = productController.selfCategory.value;
    historyTagsCategory = productController.tagsCategoryObs
        .map((tag) => Tag(tag.id, tag.title, tag.active))
        .toList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: HAppColor.hBackgroundColor,
        child: Column(
          children: [
            TabBar(
                physics: const NeverScrollableScrollPhysics(),
                tabAlignment: TabAlignment.start,
                padding: EdgeInsets.zero,
                controller: exploreController.tabController,
                labelStyle: HAppStyle.label3Bold,
                isScrollable: true,
                indicatorColor: HAppColor.hBluePrimaryColor,
                labelColor: HAppColor.hBluePrimaryColor,
                unselectedLabelColor: Colors.black,
                tabs: const [
                  Tab(
                    text: 'Bán chạy',
                  ),
                  Tab(
                    text: 'Giảm giá',
                  ),
                  Tab(
                    text: 'Trái cây',
                  ),
                  Tab(
                    text: 'Rau củ',
                  ),
                  Tab(
                    text: 'Thịt',
                  ),
                  Tab(
                    text: 'Hải sản',
                  ),
                  Tab(
                    text: 'Trứng',
                  ),
                  Tab(
                    text: 'Sữa',
                  ),
                  Tab(
                    text: 'Gia vị',
                  ),
                  Tab(
                    text: 'Hạt',
                  ),
                  Tab(
                    text: 'Bánh mỳ',
                  ),
                  Tab(
                    text: 'Đồ uống',
                  ),
                  Tab(
                    text: 'Ăn vặt',
                  ),
                  Tab(
                    text: 'Mỳ & Gạo',
                  ),
                ]),
            gapH12,
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  hAppDefaultPadding, 0, hAppDefaultPadding, 12),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => _showModalBottomSheet(context),
                      child: Container(
                        height: 42,
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: HAppColor.hGreyColorShade300,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(children: [
                          const Text('Danh mục'),
                          gapW2,
                          Icon(
                            Icons.arrow_drop_down,
                            color: HAppColor.hGreyColor.shade700,
                          )
                        ]),
                      ),
                    ),
                    gapW10,
                    Container(
                      height: 42,
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: HAppColor.hGreyColorShade300,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(10)),
                      child: DropdownButton<String>(
                        padding: EdgeInsets.zero,
                        value: productController.selectedValueSort.value,
                        onChanged: (newValue) => setState(() {
                          productController.selectedValueSort.value = newValue!;
                          productController.filterProductSort();
                        }),
                        items: itemsSort
                            .map<DropdownMenuItem<String>>(
                                (String value) => DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    ))
                            .toList(),
                        underline: const SizedBox(),
                      ),
                    ),
                    gapW10,
                    SizedBox(
                      height: 42,
                      child: ListView.separated(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Obx(() => CustomChipWidget(
                                title: productController
                                    .tagsProductObs[index].title,
                                active: productController
                                    .tagsProductObs[index].active,
                                onTap: () {}));
                          },
                          separatorBuilder: (_, __) => gapW10,
                          itemCount: productController.tagsProductObs.length),
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }

  void _showModalBottomSheet(BuildContext context) {
    bool check = false;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
      ),
      backgroundColor: HAppColor.hBackgroundColor,
      builder: (BuildContext context) {
        return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: hAppDefaultPadding, vertical: hAppDefaultPadding),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Danh mục",
                          style: HAppStyle.heading4Style,
                        ),
                        GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: Text(
                              'Xóa tất cả',
                              style: HAppStyle.paragraph2Regular
                                  .copyWith(color: HAppColor.hBluePrimaryColor),
                            ))
                      ],
                    ),
                    Divider(
                      color: HAppColor.hGreyColorShade300,
                    ),
                    gapH12,
                    Wrap(
                      children: [
                        for (int index = 0;
                            index < productController.tagsCategoryObs.length;
                            index++)
                          Obx(() => GestureDetector(
                                child: Container(
                                    margin: const EdgeInsets.only(
                                        bottom: 10, right: 5),
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: productController
                                              .tagsCategoryObs[index].active
                                          ? HAppColor.hBluePrimaryColor
                                          : HAppColor.hBackgroundColor,
                                      border: Border.all(
                                        color: productController
                                                .tagsCategoryObs[index].active
                                            ? HAppColor.hBluePrimaryColor
                                            : HAppColor.hGreyColorShade300,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Text(
                                      productController
                                          .tagsCategoryObs[index].title,
                                      style: HAppStyle.paragraph2Regular
                                          .copyWith(
                                              color: productController
                                                      .tagsCategoryObs[index]
                                                      .active
                                                  ? HAppColor.hWhiteColor
                                                  : HAppColor.hDarkColor),
                                    )),
                                onTap: () {
                                  productController
                                          .tagsCategoryObs[index].active =
                                      !productController
                                          .tagsCategoryObs[index].active;
                                  productController.tagsCategoryObs.refresh();
                                },
                              ))
                      ],
                    ),
                    Obx(() => SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text(
                          'Chỉ chứa danh mục',
                          style: HAppStyle.paragraph1Regular,
                        ),
                        trackOutlineColor: MaterialStateProperty.resolveWith(
                          (final Set<MaterialState> states) {
                            if (states.contains(MaterialState.selected)) {
                              return null;
                            }
                            return HAppColor.hGreyColorShade300;
                          },
                        ),
                        activeColor: HAppColor.hBluePrimaryColor,
                        activeTrackColor: HAppColor.hBlueSecondaryColor,
                        inactiveThumbColor: HAppColor.hWhiteColor,
                        inactiveTrackColor: HAppColor.hGreyColorShade300,
                        value: productController.selfCategory.value,
                        onChanged: (changed) {
                          productController.selfCategory.value = changed;
                        })),
                    Obx(() => productController.selfCategory.value
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Text(
                              'Lọc danh sách các cửa hàng chỉ chứa các danh mục được chọn không bao gồm các danh mục khác.',
                              style: HAppStyle.paragraph2Regular.copyWith(
                                  color: HAppColor.hGreyColorShade600),
                            ),
                          )
                        : Container()),
                    Obx(() => ElevatedButton(
                          onPressed: () {
                            Get.back();
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  productController.checkApplied.value
                                      ? HAppColor.hBluePrimaryColor
                                      : HAppColor.hGreyColorShade300,
                              fixedSize: Size(
                                  HAppSize.deviceWidth - hAppDefaultPadding * 2,
                                  50),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50))),
                          child: Text("Áp dụng",
                              style: HAppStyle.label2Bold.copyWith(
                                  color: productController.checkApplied.value
                                      ? HAppColor.hWhiteColor
                                      : HAppColor.hDarkColor)),
                        )),
                  ]),
            );
          },
        );
      },
    ).then((value) {
      if (!check) {}
    });
  }
}
