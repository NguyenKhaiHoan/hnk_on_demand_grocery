import 'package:enefty_icons/enefty_icons.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_network/image_network.dart';
import 'package:on_demand_grocery/src/common_widgets/custom_shimmer_widget.dart';
import 'package:on_demand_grocery/src/common_widgets/swipe_action_widget.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/data/dummy_data.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/chat_controller.dart';
import 'package:on_demand_grocery/src/features/shop/models/chat_message_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/product_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/store_model.dart';
import 'package:on_demand_grocery/src/features/shop/views/chat/widgets/message.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';
import 'package:on_demand_grocery/src/utils/utils.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ProductModel model = Get.arguments['model'];
  final StoreModel store = Get.arguments['store'];
  final bool check = Get.arguments['check'];

  final FocusNode _focusNode = FocusNode();
  final chatController = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    RxBool hasProduct = check.obs;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        backgroundColor: HAppColor.hBackgroundColor,
        toolbarHeight: 80,
        title: Padding(
          padding: hAppDefaultPaddingL,
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
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
              gapW16,
              CircleAvatar(
                backgroundImage: NetworkImage(store.storeImage),
              ),
              gapW16,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    store.name,
                    style: HAppStyle.label2Bold,
                  ),
                ],
              )
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: hAppDefaultPadding, left: 10),
            child: GestureDetector(
              child: const Icon(Icons.more_horiz_outlined),
              onTap: () {},
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: hAppDefaultPadding),
              child: ListView.separated(
                itemCount: demeChatMessages.length,
                itemBuilder: (context, index) =>
                    Message(message: demeChatMessages[index]),
                separatorBuilder: (BuildContext context, int index) => gapH12,
              ),
            ),
          ),
          Container(
            color: Colors.grey.shade200.withOpacity(0.5),
            child: SafeArea(
              top: false,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: hAppDefaultPadding / 2),
                child: Column(
                  children: <Widget>[
                    Obx(() => hasProduct.value == true
                        ? Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: hAppDefaultPadding / 2),
                            child: Row(
                              children: <Widget>[
                                Stack(
                                  children: [
                                    ImageNetwork(
                                      image: model.image,
                                      height: 80,
                                      width: 80,
                                      duration: 500,
                                      curve: Curves.easeIn,
                                      onPointer: true,
                                      debugPrint: false,
                                      fullScreen: false,
                                      fitAndroidIos: BoxFit.cover,
                                      fitWeb: BoxFitWeb.cover,
                                      borderRadius: BorderRadius.circular(10),
                                      onLoading:
                                          CustomShimmerWidget.rectangular(
                                              width: 80, height: 80),
                                      onError: const Icon(
                                        Icons.error,
                                        color: Colors.red,
                                      ),
                                    ),
                                    model.salePersent != 0
                                        ? Positioned(
                                            bottom: 5,
                                            left: 5,
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      5, 3, 5, 3),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color:
                                                      HAppColor.hOrangeColor),
                                              child: Text(
                                                  '${model.salePersent}%',
                                                  style: HAppStyle.label4Bold
                                                      .copyWith(
                                                          color: HAppColor
                                                              .hWhiteColor)),
                                            ),
                                          )
                                        : Container()
                                  ],
                                ),
                                gapW10,
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        children: [
                                          Expanded(
                                              child: Text(
                                            model.name,
                                            maxLines: 2,
                                            style: HAppStyle.label2Bold,
                                          )),
                                          gapW10,
                                          model.status != ""
                                              ? Container(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          5, 3, 5, 3),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .only(
                                                              topLeft: Radius
                                                                  .circular(5),
                                                              bottomLeft: Radius
                                                                  .circular(5)),
                                                      color: HAppColor
                                                          .hGreyColorShade300),
                                                  child: Center(
                                                      child: Text(
                                                    model.status,
                                                    style:
                                                        HAppStyle.label4Regular,
                                                  )),
                                                )
                                              : Container()
                                        ],
                                      ),
                                      gapH4,
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
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
                                                  style:
                                                      HAppStyle.paragraph2Bold,
                                                  text: "4.3",
                                                  children: [
                                                    TextSpan(
                                                      text: '/5',
                                                      style: HAppStyle
                                                          .paragraph3Regular
                                                          .copyWith(
                                                              color: HAppColor
                                                                  .hGreyColorShade600),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          gapW10,
                                          Text.rich(
                                            TextSpan(
                                              style: HAppStyle.paragraph2Bold,
                                              text: '${model.countBuyed} ',
                                              children: [
                                                TextSpan(
                                                  text: 'Đã bán',
                                                  style: HAppStyle
                                                      .paragraph3Regular
                                                      .copyWith(
                                                          color: HAppColor
                                                              .hGreyColorShade600),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      gapH4,
                                      model.salePersent == 0
                                          ? Text(
                                              HAppUtils
                                                  .vietNamCurrencyFormatting(
                                                      model.price),
                                              style: HAppStyle.label2Bold
                                                  .copyWith(
                                                      color: HAppColor
                                                          .hBluePrimaryColor),
                                            )
                                          : Text.rich(
                                              TextSpan(
                                                style: HAppStyle.label2Bold
                                                    .copyWith(
                                                        color: HAppColor
                                                            .hOrangeColor,
                                                        decoration:
                                                            TextDecoration
                                                                .none),
                                                text:
                                                    '${HAppUtils.vietNamCurrencyFormatting(model.priceSale)} ',
                                                children: [
                                                  TextSpan(
                                                    text: HAppUtils
                                                        .vietNamCurrencyFormatting(
                                                            model.price),
                                                    style: HAppStyle
                                                        .label4Regular
                                                        .copyWith(
                                                            color: HAppColor
                                                                .hGreyColor,
                                                            decoration:
                                                                TextDecoration
                                                                    .lineThrough),
                                                  ),
                                                ],
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
                                gapW10,
                                GestureDetector(
                                  onTap: () {
                                    hasProduct.value = false;
                                  },
                                  child: Container(
                                    height: 20,
                                    width: 20,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: HAppColor.hGreyColorShade300,
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      color: HAppColor.hDarkColor,
                                      size: 10,
                                    ),
                                  ),
                                ),
                              ],
                            ))
                        : const SizedBox.shrink()),
                    TextField(
                      controller: chatController.controller,
                      focusNode: _focusNode,
                      onSubmitted: (_) {
                        _focusNode.canRequestFocus;
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(16),
                        hintText: 'Gửi tin nhắn ...',
                        suffixIcon: GestureDetector(
                          child: Container(
                            height: 30,
                            width: 30,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: HAppColor.hBluePrimaryColor,
                            ),
                            child: const Icon(
                              EneftyIcons.send_3_bold,
                              color: HAppColor.hWhiteColor,
                              size: 25,
                            ),
                          ),
                        ),
                        enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide.none),
                        border: const UnderlineInputBorder(
                            borderSide: BorderSide.none),
                        // ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
