import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/detail_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/product_controller.dart';
import 'package:on_demand_grocery/src/features/shop/models/product_models.dart';
import 'package:on_demand_grocery/src/routes/app_pages.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';

class ProductItemWidget extends StatelessWidget {
  ProductItemWidget({
    super.key,
    required this.model,
    required this.storeIcon,
    required this.list,
    required this.compare,
    this.modelCompare,
    this.differentText,
  });
  final ProductModel model;
  final ProductModel? modelCompare;
  final bool storeIcon;
  final RxList<ProductModel> list;
  final bool compare;
  final String? differentText;

  final productController = Get.put(ProductController());
  final detailController = Get.put(DetailController());

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () async {
      detailController.count.value = model.quantity != 0 ? model.quantity : 1;
    });
    return GestureDetector(
      child: Container(
        width: 165,
        decoration: BoxDecoration(
            color: HAppColor.hWhiteColor,
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  alignment: Alignment.centerLeft,
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                          image: NetworkImage(model.imgPath),
                          fit: BoxFit.fill)),
                ),
              ),
              storeIcon
                  ? Positioned(
                      top: 10,
                      left: 10,
                      child: Stack(
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: HAppColor.hGreyColorShade300,
                                  image: DecorationImage(
                                      image: NetworkImage(model.imgStore),
                                      fit: BoxFit.cover)),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(),
              model.salePersent != ''
                  ? Positioned(
                      bottom: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: HAppColor.hOrangeColor),
                        child: Text(model.salePersent,
                            style: HAppStyle.paragraph3Regular
                                .copyWith(color: HAppColor.hWhiteColor)),
                      ),
                    )
                  : Container(),
              Positioned(
                top: 10,
                right: 10,
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: HAppColor.hBackgroundColor),
                        child: Center(
                          child: model.isFavorite == false
                              ? const Icon(
                                  EvaIcons.heartOutline,
                                  color: HAppColor.hGreyColor,
                                )
                              : const Icon(
                                  EvaIcons.heart,
                                  color: HAppColor.hRedColor,
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(model.category,
                            style: HAppStyle.paragraph3Regular
                                .copyWith(color: HAppColor.hGreyColorShade600)),
                        Text(model.unit,
                            style: HAppStyle.paragraph3Regular
                                .copyWith(color: HAppColor.hGreyColorShade600)),
                      ],
                    ),
                    gapH4,
                    Text(
                      model.name,
                      style: HAppStyle.label2Bold.copyWith(
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    gapH4,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              EvaIcons.star,
                              color: HAppColor.hOrangeColor,
                              size: 16,
                            ),
                            gapW2,
                            Text.rich(
                              TextSpan(
                                style: HAppStyle.paragraph2Bold,
                                text: "4.9",
                                children: [
                                  TextSpan(
                                    text: '/5',
                                    style: HAppStyle.paragraph3Regular.copyWith(
                                        color: HAppColor.hGreyColorShade600),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Text.rich(
                          TextSpan(
                            style: HAppStyle.paragraph2Bold,
                            text: '${model.countBuyed} ',
                            children: [
                              TextSpan(
                                text: 'Đã bán',
                                style: HAppStyle.paragraph3Regular.copyWith(
                                    color: HAppColor.hGreyColorShade600),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ]),
            ),
            const Spacer(),
            !compare
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: model.salePersent == ''
                              ? Text(
                                  model.price,
                                  style: HAppStyle.label2Bold.copyWith(
                                      color: HAppColor.hBluePrimaryColor),
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(model.price,
                                        style: HAppStyle.paragraph3Bold
                                            .copyWith(
                                                color: HAppColor.hGreyColor,
                                                decoration: TextDecoration
                                                    .lineThrough)),
                                    Text(model.priceSale,
                                        style: HAppStyle.label2Bold.copyWith(
                                            color: HAppColor.hOrangeColor,
                                            decoration: TextDecoration.none))
                                  ],
                                )),
                      GestureDetector(
                        child: Container(
                          width: 45,
                          height: 45,
                          decoration: const BoxDecoration(
                            color: HAppColor.hBluePrimaryColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                          child: Center(
                              child: model.quantity != 0
                                  ? Text(
                                      "${model.quantity}",
                                      style: HAppStyle.label2Bold.copyWith(
                                          color: HAppColor.hWhiteColor),
                                    )
                                  : const Icon(
                                      EvaIcons.plus,
                                      color: HAppColor.hWhiteColor,
                                    )),
                        ),
                        onTap: () {
                          productController.addProductInCart(model);
                          if (model.quantity == 0) {
                            model.quantity++;
                            detailController.changeCount('+');
                          }
                          productController.refreshList(list);
                        },
                      )
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: model.salePersent == ''
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(differentText!,
                                        style:
                                            HAppStyle.paragraph3Bold.copyWith(
                                          color: HAppColor.hGreyColor,
                                        )),
                                    Text(model.price,
                                        style: HAppStyle.label2Bold.copyWith(
                                            color: HAppColor.hBluePrimaryColor,
                                            decoration: TextDecoration.none))
                                  ],
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(differentText!,
                                        style:
                                            HAppStyle.paragraph3Bold.copyWith(
                                          color: HAppColor.hGreyColor,
                                        )),
                                    Text(model.priceSale,
                                        style: HAppStyle.label2Bold.copyWith(
                                            color: HAppColor.hOrangeColor,
                                            decoration: TextDecoration.none))
                                  ],
                                )),
                      GestureDetector(
                        child: Container(
                          width: 45,
                          height: 45,
                          decoration: const BoxDecoration(
                            color: HAppColor.hBluePrimaryColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                          child: Center(
                              child: Image.asset(
                            'assets/images/other/search_tick.png',
                            height: 25,
                            width: 25,
                          )),
                        ),
                        onTap: () {},
                      )
                    ],
                  )
          ],
        ),
      ),
      onTap: () {
        print("VÀo");
        Get.toNamed(HAppRoutes.detail,
            arguments: {'model': model, 'list': list});
      },
    );
  }
}
