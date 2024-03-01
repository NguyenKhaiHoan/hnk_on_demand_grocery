import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/common_widgets/cart_cirle_widget.dart';
import 'package:on_demand_grocery/src/common_widgets/user_image_logo.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/store_controller.dart';
import 'package:on_demand_grocery/src/features/shop/models/store_model.dart';
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
  late bool historySelfCategory;
  late List<Tag> historyTagsCategory;

  @override
  void initState() {
    super.initState();
    storeController.listFilterStore.value = listStore;
    storeController.listFilterStore.sort((a, b) => a.name.compareTo(b.name));
    storeController.tagsCategoryObs.value = tagsCategory;
    storeController.tagsStoreObs.value = tags;
    historySelfCategory = storeController.selfCategory.value;
    historyTagsCategory = storeController.tagsCategoryObs
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
                    value: storeController.selectedValueSort.value,
                    onChanged: (newValue) => setState(() {
                      storeController.selectedValueSort.value = newValue!;
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
                            title: storeController.tagsStoreObs[index].title,
                            active: storeController.tagsStoreObs[index].active,
                            onTap: () {
                              storeController.tagsStoreObs[index].active =
                                  !storeController.tagsStoreObs[index].active;
                              filterStore();
                              storeController.tagsStoreObs.refresh();
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
                      "${storeController.listFilterStore.length} Kết quả",
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
                    itemCount: storeController.listFilterStore.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                      mainAxisExtent: 200,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return StoreItemWidget(
                          model: storeController.listFilterStore[index]);
                    },
                  )),
              gapH24,
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
                              storeController.selfCategory.value = false;
                              for (int index = 0;
                                  index <
                                      storeController.tagsCategoryObs.length;
                                  index++) {
                                storeController.tagsCategoryObs[index].active =
                                    false;
                              }
                              storeController.tagsCategoryObs.refresh();
                              historySelfCategory =
                                  storeController.selfCategory.value;
                              historyTagsCategory = storeController
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
                            index < storeController.tagsCategoryObs.length;
                            index++)
                          Obx(() => GestureDetector(
                                child: Container(
                                    margin: const EdgeInsets.only(
                                        bottom: 10, right: 5),
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: storeController
                                              .tagsCategoryObs[index].active
                                          ? HAppColor.hBluePrimaryColor
                                          : HAppColor.hBackgroundColor,
                                      border: Border.all(
                                        color: storeController
                                                .tagsCategoryObs[index].active
                                            ? HAppColor.hBluePrimaryColor
                                            : HAppColor.hGreyColorShade300,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Text(
                                      storeController
                                          .tagsCategoryObs[index].title,
                                      style: HAppStyle.paragraph2Regular
                                          .copyWith(
                                              color: storeController
                                                      .tagsCategoryObs[index]
                                                      .active
                                                  ? HAppColor.hWhiteColor
                                                  : HAppColor.hDarkColor),
                                    )),
                                onTap: () {
                                  storeController
                                          .tagsCategoryObs[index].active =
                                      !storeController
                                          .tagsCategoryObs[index].active;
                                  storeController.tagsCategoryObs.refresh();
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
                        value: storeController.selfCategory.value,
                        onChanged: (changed) {
                          storeController.selfCategory.value = changed;
                          checkApplied();
                        })),
                    Obx(() => storeController.selfCategory.value
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
                            if (storeController.checkApplied.value) {
                              historySelfCategory =
                                  storeController.selfCategory.value;
                              historyTagsCategory = storeController
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
                                  storeController.checkApplied.value
                                      ? HAppColor.hBluePrimaryColor
                                      : HAppColor.hGreyColorShade300,
                              fixedSize: Size(
                                  HAppSize.deviceWidth - hAppDefaultPadding * 2,
                                  50),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50))),
                          child: Text("Áp dụng",
                              style: HAppStyle.label2Bold.copyWith(
                                  color: storeController.checkApplied.value
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
        storeController.selfCategory.value = historySelfCategory;
        storeController.tagsCategoryObs.value = historyTagsCategory
            .map((tag) => Tag(tag.id, tag.title, tag.active))
            .toList();
        storeController.tagsCategoryObs.refresh();
      }
    });
  }

  void checkApplied() {
    bool sameList = true;

    for (int index = 0;
        index < storeController.tagsCategoryObs.length;
        index++) {
      if (storeController.tagsCategoryObs[index].active !=
          historyTagsCategory[index].active) {
        sameList = false;
        break;
      }
    }

    if (storeController.selfCategory.value != historySelfCategory ||
        sameList == false) {
      storeController.checkApplied.value = true;
    } else {
      storeController.checkApplied.value = false;
    }
  }

  void filterStore() {
    if (!storeController.selfCategory.value) {
      storeController.listFilterStore.value = listStore
          .where((store) => storeController.tagsCategoryObs.every((category) =>
              category.active ? store.category.contains(category.title) : true))
          .where((store) =>
              (tags[0].active ? store.distance < 5.0 : true) &&
              (tags[1].active ? store.isFamous : true) &&
              (tags[2].active ? store.rating >= 4.0 : true) &&
              (tags[3].active ? store.import : true))
          .toList();
      filterStoreSort();
    } else {
      storeController.listFilterStore.value = listStore
          .where((store) =>
              storeController.tagsCategoryObs
                      .where((category) => category.active)
                      .length ==
                  store.category.length &&
              storeController.tagsCategoryObs.every((category) =>
                  category.active
                      ? store.category.contains(category.title)
                      : true))
          .where((store) =>
              (tags[0].active ? store.distance < 5.0 : true) &&
              (tags[1].active ? store.isFamous : true) &&
              (tags[2].active ? store.rating >= 4.0 : true) &&
              (tags[3].active ? store.import : true))
          .toList();
      filterStoreSort();
    }
  }

  void filterStoreSort() {
    if (storeController.selectedValueSort.value == 'A - Z') {
      storeController.listFilterStore.sort((a, b) => a.name.compareTo(b.name));
    } else if (storeController.selectedValueSort.value == 'Z - A') {
      storeController.listFilterStore.sort((a, b) => -a.name.compareTo(b.name));
    } else if (storeController.selectedValueSort.value == 'Gần - Xa') {
      storeController.listFilterStore
          .sort((a, b) => a.distance.compareTo(b.distance));
    } else if (storeController.selectedValueSort.value == 'Xa - Gần') {
      storeController.listFilterStore
          .sort((a, b) => -a.distance.compareTo(b.distance));
    }
  }
}
