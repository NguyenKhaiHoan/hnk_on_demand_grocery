import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/category_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/explore_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/product_controller.dart';
import 'package:on_demand_grocery/src/features/shop/models/product_model.dart';
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

class _ExploreBottomAppBarState extends State<ExploreBottomAppBar>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    exploreController.tabController.addListener(() {
      if (exploreController.tabController.previousIndex !=
              exploreController.tabController.index &&
          !exploreController.tabController.indexIsChanging) {
        exploreController.refreshData.toggle();
      }
    });
  }

  List<Tab> get _tabs {
    var list = [
      for (var i = 0; i < categoryController.listOfCategory.length + 2; i += 1)
        i
    ];
    List<Tab> tabs = list
        .map((i) => Tab(
              text: i == 0
                  ? 'Bán chạy'
                  : i == 1
                      ? 'Giảm giá'
                      : categoryController.listOfCategory[i - 2].name,
            ))
        .toList();
    return tabs;
  }

  final exploreController = ExploreController.instance;
  final productController = ProductController.instance;
  final categoryController = CategoryController.instance;

  final itemsSort = ['Mới nhất', 'A - Z', 'Z - A', 'Thấp - Cao', 'Cao - Thấp'];

  scrollControllerListener() {
    if (exploreController.scrollController.offset >= 100) {
      exploreController.showFab.value = true;
    } else {
      exploreController.showFab.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: HAppColor.hBackgroundColor,
        child: Column(
          children: [
            Obx(() => TabBar(
                tabAlignment: TabAlignment.start,
                padding: EdgeInsets.zero,
                controller: exploreController.tabController,
                labelStyle: HAppStyle.label3Bold,
                isScrollable: true,
                indicatorColor: HAppColor.hBluePrimaryColor,
                labelColor: HAppColor.hBluePrimaryColor,
                unselectedLabelColor: Colors.black,
                tabs: _tabs)),
            gapH12,
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  hAppDefaultPadding, 0, hAppDefaultPadding, 12),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Container(
                      height: 42,
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: HAppColor.hGreyColorShade300,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(10)),
                      child: Obx(() => DropdownButton<String>(
                            padding: EdgeInsets.zero,
                            value: productController.selectedValueSort.value,
                            style: HAppStyle.paragraph2Regular,
                            onChanged: (newValue) {
                              productController.selectedValueSort.value =
                                  newValue!;
                              exploreController.refreshData.toggle();
                            },
                            items: itemsSort
                                .map<DropdownMenuItem<String>>(
                                    (String value) => DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        ))
                                .toList(),
                            underline: const SizedBox(),
                          )),
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
                                onTap: () {
                                  productController
                                          .tagsProductObs[index].active =
                                      !productController
                                          .tagsProductObs[index].active;
                                  productController.tagsProductObs.refresh();
                                  exploreController.refreshData.toggle();
                                }));
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

  // void _showModalBottomSheet(BuildContext context) {
  //   bool check = false;
  //   checkApplied();
  //   showModalBottomSheet(
  //     context: context,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
  //     ),
  //     backgroundColor: HAppColor.hBackgroundColor,
  //     builder: (BuildContext context) {
  //       return LayoutBuilder(
  //         builder: (BuildContext context, BoxConstraints constraints) {
  //           return Padding(
  //             padding: const EdgeInsets.symmetric(
  //                 horizontal: hAppDefaultPadding, vertical: hAppDefaultPadding),
  //             child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       const Text(
  //                         "Danh mục",
  //                         style: HAppStyle.heading4Style,
  //                       ),
  //                       GestureDetector(
  //                           onTap: () {
  //                             for (int index = 0;
  //                                 index <
  //                                     productController.tagsCategoryObs.length;
  //                                 index++) {
  //                               productController
  //                                   .tagsCategoryObs[index].active = false;
  //                             }
  //                             productController.tagsCategoryObs.refresh();
  //                             historyTagsCategory = productController
  //                                 .tagsCategoryObs
  //                                 .map((tag) =>
  //                                     Tag(tag.id, tag.title, tag.active))
  //                                 .toList();
  //                             checkApplied();
  //                             Get.back();
  //                             load();
  //                           },
  //                           child: Text(
  //                             'Xóa danh mục',
  //                             style: HAppStyle.paragraph2Regular
  //                                 .copyWith(color: HAppColor.hBluePrimaryColor),
  //                           ))
  //                     ],
  //                   ),
  //                   Divider(
  //                     color: HAppColor.hGreyColorShade300,
  //                   ),
  //                   gapH6,
  //                   Wrap(
  //                     children: [
  //                       for (int index = 0;
  //                           index < productController.tagsCategoryObs.length;
  //                           index++)
  //                         Obx(() => GestureDetector(
  //                               child: Container(
  //                                   margin: const EdgeInsets.only(
  //                                       bottom: 10, right: 5),
  //                                   padding:
  //                                       const EdgeInsets.fromLTRB(10, 5, 10, 5),
  //                                   decoration: BoxDecoration(
  //                                     shape: BoxShape.circle,
  //                                     color: productController
  //                                             .tagsCategoryObs[index].active
  //                                         ? HAppColor.hBluePrimaryColor
  //                                         : HAppColor.hBackgroundColor,
  //                                     border: Border.all(
  //                                       color: productController
  //                                               .tagsCategoryObs[index].active
  //                                           ? HAppColor.hBluePrimaryColor
  //                                           : HAppColor.hGreyColorShade300,
  //                                       width: 1.5,
  //                                     ),
  //                                   ),
  //                                   child: Text(
  //                                     productController
  //                                         .tagsCategoryObs[index].title,
  //                                     style: HAppStyle.paragraph2Regular
  //                                         .copyWith(
  //                                             color: productController
  //                                                     .tagsCategoryObs[index]
  //                                                     .active
  //                                                 ? HAppColor.hWhiteColor
  //                                                 : HAppColor.hDarkColor),
  //                                   )),
  //                               onTap: () {
  //                                 if (!productController
  //                                     .tagsCategoryObs[index].active) {
  //                                   for (int i = 0;
  //                                       i <
  //                                           productController
  //                                               .tagsCategoryObs.length;
  //                                       i++) {
  //                                     if (i != index) {
  //                                       productController
  //                                           .tagsCategoryObs[i].active = false;
  //                                     }
  //                                   }
  //                                   productController
  //                                       .tagsCategoryObs[index].active = true;
  //                                 } else {
  //                                   productController
  //                                           .tagsCategoryObs[index].active =
  //                                       !productController
  //                                           .tagsCategoryObs[index].active;
  //                                 }
  //                                 productController.tagsCategoryObs.refresh();
  //                                 checkApplied();
  //                               },
  //                             ))
  //                     ],
  //                   ),
  //                   Obx(() => ElevatedButton(
  //                         onPressed: () {
  //                           check = true;
  //                           if (productController.checkApplied.value) {
  //                             historyTagsCategory = productController
  //                                 .tagsCategoryObs
  //                                 .map((tag) =>
  //                                     Tag(tag.id, tag.title, tag.active))
  //                                 .toList();
  //                             load();
  //                             Get.back();
  //                           }
  //                         },
  //                         style: ElevatedButton.styleFrom(
  //                             backgroundColor:
  //                                 productController.checkApplied.value
  //                                     ? HAppColor.hBluePrimaryColor
  //                                     : HAppColor.hGreyColorShade300,
  //                             fixedSize: Size(
  //                                 HAppSize.deviceWidth - hAppDefaultPadding * 2,
  //                                 50),
  //                             shape: RoundedRectangleBorder(
  //                                 borderRadius: BorderRadius.circular(50))),
  //                         child: Text("Áp dụng",
  //                             style: HAppStyle.label2Bold.copyWith(
  //                                 color: productController.checkApplied.value
  //                                     ? HAppColor.hWhiteColor
  //                                     : HAppColor.hDarkColor)),
  //                       )),
  //                 ]),
  //           );
  //         },
  //       );
  //     },
  //   ).then((value) {
  //     if (!check) {
  //       productController.tagsCategoryObs.value = historyTagsCategory
  //           .map((tag) => Tag(tag.id, tag.title, tag.active))
  //           .toList();
  //       productController.tagsCategoryObs.refresh();
  //     }
  //   });
  // }

  // void checkApplied() {
  //   bool sameList = true;

  //   for (int index = 0;
  //       index < productController.tagsCategoryObs.length;
  //       index++) {
  //     if (productController.tagsCategoryObs[index].active !=
  //         historyTagsCategory[index].active) {
  //       sameList = false;
  //       break;
  //     }
  //   }
  //   if (sameList == false) {
  //     productController.checkApplied.value = true;
  //   } else {
  //     productController.checkApplied.value = false;
  //   }
  // }
}
