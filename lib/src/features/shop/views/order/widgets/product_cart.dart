import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/detail_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/product_controller.dart';
import 'package:on_demand_grocery/src/features/shop/models/product_models.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';

class ProductCartWidget extends StatefulWidget {
  const ProductCartWidget({super.key, required this.model, required this.list});
  final ProductModel model;
  final RxList<ProductModel> list;

  @override
  State<ProductCartWidget> createState() => _ProductCartWidgetState();
}

class _ProductCartWidgetState extends State<ProductCartWidget> {
  final productController = Get.put(ProductController());
  final detailController = Get.put(DetailController());

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: HAppColor.hWhiteColor,
      ),
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Row(children: [
        Stack(
          children: [
            Container(
              height: 110,
              width: 110,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                      image: NetworkImage(widget.model.imgPath),
                      fit: BoxFit.fill)),
            ),
            widget.model.salePersent != ''
                ? Positioned(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: HAppColor.hOrangeColor),
                      child: Text(widget.model.salePersent,
                          style: HAppStyle.paragraph3Regular
                              .copyWith(color: HAppColor.hWhiteColor)),
                    ),
                  )
                : Container(),
          ],
        ),
        gapW10,
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                      onTap: () {},
                      child: const Row(
                        children: [
                          Icon(
                            EvaIcons.flip2Outline,
                            size: 15,
                          ),
                          gapW4,
                          Text(
                            "Thay thế",
                            style: HAppStyle.label4Bold,
                          )
                        ],
                      )),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.model.name,
                    maxLines: 2,
                    style: HAppStyle.heading4Style
                        .copyWith(overflow: TextOverflow.ellipsis),
                  ),
                  gapH6,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        EvaIcons.star,
                        color: HAppColor.hOrangeColor,
                        size: 20,
                      ),
                      gapW6,
                      Text(
                        '4.9 (100+)',
                        style: HAppStyle.paragraph3Regular
                            .copyWith(color: HAppColor.hGreyColor),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (widget.model.quantity > 1) {
                            widget.model.quantity--;
                          } else if (widget.model.quantity == 1) {
                            productController.isInCart.remove(widget.model);
                            widget.model.quantity = 0;
                          }
                          productController.refreshAllList();
                          productController
                              .refreshList(productController.isInCart);
                          productController.addMapProductInCart();
                          productController.sumProductMoney();
                          setState(() {});
                        },
                        child: Container(
                            height: 25,
                            width: 25,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: HAppColor.hBackgroundColor),
                            child: Center(
                              child: widget.model.quantity == 1
                                  ? Icon(
                                      EvaIcons.trashOutline,
                                      size: 15,
                                    )
                                  : Icon(
                                      EvaIcons.minus,
                                      size: 15,
                                    ),
                            )),
                      ),
                      gapW6,
                      Text(
                        "${widget.model.quantity}",
                        style: HAppStyle.paragraph2Bold,
                      ),
                      gapW6,
                      GestureDetector(
                        onTap: () {
                          widget.model.quantity++;
                          productController.refreshAllList();
                          productController
                              .refreshList(productController.isInCart);
                          productController.addMapProductInCart();
                          setState(() {});
                        },
                        child: Container(
                            height: 25,
                            width: 25,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: HAppColor.hBluePrimaryColor),
                            child: const Center(
                              child: Icon(
                                EvaIcons.plus,
                                size: 15,
                                color: HAppColor.hWhiteColor,
                              ),
                            )),
                      ),
                    ],
                  ),
                  Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      widget.model.salePersent == ''
                          ? Text(
                              "${int.parse(widget.model.price.substring(0, widget.model.price.length - 5)) * widget.model.quantity}.000₫",
                              style: HAppStyle.label2Bold
                                  .copyWith(color: HAppColor.hBluePrimaryColor),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                    "${int.parse(widget.model.price.substring(0, widget.model.price.length - 5)) * widget.model.quantity}.000₫",
                                    style: HAppStyle.paragraph3Bold.copyWith(
                                        color: HAppColor.hGreyColor,
                                        decoration:
                                            TextDecoration.lineThrough)),
                                Text(
                                    "${int.parse(widget.model.priceSale.substring(0, widget.model.priceSale.length - 5)) * widget.model.quantity}.000₫",
                                    style: HAppStyle.label2Bold.copyWith(
                                        color: HAppColor.hOrangeColor,
                                        decoration: TextDecoration.none))
                              ],
                            ),
                    ],
                  ),
                ],
              )
            ],
          ),
        )
      ]),
    );
  }
}
