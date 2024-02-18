import 'dart:ui';

import 'package:enefty_icons/enefty_icons.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/common_widgets/swipe_action_widget.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/chat_controller.dart';
import 'package:on_demand_grocery/src/features/shop/models/chat_message_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/product_models.dart';
import 'package:on_demand_grocery/src/features/shop/models/store_model.dart';
import 'package:on_demand_grocery/src/features/shop/views/chat/widgets/message.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ProductModel model = Get.arguments['model'];
  final StoreModel store = Get.arguments['store'];

  final FocusNode _focusNode = FocusNode();
  ChatMessage? _selectedMessage;

  final chatController = Get.put(ChartController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        backgroundColor: HAppColor.hBackgroundColor,
        toolbarHeight: 80,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              gapW24,
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
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
                backgroundImage: NetworkImage(store.imgStore),
              ),
              gapW16,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    store.name,
                    style: HAppStyle.label2Bold,
                  ),
                  Text(
                    "Hoạt động 3 phút trước",
                    style: HAppStyle.paragraph3Regular
                        .copyWith(color: HAppColor.hGreyColorShade600),
                  )
                ],
              )
            ],
          ),
        ),
        actions: [
          gapW10,
          GestureDetector(
            child: const Icon(Icons.more_horiz_outlined),
            onTap: () {},
          ),
          gapW24,
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
                itemBuilder: (context, index) => SwipeActionWidget(
                    direction: demeChatMessages[index].isSender ? 1 : 0,
                    function: (_) {
                      _focusNode.requestFocus();
                      setState(() {
                        _selectedMessage = demeChatMessages[index];
                      });
                    },
                    backgroundColorIcon: HAppColor.hGreyColorShade300,
                    colorIcon: HAppColor.hDarkColor,
                    icon: Icons.reply_outlined,
                    child: Message(message: demeChatMessages[index])),
                separatorBuilder: (BuildContext context, int index) => gapH12,
              ),
            ),
          ),
          Container(
            color: Colors.grey.shade200.withOpacity(0.5),
            child: SafeArea(
              top: false,
              child: Container(
                padding:
                    EdgeInsets.symmetric(horizontal: hAppDefaultPadding / 2),
                child: Column(
                  children: <Widget>[
                    _selectedMessage != null
                        ? Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: hAppDefaultPadding / 2),
                            child: Row(
                              children: <Widget>[
                                const Icon(
                                  Icons.reply_outlined,
                                  color: Colors.blue,
                                  size: 25,
                                ),
                                gapW10,
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "Đang trả lời",
                                        style: HAppStyle.paragraph2Regular
                                            .copyWith(
                                                color: HAppColor
                                                    .hBluePrimaryColor),
                                      ),
                                      gapH2,
                                      Text(_selectedMessage!.text,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: HAppStyle.paragraph3Regular
                                              .copyWith(
                                                  color: HAppColor
                                                      .hGreyColorShade600)),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedMessage = null;
                                    });
                                  },
                                  child: Container(
                                    height: 20,
                                    width: 20,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
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
                        : const SizedBox.shrink(),
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
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: HAppColor.hBluePrimaryColor,
                            ),
                            child: Icon(
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
