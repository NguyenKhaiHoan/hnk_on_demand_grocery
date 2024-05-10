import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/common_widgets/cart_cirle_widget.dart';
import 'package:on_demand_grocery/src/common_widgets/custom_layout_widget.dart';
import 'package:on_demand_grocery/src/common_widgets/horizontal_list_product_widget.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/personalization/controllers/user_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/cart_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/product_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/root_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/wishlist_controller.dart';
import 'package:on_demand_grocery/src/features/shop/models/product_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/wishlist_model.dart';
import 'package:on_demand_grocery/src/features/shop/views/explore/widgets/list_product_explore_builder.dart';
import 'package:on_demand_grocery/src/features/shop/views/product/widgets/product_item_horizal_widget.dart';
import 'package:on_demand_grocery/src/repositories/product_repository.dart';
import 'package:on_demand_grocery/src/routes/app_pages.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';
import 'package:on_demand_grocery/src/utils/utils.dart';

class WishlistItemScreen extends StatefulWidget {
  const WishlistItemScreen({super.key});

  @override
  State<WishlistItemScreen> createState() => _WishlistItemScreenState();
}

class _WishlistItemScreenState extends State<WishlistItemScreen> {
  final productController = ProductController.instance;
  final rootController = RootController.instance;
  final cartController = Get.put(CartController());
  final wishlistController = Get.put(WishlistController());

  final WishlistModel model = Get.arguments['model'];
  final List<ProductModel> list = Get.arguments['list'];

  var firstPart = ''.obs;
  var secondPart = ''.obs;

  @override
  void initState() {
    super.initState();
    firstPart.value = model.description;
    if (model.description.contains('Tên') &&
        model.description.contains('Thành phần') &&
        model.description.contains('Cách làm') &&
        model.description.contains('-recipe-')) {
      List<String> parts = model.description.split('-recipe-');

      if (parts.length >= 2) {
        firstPart.value = parts[0];
        secondPart.value = parts[1];
        print('Công thức$secondPart');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: hAppDefaultPaddingR,
            child: GestureDetector(
              onTap: () {
                var listProductName = list.map((e) => e.name).toList();
                for (var name in listProductName) {
                  print(name);
                }
                Get.to(GenerateRecipeScreen(),
                    arguments: {'listProductName': listProductName});
              },
              child: const Icon(Icons.auto_awesome),
            ),
          ),
          CartCircle(),
          gapW16
        ],
        title: Text(
            list.isEmpty ? model.title : "${model.title} (${list.length})"),
        centerTitle: true,
        toolbarHeight: 80,
        leadingWidth: 80,
        leading: Row(children: [
          gapW16,
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: HAppColor.hGreyColorShade300,
                    width: 1.5,
                  ),
                  color: HAppColor.hBackgroundColor),
              child: const Center(
                child: Icon(
                  EvaIcons.arrowBackOutline,
                ),
              ),
            ),
          ),
        ]),
      ),
      body: SingleChildScrollView(
        padding: hAppDefaultPaddingLR,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Obx(() => Text.rich(TextSpan(
                  style: HAppStyle.heading4Style,
                  text: "Mô tả: ",
                  children: [
                    TextSpan(
                        text: firstPart.value,
                        style: HAppStyle.paragraph2Regular
                            .copyWith(color: HAppColor.hGreyColorShade600))
                  ]))),
          Obx(
            () => secondPart.value == ''
                ? Container()
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      gapH10,
                      const Text(
                        'Công thức: ',
                        style: HAppStyle.heading4Style,
                      ),
                      gapH6,
                      Markdown(
                        data: secondPart.value,
                        selectable: true,
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                      )
                    ],
                  ),
          ),
          gapH10,
          GridView.builder(
            shrinkWrap: true,
            itemCount: list.length,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              mainAxisExtent: 150,
            ),
            itemBuilder: (BuildContext context, int index) {
              return ProductItemHorizalWidget(
                model: list[index],
                compare: false,
              );
            },
          )
        ]),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(
            hAppDefaultPadding, 10, hAppDefaultPadding, 10),
        height: 70,
        color: HAppColor.hTransparentColor,
        child: ElevatedButton(
          onPressed: () {
            if (list.isNotEmpty) {
              showDialog(
                context: Get.overlayContext!,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Thêm vào Giỏ hàng'),
                    content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bạn có muốn thêm tất cả sản phẩm trong danh sách mong ước hiện tại vào Giỏ hàng không?',
                            style: HAppStyle.paragraph2Regular
                                .copyWith(color: HAppColor.hGreyColorShade600),
                          ),
                        ]),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Get.back();
                          if (cartController.cartProducts.isNotEmpty) {
                            showDialog(
                              context: Get.overlayContext!,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title:
                                      const Text('Thêm vào danh sách mong ước'),
                                  content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Bạn đang có ${cartController.numberOfCart} sản phẩm trong giỏ hàng. Bạn muốn xóa tất cả và lưu lại các sản phẩm hiện có trong giỏ hàng vào danh sách mong ước không?',
                                          style: HAppStyle.paragraph2Regular
                                              .copyWith(
                                                  color: HAppColor
                                                      .hGreyColorShade600),
                                        ),
                                      ]),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Get.back();
                                        for (var product
                                            in cartController.cartProducts) {
                                          print(
                                              'cartController.cartProducts: ${product.productName}');
                                        }
                                        Get.toNamed(HAppRoutes.wishlist,
                                            arguments: {
                                              'listProductCart':
                                                  cartController.cartProducts,
                                              'listProductWishList': list
                                            });
                                      },
                                      child: Text(
                                        'Có',
                                        style: HAppStyle.label4Bold.copyWith(
                                            color: HAppColor.hBluePrimaryColor),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        Get.back();
                                        await wishlistController
                                            .addToCart(list);
                                      },
                                      child: Text(
                                        'Không',
                                        style: HAppStyle.label4Bold.copyWith(
                                            color: HAppColor.hRedColor),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        child: Text(
                          'Có',
                          style: HAppStyle.label4Bold
                              .copyWith(color: HAppColor.hBluePrimaryColor),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: Text(
                          'Không',
                          style: HAppStyle.label4Bold
                              .copyWith(color: HAppColor.hRedColor),
                        ),
                      ),
                    ],
                  );
                },
              );
            } else {
              Get.toNamed(HAppRoutes.root);
              rootController.animateToScreen(1);
            }
          },
          style: ElevatedButton.styleFrom(
            minimumSize: Size(HAppSize.deviceWidth - 48, 50),
            backgroundColor: HAppColor.hBluePrimaryColor,
          ),
          child: list.isNotEmpty
              ? Text("Chuyển tới Giỏ hàng",
                  style: HAppStyle.label2Bold
                      .copyWith(color: HAppColor.hWhiteColor))
              : Text("Thêm vào Danh sách mong ước ngay",
                  style: HAppStyle.label2Bold
                      .copyWith(color: HAppColor.hWhiteColor)),
        ),
      ),
    );
  }
}

class GenerateRecipeScreen extends StatelessWidget {
  GenerateRecipeScreen({super.key});

  final List<String> listProductName = Get.arguments['listProductName'] ?? [];

  final Gemini gemini = Gemini.instance;
  final recipe = ''.obs;
  final anotherProduct = ''.obs;
  final WishlistModel model = Get.arguments['model'];

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero).then((value) async {
      await generateRecipe();
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tạo công thức'),
        centerTitle: true,
        toolbarHeight: 80,
        leadingWidth: 80,
        leading: Row(children: [
          gapW16,
          GestureDetector(
            onTap: () {
              Get.back();
              Get.back();
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: HAppColor.hGreyColorShade300,
                    width: 1.5,
                  ),
                  color: HAppColor.hBackgroundColor),
              child: const Center(
                child: Icon(
                  EvaIcons.arrowBackOutline,
                ),
              ),
            ),
          ),
        ]),
      ),
      body: SingleChildScrollView(
        padding: hAppDefaultPaddingLR,
        child: Column(children: [
          Obx(() => recipe.value == ''
              ? const Center(
                  child: CircularProgressIndicator(
                      color: HAppColor.hBluePrimaryColor),
                )
              : Markdown(
                  data: recipe.value,
                  selectable: true,
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                )),
          gapH12,
          Obx(() => anotherProduct.value == ''
              ? Container()
              : FutureBuilder(
                  future: ProductRepository.instance
                      .fetchProductsByName(anotherProduct.value.split(', ')),
                  builder: ((context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CustomLayoutWidget(
                        widget: const ShimmerListProductExploreBuilder(),
                        subWidget: Container(),
                      );
                    }

                    if (snapshot.hasError) {
                      return const Text(
                          'Đã xảy ra sự cố. Xin vui lòng thử lại sau.');
                    }

                    if (!snapshot.hasData ||
                        snapshot.data == null ||
                        snapshot.data!.isEmpty) {
                      return Text(
                          '${anotherProduct.value}. Không tìm thấy các sản phẩm liên quan tại ứng dụng.');
                    } else {
                      final data = snapshot.data!;
                      return HorizontalListProductWidget(
                          list: data,
                          compare: false,
                          wishlistCheck: false,
                          wishlist: model);
                    }
                  }))),
          gapH12,
          Obx(() => recipe.value != ''
              ? ElevatedButton(
                  onPressed: () async {
                    print('Vào đây NBBBBB');
                    try {
                      if (model.description.contains('Tên') &&
                          model.description.contains('Thành phần') &&
                          model.description.contains('Cách làm') &&
                          model.description.contains('-recipe-')) {
                        print('Vào đây iff');

                        showDialog(
                          context: Get.overlayContext!,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Đã tồn tại công thức'),
                              content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Trong danh sách mong ước này đã có công thức, bạn có muốn thay thế công thức mới không?',
                                      style: HAppStyle.paragraph2Regular
                                          .copyWith(
                                              color:
                                                  HAppColor.hGreyColorShade600),
                                    ),
                                  ]),
                              actions: [
                                TextButton(
                                  onPressed: () async {
                                    Get.back();
                                  },
                                  child: Text(
                                    'Không',
                                    style: HAppStyle.label4Bold
                                        .copyWith(color: HAppColor.hRedColor),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    List<String> parts =
                                        model.description.split('-recipe-');
                                    String firstPart = '';
                                    String secondPart = '';
                                    if (parts.length >= 2) {
                                      firstPart = parts[0];
                                      secondPart = parts[1];
                                    }

                                    await FirebaseFirestore.instance
                                        .collection('Users')
                                        .doc(UserController
                                            .instance.user.value.id)
                                        .collection('Wishlists')
                                        .doc(model.id)
                                        .update({
                                      'Description':
                                          '$firstPart-recipe-${recipe.value}'
                                    }).onError((error, stackTrace) {
                                      HAppUtils.showSnackBarError(
                                          'Lỗi', 'Không thể lưu trữ công thức');
                                    });
                                    Get.back();
                                    Get.back();
                                    Get.back();
                                  },
                                  child: Text(
                                    'Có',
                                    style: HAppStyle.label4Bold
                                        .copyWith(color: HAppColor.hRedColor),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        await FirebaseFirestore.instance
                            .collection('Users')
                            .doc(UserController.instance.user.value.id)
                            .collection('Wishlists')
                            .doc(model.id)
                            .update({
                          'Description':
                              '${model.description}-recipe-${recipe.value}'
                        }).onError((error, stackTrace) {
                          HAppUtils.showSnackBarError(
                              'Lỗi', 'Không thể lưu trữ công thức');
                        });
                        Get.back();
                        Get.back();
                        Get.back();
                      }
                    } catch (e) {
                      print(e.toString());
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: HAppColor.hBluePrimaryColor,
                      fixedSize: Size(
                          HAppSize.deviceWidth - hAppDefaultPadding * 2, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50))),
                  child: Text("Lưu công thức",
                      style: HAppStyle.label2Bold
                          .copyWith(color: HAppColor.hWhiteColor)),
                )
              : Container())
        ]),
      ),
    );
  }

  Future<void> generateRecipe() async {
    try {
      recipe.value = '';
      HAppUtils.loadingOverlays();
      await gemini
          .text(
              'Tạo một công thức nấu ăn đơn giản từ một danh sách đầy đủ các thành phần (nguyên liệu) sau: ${listProductName.join(', ')} và Sữa với mẫu sau: Tên, Thành phần và Cách làm')
          .then((value) {
        recipe.value = value?.output ?? '';
        HAppUtils.stopLoading();
      }).catchError((e) {
        HAppUtils.stopLoading();
        HAppUtils.showSnackBarError(
            'Lỗi', 'Không thể tạo được công thức! ${e.toString()}');
      });
      await gemini
          .text(
              'Từ các thành phần trong công thức này ${recipe.value}, hãy viết lại các thành phần (chỉ lấy tên các sản phẩm trong đó và viết lại chữ cái đầu của từng thành phần thành chữ cái in hoa, ví dụ: chuối, sữa thành Chuối, Sữa) thành một danh sách ngăn cách nhau bằng dấu (, ) ngoại từ các thành phần này (${listProductName.join(', ')})')
          .then((value) {
        anotherProduct.value = value?.output ?? '';
      }).catchError((e) {
        HAppUtils.showSnackBarError(
            'Lỗi', 'Không thể tìm được các sản phẩm khác! ${e.toString()}');
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
