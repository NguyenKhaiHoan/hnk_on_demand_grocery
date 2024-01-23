import 'package:enefty_icons/enefty_icons.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/common_widgets/cart_cirle_widget.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/search/controller/search_controller.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final searchController = Get.put(SearchProductController());

  List<String> popularKeywords = [
    "Sữa chua",
    "Táo",
    "Củ cà rốt",
    "Rau xà lách",
    "Cà phê",
    "Tương ớt"
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        leading: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: hAppDefaultPadding),
            child: GestureDetector(
                onTap: () => Get.back(),
                child: const Icon(
                  Icons.arrow_back_ios,
                  size: 20,
                )),
          ),
        ),
        title: Text("Tìm kiếm"),
        centerTitle: true,
        actions: const [
          Padding(
            padding: hAppDefaultPaddingR,
            child: CartCircle(),
          )
        ],
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: hAppDefaultPaddingLR,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              textAlignVertical: TextAlignVertical.center,
              onEditingComplete: () => searchController.addHistorySearch(),
              controller: searchController.controller,
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
                    borderSide: const BorderSide(
                        width: 0.8, color: HAppColor.hGreyColor)),
                hintText: "Bạn muốn tìm gì?",
                prefixIcon: const Icon(
                  EvaIcons.search,
                  size: 25,
                ),
                suffixIcon: IconButton(
                    onPressed: () => searchController.controller.clear(),
                    icon: const Icon(
                      EvaIcons.close,
                      size: 20,
                    )),
              ),
            ),
            gapH12,
            Obx(() => searchController.historySearch.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Lịch sử tìm kiếm",
                              style: HAppStyle.heading4Style,
                            ),
                            TextButton(
                                onPressed: () =>
                                    searchController.removeAllHistorySearch(),
                                child: Text(
                                  "Xóa",
                                  style: HAppStyle.paragraph2Regular.copyWith(
                                      color: HAppColor.hBluePrimaryColor),
                                ))
                          ],
                        ),
                        SizedBox(
                            child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount:
                                    searchController.historySearch.length,
                                itemBuilder: (context, index) =>
                                    historySearchsItem(index))),
                      ],
                    ))
                : Container()),
            Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Từ khóa phổ biến",
                      style: HAppStyle.heading4Style,
                    ),
                    gapH10,
                    Wrap(
                      children: [
                        for (var keyword in popularKeywords)
                          Container(
                              margin:
                                  const EdgeInsets.only(bottom: 10, right: 5),
                              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(
                                  color: HAppColor.hGreyColorShade300,
                                  width: 1.5,
                                ),
                              ),
                              child: Text(
                                keyword,
                                style: HAppStyle.paragraph2Regular,
                              ))
                      ],
                    ),
                  ],
                )),
          ],
        ),
      )),
    ));
  }

  historySearchsItem(int index) {
    return InkWell(
      onTap: () {},
      child: Dismissible(
        key: GlobalKey(),
        onDismissed: (DismissDirection dir) =>
            searchController.removeHistorySearch(index),
        child: Row(
          children: [
            const Icon(
              EvaIcons.clockOutline,
            ),
            gapW10,
            Text(
              searchController.historySearch[index],
              style: HAppStyle.paragraph2Regular,
            ),
          ],
        ),
      ),
    );
  }
}
