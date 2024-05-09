import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/common_widgets/cart_cirle_widget.dart';
import 'package:on_demand_grocery/src/common_widgets/user_image_logo.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/all_store_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/category_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/store_controller.dart';
import 'package:on_demand_grocery/src/features/shop/models/tag_model.dart';
import 'package:on_demand_grocery/src/features/shop/views/home/widgets/custom_chip_widget.dart';
import 'package:on_demand_grocery/src/features/shop/views/store/widgets/store_item_wiget.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';

class AllStoreScreen extends StatefulWidget {
  const AllStoreScreen({super.key});

  @override
  State<AllStoreScreen> createState() => _AllStoreScreenState();
}

class _AllStoreScreenState extends State<AllStoreScreen>
    with AutomaticKeepAliveClientMixin<AllStoreScreen> {
  @override
  bool get wantKeepAlive => true;

  final itemsSort = ['A - Z', 'Z - A', 'Gần - Xa', 'Xa - Gần'];

  final storeController = Get.put(StoreController());
  final allStoreController = AllStoreController.instance;

  final categoryController = CategoryController.instance;

  late bool historySelfCategory;
  late List<Tag> historyTagsCategory;

  @override
  void initState() {
    super.initState();
    allStoreController.listFilterStore.value = storeController.listOfStore;
    allStoreController.listFilterStore.sort((a, b) => a.name.compareTo(b.name));
    allStoreController.tagsCategoryObs.value = categoryController.tagsCategory;
    allStoreController.tagsStoreObs.value = tags;
    historySelfCategory = allStoreController.selfCategory.value;
    historyTagsCategory = allStoreController.tagsCategoryObs
        .map((tag) => Tag(tag.id, tag.title, tag.active))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tất cả cửa hàng tại Hà Nội"),
        centerTitle: true,
        toolbarHeight: 80,
        leadingWidth: 64,
        leading: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: hAppDefaultPadding),
            child: UserImageLogoWidget(
              size: 40,
              hasFunction: true,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: hAppDefaultPaddingR,
            child: CartCircle(),
          )
        ],
      ),
      body: Container(
        padding: hAppDefaultPaddingLR,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SingleChildScrollView(
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
                    value: allStoreController.selectedValueSort.value,
                    onChanged: (newValue) => setState(() {
                      allStoreController.selectedValueSort.value = newValue!;
                      filterStoreSort();
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
                            title: allStoreController.tagsStoreObs[index].title,
                            active:
                                allStoreController.tagsStoreObs[index].active,
                            onTap: () {
                              allStoreController.tagsStoreObs[index].active =
                                  !allStoreController
                                      .tagsStoreObs[index].active;
                              filterStore();
                              allStoreController.tagsStoreObs.refresh();
                            }));
                      },
                      separatorBuilder: (_, __) => gapW10,
                      itemCount: tags.length),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Cửa hàng",
                  style: HAppStyle.heading4Style,
                ),
                Obx(() => Text(
                      "${allStoreController.listFilterStore.length} Kết quả",
                      style: HAppStyle.paragraph3Regular
                          .copyWith(color: HAppColor.hGreyColorShade600),
                    )),
              ],
            ),
          ),
          Expanded(
              child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(children: [
              Obx(() => GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: allStoreController.listFilterStore.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                      mainAxisExtent: 150,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return StoreItemWidget(
                          model: allStoreController.listFilterStore[index]);
                    },
                  )),
              gapH40,
              gapH40,
            ]),
          ))
        ]),
      ),
    );
  }

  void _showModalBottomSheet(BuildContext context) {
    bool check = false;
    checkApplied();
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
                              allStoreController.selfCategory.value = false;
                              for (int index = 0;
                                  index <
                                      allStoreController.tagsCategoryObs.length;
                                  index++) {
                                allStoreController
                                    .tagsCategoryObs[index].active = false;
                              }
                              allStoreController.tagsCategoryObs.refresh();
                              historySelfCategory =
                                  allStoreController.selfCategory.value;
                              historyTagsCategory = allStoreController
                                  .tagsCategoryObs
                                  .map((tag) =>
                                      Tag(tag.id, tag.title, tag.active))
                                  .toList();
                              checkApplied();
                              Get.back();
                              filterStore();
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
                            index < allStoreController.tagsCategoryObs.length;
                            index++)
                          Obx(() => GestureDetector(
                                child: Container(
                                    margin: const EdgeInsets.only(
                                        bottom: 10, right: 5),
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: allStoreController
                                              .tagsCategoryObs[index].active
                                          ? HAppColor.hBluePrimaryColor
                                          : HAppColor.hBackgroundColor,
                                      border: Border.all(
                                        color: allStoreController
                                                .tagsCategoryObs[index].active
                                            ? HAppColor.hBluePrimaryColor
                                            : HAppColor.hGreyColorShade300,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Text(
                                      allStoreController
                                          .tagsCategoryObs[index].title,
                                      style: HAppStyle.paragraph2Regular
                                          .copyWith(
                                              color: allStoreController
                                                      .tagsCategoryObs[index]
                                                      .active
                                                  ? HAppColor.hWhiteColor
                                                  : HAppColor.hDarkColor),
                                    )),
                                onTap: () {
                                  allStoreController
                                          .tagsCategoryObs[index].active =
                                      !allStoreController
                                          .tagsCategoryObs[index].active;
                                  allStoreController.tagsCategoryObs.refresh();
                                  checkApplied();
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
                        value: allStoreController.selfCategory.value,
                        onChanged: (changed) {
                          allStoreController.selfCategory.value = changed;
                          checkApplied();
                        })),
                    Obx(() => allStoreController.selfCategory.value
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
                            check = true;
                            if (allStoreController.checkApplied.value) {
                              historySelfCategory =
                                  allStoreController.selfCategory.value;
                              historyTagsCategory = allStoreController
                                  .tagsCategoryObs
                                  .map((tag) =>
                                      Tag(tag.id, tag.title, tag.active))
                                  .toList();
                              filterStore();
                              Get.back();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  allStoreController.checkApplied.value
                                      ? HAppColor.hBluePrimaryColor
                                      : HAppColor.hGreyColorShade300,
                              fixedSize: Size(
                                  HAppSize.deviceWidth - hAppDefaultPadding * 2,
                                  50),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50))),
                          child: Text("Áp dụng",
                              style: HAppStyle.label2Bold.copyWith(
                                  color: allStoreController.checkApplied.value
                                      ? HAppColor.hWhiteColor
                                      : HAppColor.hDarkColor)),
                        )),
                  ]),
            );
          },
        );
      },
    ).then((value) {
      if (!check) {
        allStoreController.selfCategory.value = historySelfCategory;
        allStoreController.tagsCategoryObs.value = historyTagsCategory
            .map((tag) => Tag(tag.id, tag.title, tag.active))
            .toList();
        allStoreController.tagsCategoryObs.refresh();
      }
    });
  }

  void checkApplied() {
    bool sameList = true;

    for (int index = 0;
        index < allStoreController.tagsCategoryObs.length;
        index++) {
      if (allStoreController.tagsCategoryObs[index].active !=
          historyTagsCategory[index].active) {
        sameList = false;
        break;
      }
    }

    if (allStoreController.selfCategory.value != historySelfCategory ||
        sameList == false) {
      allStoreController.checkApplied.value = true;
    } else {
      allStoreController.checkApplied.value = false;
    }
  }

  void filterStore() {
    if (!allStoreController.selfCategory.value) {
      allStoreController.listFilterStore.value = storeController.listOfStore
          .where((store) => allStoreController.tagsCategoryObs.every(
              (category) => category.active
                  ? store.listOfCategoryId.contains(category.id.toString())
                  : true))
          .where((store) =>
              (tags[0].active ? true : true) &&
              (tags[1].active ? store.isFamous : true) &&
              (tags[2].active ? store.rating >= 4.0 : true) &&
              (tags[3].active ? store.import : true))
          .toList();
      filterStoreSort();
    } else {
      allStoreController.listFilterStore.value = storeController.listOfStore
          .where((store) =>
              allStoreController.tagsCategoryObs
                      .where((category) => category.active)
                      .length ==
                  store.listOfCategoryId.length &&
              allStoreController.tagsCategoryObs.every((category) =>
                  category.active
                      ? store.listOfCategoryId.contains(category.title)
                      : true))
          .where((store) =>
              (tags[0].active ? true : true) &&
              (tags[1].active ? store.isFamous : true) &&
              (tags[2].active ? store.rating >= 4.0 : true) &&
              (tags[3].active ? store.import : true))
          .toList();
      filterStoreSort();
    }
  }

  void filterStoreSort() {
    if (allStoreController.selectedValueSort.value == 'A - Z') {
      allStoreController.listFilterStore
          .sort((a, b) => a.name.compareTo(b.name));
    } else if (allStoreController.selectedValueSort.value == 'Z - A') {
      allStoreController.listFilterStore
          .sort((a, b) => -a.name.compareTo(b.name));
    } else if (allStoreController.selectedValueSort.value == 'Gần - Xa') {
      allStoreController.listFilterStore.sort((a, b) => storeController
          .convertStoreModelToStoreLocationModel(a.id)
          .distance
          .compareTo(storeController
              .convertStoreModelToStoreLocationModel(b.id)
              .distance));
    } else if (allStoreController.selectedValueSort.value == 'Xa - Gần') {
      allStoreController.listFilterStore.sort((a, b) => -storeController
          .convertStoreModelToStoreLocationModel(a.id)
          .distance
          .compareTo(storeController
              .convertStoreModelToStoreLocationModel(b.id)
              .distance));
    }
  }
}
