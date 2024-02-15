import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/common_widgets/cart_cirle_widget.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
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

class _AllStoreScreenState extends State<AllStoreScreen> {
  @override
  void initState() {
    super.initState();
  }

  final itemsSort = ['A-Z', 'Z-A'];
  String selectedValueSort = 'A-Z';
  final itemsCategory = [
    'Tất cả',
    'Trái cây',
    'Rau củ',
    'Thịt tươi',
    'Hải sản',
    'Trứng',
    'Sữa',
    'Gia vị',
    'Hạt',
    'Bánh mỳ',
    'Đồ uống',
    'Ăn vặt',
    'Mỳ & Gạo',
  ];
  String selectedValueCategory = 'Tất cả';

  @override
  Widget build(BuildContext context) {
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
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                image: const DecorationImage(
                    image: AssetImage('assets/logos/logo.png'),
                    fit: BoxFit.fill),
              ),
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
                    value: selectedValueSort,
                    onChanged: (newValue) =>
                        setState(() => selectedValueSort = newValue!),
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
                    value: selectedValueCategory,
                    onChanged: (newValue) =>
                        setState(() => selectedValueCategory = newValue!),
                    items: itemsCategory
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
                        return CustomChipWidget(
                            title: tags[index].title,
                            active: tags[index].active,
                            onTap: () {
                              if (index != 0) {
                                tags[index].active = !tags[index].active;
                                if (tags[index].active == true) {
                                  tags[0].active = false;
                                } else {
                                  var listNoActive =
                                      tags.where((tag) => tag.active == false);
                                  if (listNoActive.length == tags.length) {
                                    tags[0].active = true;
                                  }
                                }
                              }
                              setState(() {});
                            });
                      },
                      separatorBuilder: (_, __) => gapW10,
                      itemCount: tags.length),
                ),
              ],
            ),
          ),
          gapH16,
          tags[0].active
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Cửa hàng",
                      style: HAppStyle.heading4Style,
                    ),
                    Text(
                      "${listStore.length} Kết quả",
                      style: HAppStyle.paragraph3Regular
                          .copyWith(color: HAppColor.hGreyColorShade600),
                    ),
                  ],
                ),
          Expanded(
              child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(children: [
              gapH12,
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: listStore.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  mainAxisExtent: 200,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return StoreItemWidget(model: listStore[index]);
                },
              ),
              gapH24,
            ]),
          ))
        ]),
      ),
    );
  }
}
