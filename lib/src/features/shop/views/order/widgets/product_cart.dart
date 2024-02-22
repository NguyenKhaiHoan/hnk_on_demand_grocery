import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/common_widgets/swipe_action_widget.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/detail_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/product_controller.dart';
import 'package:on_demand_grocery/src/features/shop/models/product_models.dart';
import 'package:on_demand_grocery/src/routes/app_pages.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';
import 'package:toastification/toastification.dart';

class ProductCartWidget extends StatefulWidget {
  const ProductCartWidget({
    super.key,
    required this.model,
    required this.list,
  });
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
    return SwipeActionWidget(
      check: 1,
      backgroundColorIcon: const Color(0xFFFFE6E6),
      colorIcon: HAppColor.hRedColor,
      icon: EvaIcons.trashOutline,
      function: (_) {
        ProductModel model = widget.model;
        int index = 0;
        int modelQuantity = widget.model.quantity;

        if (productController.isInCart.contains(model)) {
          index = productController.isInCart.indexOf(widget.model);

          productController.isInCart.removeAt(index);
          widget.model.quantity = 0;
          productController.refreshAllList();
          productController.refreshList(productController.isInCart);
          productController.addMapProductInCart();
          productController.sumProductMoney();
          setState(() {});
        }

        toastification.show(
          callbacks: ToastificationCallbacks(
            onTap: (toastItem) {
              if (!productController.isInCart.contains(model)) {
                widget.model.quantity = modelQuantity;
                productController.isInCart.insert(index, model);
                productController.refreshAllList();
                productController.refreshList(productController.isInCart);
                productController.addMapProductInCart();
                productController.sumProductMoney();
                setState(() {});
              }
            },
          ),
          progressBarTheme: const ProgressIndicatorThemeData(
              color: HAppColor.hBluePrimaryColor),
          context: context,
          type: ToastificationType.success,
          style: ToastificationStyle.flat,
          autoCloseDuration: const Duration(seconds: 3),
          title: Text(
            'Xóa khỏi Giỏ hàng!',
            style: HAppStyle.label2Bold
                .copyWith(color: HAppColor.hBluePrimaryColor),
          ),
          description: RichText(
              text: TextSpan(
                  style: HAppStyle.paragraph2Regular
                      .copyWith(color: HAppColor.hGreyColorShade600),
                  text: 'Bạn đã xóa ',
                  children: [
                TextSpan(
                    text: ' ${model.name} ',
                    style: HAppStyle.paragraph2Regular
                        .copyWith(color: HAppColor.hBluePrimaryColor)),
                const TextSpan(
                    text:
                        'khỏi giỏ hàng, có thể nhấn vào để hoàn tác lại sản phẩm vào giỏ hàng .')
              ])),
          alignment: Alignment.topCenter,
          animationDuration: const Duration(milliseconds: 300),
          animationBuilder: (context, animation, alignment, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          icon: const Icon(
            Icons.check,
            color: HAppColor.hBluePrimaryColor,
          ),
          backgroundColor: HAppColor.hBackgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color(0x07000000),
              blurRadius: 16,
              offset: Offset(0, 16),
              spreadRadius: 0,
            )
          ],
          showProgressBar: true,
          closeButtonShowType: CloseButtonShowType.onHover,
          closeOnClick: false,
          pauseOnHover: true,
          dragToClose: true,
        );
      },
      child: GestureDetector(
        child: Container(
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
                            '4.3 (100+)',
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
                                      ? const Icon(
                                          EvaIcons.trashOutline,
                                          size: 15,
                                        )
                                      : const Icon(
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
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          widget.model.salePersent == ''
                              ? Text(
                                  "${int.parse(widget.model.price.substring(0, widget.model.price.length - 5)) * widget.model.quantity}.000₫",
                                  style: HAppStyle.label2Bold.copyWith(
                                      color: HAppColor.hBluePrimaryColor),
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                        "${int.parse(widget.model.price.substring(0, widget.model.price.length - 5)) * widget.model.quantity}.000₫",
                                        style: HAppStyle.paragraph3Bold
                                            .copyWith(
                                                color: HAppColor.hGreyColor,
                                                decoration: TextDecoration
                                                    .lineThrough)),
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
        ),
        onTap: () => Get.toNamed(
          HAppRoutes.productDetail,
          arguments: {
            'model': widget.model,
            'list': widget.list,
          },
        ),
      ),
    );
  }
}
