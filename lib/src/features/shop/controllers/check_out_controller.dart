
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';

import 'package:on_demand_grocery/src/features/shop/views/order/widgets/type_button.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';

class CheckoutController extends GetxController {
  static CheckoutController get instance => Get.find();

  @override
  void onInit() {
    getAvailableTimeSlots();
    super.onInit();
  }

  List<String> days = ["Th 2", "Th 3", "Th 4", "Th 5", "Th 6", "Th 7", "CN"];

  List<String> days2 = [
    "Thứ 2",
    "Thứ 3",
    "Thứ 4",
    "Thứ 5",
    "Thứ 6",
    "Thứ 7",
    "Chủ nhật"
  ];

  ScrollController scrollController = ScrollController();

  var currentDateSelectedIndex = 0.obs;
  var selectedDate = DateTime.now().add(const Duration(days: 0)).obs;
  var date =
      DateFormat('EEEE, d-M-y', 'vi').format(DateTime.now()).toString().obs;

  void resetDate() {
    currentDateSelectedIndex = 0.obs;
    selectedDate = DateTime.now().add(const Duration(days: 0)).obs;
    date =
        DateFormat('EEEE, d-M-y', 'vi').format(DateTime.now()).toString().obs;
  }

  void showModalBottomSheetDay(BuildContext context) {
    showModalBottomSheet(
        context: context,
        useRootNavigator: true,
        isScrollControlled: true,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.symmetric(
                vertical: hAppDefaultPadding, horizontal: hAppDefaultPadding),
            decoration: const BoxDecoration(
                color: HAppColor.hBackgroundColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10))),
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Chọn ngày giao hàng",
                          style: HAppStyle.heading4Style,
                        ),
                        GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: const Icon(EvaIcons.close))
                      ],
                    ),
                    gapH12,
                    SizedBox(
                        height: 60,
                        child: ListView.separated(
                          separatorBuilder: (BuildContext context, int index) {
                            return gapW10;
                          },
                          itemCount: 7,
                          controller: scrollController,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                currentDateSelectedIndex.value = index;
                                selectedDate.value =
                                    DateTime.now().add(Duration(days: index));
                                date.value =
                                    '${days2[selectedDate.value.weekday - 1]}, ${selectedDate.value.day}-${selectedDate.value.year}';

                                getAvailableTimeSlots();
                              },
                              child: Obx(
                                () => Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: currentDateSelectedIndex.value ==
                                              index
                                          ? HAppColor.hBluePrimaryColor
                                          : HAppColor.hWhiteColor),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                          days[DateTime.now()
                                                      .add(
                                                          Duration(days: index))
                                                      .weekday -
                                                  1]
                                              .toString(),
                                          style: HAppStyle.paragraph2Bold
                                              .copyWith(
                                                  color: currentDateSelectedIndex
                                                              .value ==
                                                          index
                                                      ? HAppColor.hWhiteColor
                                                      : HAppColor
                                                          .hGreyColorShade600)),
                                      Text(
                                          DateTime.now()
                                              .add(Duration(days: index))
                                              .day
                                              .toString(),
                                          style: HAppStyle.heading4Style
                                              .copyWith(
                                                  color: currentDateSelectedIndex
                                                              .value ==
                                                          index
                                                      ? HAppColor.hWhiteColor
                                                      : HAppColor
                                                          .hGreyColorShade600)),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        )),
                    gapH12,
                    Obx(() => Column(
                          children: slots
                              .map((element) => TypeTimeButton(
                                    value: element,
                                    title: element,
                                    price: element == '16:00 - 17:00' ||
                                            element == '17:00 - 18:00'
                                        ? 5000
                                        : -1,
                                    isFree: element == '16:00 - 17:00' ||
                                            element == '17:00 - 18:00'
                                        ? false
                                        : true,
                                  ))
                              .toList(),
                        )),
                    gapH12,
                  ]),
            ),
          );
        });
    update();
  }

  void getAvailableTimeSlots() {
    DateTime now = DateTime.now();
    if (slots.isNotEmpty) {
      slots.clear();
    }

    int index = now.hour;
    if (index < 13) {
      index = 14;
    } else {
      index = now.hour + 1;
    }
    if (now.hour < 13 && !isDateAfterToday(selectedDate.value)) {
      for (int i = 14; i <= 19; i++) {
        slots.add('$i:00 - ${i + 1}:00');
      }
    } else {
      if (isDateAfterToday(selectedDate.value)) {
        for (int i = index; i <= 19; i++) {
          slots.add('$i:00 - ${i + 1}:00');
        }
      }
    }
  }

  var slots = <String>[].obs;

  bool isDateAfterToday(DateTime selectedDate) {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    return selectedDate.isAfter(today);
  }
}
