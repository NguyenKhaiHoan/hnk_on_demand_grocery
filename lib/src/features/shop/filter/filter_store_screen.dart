import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/filter_store_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/store_controller.dart';
import 'package:on_demand_grocery/src/features/shop/models/tag_model.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';

class FilterStoreScreen extends StatefulWidget {
  const FilterStoreScreen({super.key});

  @override
  State<FilterStoreScreen> createState() => _FilterStoreScreenState();
}

class _FilterStoreScreenState extends State<FilterStoreScreen> {
  final filterStoreController = Get.put(FilterStoreController());
  final storeController = Get.put(StoreController());

  late bool historySelfCategory;
  late List<Tag> historyTagsCategory;

  @override
  void initState() {
    super.initState();
    historySelfCategory = storeController.selfCategory.value;
    historyTagsCategory =
        tagsCategory.map((tag) => Tag(tag.id, tag.title, tag.active)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 80,
          centerTitle: true,
          leading: Container(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: () {
                Get.back();
                storeController.selfCategory.value = historySelfCategory;
                tagsCategory = historyTagsCategory
                    .map((tag) => Tag(tag.id, tag.title, tag.active))
                    .toList();
                checkApplied();
              },
              icon: const Icon(
                EvaIcons.close,
                size: 20,
              ),
            ),
          ),
          title: const Text(
            'Bộ lọc',
            style: HAppStyle.heading4Style,
          ),
          actions: [
            TextButton(
                onPressed: () {
                  storeController.selfCategory.value = false;
                  for (int index = 0; index < tagsCategory.length; index++) {
                    if (index == 0) {
                      tagsCategory[index].active = true;
                    } else {
                      tagsCategory[index].active = false;
                    }
                  }
                  historySelfCategory = storeController.selfCategory.value;
                  historyTagsCategory = tagsCategory
                      .map((tag) => Tag(tag.id, tag.title, tag.active))
                      .toList();
                  checkApplied();
                  setState(() {});
                },
                child: Text(
                  'Cài đặt lại',
                  style: HAppStyle.paragraph2Regular
                      .copyWith(color: HAppColor.hBluePrimaryColor),
                ))
          ]),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: hAppDefaultPadding),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Danh mục",
                style: HAppStyle.heading4Style,
              ),
              gapH10,
              Wrap(
                children: [
                  for (int index = 0; index < tagsCategory.length; index++)
                    GestureDetector(
                      child: Container(
                          margin: const EdgeInsets.only(bottom: 10, right: 5),
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: tagsCategory[index].active
                                ? HAppColor.hBluePrimaryColor
                                : HAppColor.hBackgroundColor,
                            border: Border.all(
                              color: tagsCategory[index].active
                                  ? HAppColor.hBluePrimaryColor
                                  : HAppColor.hGreyColorShade300,
                              width: 1.5,
                            ),
                          ),
                          child: Text(
                            tagsCategory[index].title,
                            style: HAppStyle.paragraph2Regular.copyWith(
                                color: tagsCategory[index].active
                                    ? HAppColor.hWhiteColor
                                    : HAppColor.hDarkColor),
                          )),
                      onTap: () {
                        if (index != 0) {
                          tagsCategory[index].active =
                              !tagsCategory[index].active;
                          if (tagsCategory[index].active == true) {
                            tagsCategory[0].active = false;
                          } else {
                            var listNoActive = tagsCategory
                                .where((tag) => tag.active == false);
                            if (listNoActive.length == tagsCategory.length) {
                              tagsCategory[0].active = true;
                            }
                          }
                        }
                        checkApplied();
                        setState(() {});
                      },
                    )
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
              storeController.selfCategory.value
                  ? Text(
                      'Lọc danh sách các cửa hàng chỉ chứa các danh mục được chọn không bao gồm các danh mục khác.',
                      style: HAppStyle.paragraph2Regular
                          .copyWith(color: HAppColor.hGreyColorShade600),
                    )
                  : Container()
            ]),
      )),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: hAppDefaultPadding, vertical: hAppDefaultPadding),
        decoration: BoxDecoration(
          color: HAppColor.hTransparentColor,
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, -15),
              blurRadius: 20,
              color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.1),
            )
          ],
        ),
        child: Obx(() => ElevatedButton(
              onPressed: () {
                if (filterStoreController.checkApplied.value) {
                  Get.back();
                  print('present: ${filterStoreController.checkApplied.value}');
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: filterStoreController.checkApplied.value
                      ? HAppColor.hBluePrimaryColor
                      : HAppColor.hGreyColorShade300,
                  fixedSize:
                      Size(HAppSize.deviceWidth - hAppDefaultPadding * 2, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50))),
              child: Text("Áp dụng",
                  style: HAppStyle.label2Bold.copyWith(
                      color: filterStoreController.checkApplied.value
                          ? HAppColor.hWhiteColor
                          : HAppColor.hDarkColor)),
            )),
      ),
    );
  }

  void checkApplied() {
    // bool sameList = true;
    // for (int index = 0; index < tagsCategory.length; index++) {
    //   if (!(tagsCategory[index].active == historyTagsCategory[index].active)) {
    //     sameList = false;
    //     break;
    //   }
    //   print(sameList);
    // }

    String tags = "Tags: ";
    String his = "His: ";

    for (int index = 0; index < tagsCategory.length; index++) {
      tags += tagsCategory[index].active.toString();
    }

    for (int index = 0; index < historyTagsCategory.length; index++) {
      his += historyTagsCategory[index].active.toString();
    }

    print(tags);
    print(his);

    if (storeController.selfCategory.value != historySelfCategory) {
      filterStoreController.checkApplied.value = true;
    } else {
      filterStoreController.checkApplied.value = false;
    }
  }
}
