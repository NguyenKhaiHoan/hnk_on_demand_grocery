import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/chat_controller.dart';
import 'package:on_demand_grocery/src/features/shop/models/product_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/store_model.dart';
import 'package:on_demand_grocery/src/repositories/store_repository.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';

// class ChatScreen extends StatefulWidget {
//   const ChatScreen({super.key});

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final ProductModel model = Get.arguments['model'];
//   final StoreModel store = Get.arguments['store'];
//   final bool check = Get.arguments['check'];

//   final FocusNode _focusNode = FocusNode();
//   final chatController = ChatController.instance;

//   @override
//   Widget build(BuildContext context) {
//     RxBool hasProduct = check.obs;
//     return Scaffold(
//       appBar: AppBar(
//         titleSpacing: 0,
//         centerTitle: false,
//         automaticallyImplyLeading: false,
//         backgroundColor: HAppColor.hBackgroundColor,
//         toolbarHeight: 80,
//         title: Padding(
//           padding: hAppDefaultPaddingL,
//           child: Row(
//             children: [
//               GestureDetector(
//                 onTap: () {
//                   Get.back();
//                 },
//                 child: Container(
//                   width: 40,
//                   height: 40,
//                   decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       border: Border.all(
//                         color: HAppColor.hGreyColorShade300,
//                         width: 1.5,
//                       ),
//                       color: HAppColor.hBackgroundColor),
//                   child: const Center(
//                     child: Icon(
//                       EvaIcons.arrowBackOutline,
//                     ),
//                   ),
//                 ),
//               ),
//               gapW16,
//               CircleAvatar(
//                 backgroundImage: NetworkImage(store.storeImage),
//               ),
//               gapW16,
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     store.name,
//                     style: HAppStyle.label2Bold,
//                   ),
//                 ],
//               )
//             ],
//           ),
//         ),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(right: hAppDefaultPadding, left: 10),
//             child: GestureDetector(
//               child: const Icon(Icons.more_horiz_outlined),
//               onTap: () {},
//             ),
//           )
//         ],
//       ),
//       body: Column(
//         children: [
//           // Expanded(
//           //   child: Padding(
//           //     padding:
//           //         const EdgeInsets.symmetric(horizontal: hAppDefaultPadding),
//           //     child: ListView.separated(
//           //       itemCount: demeChatMessages.length,
//           //       itemBuilder: (context, index) =>
//           //           Message(message: demeChatMessages[index]),
//           //       separatorBuilder: (BuildContext context, int index) => gapH12,
//           //     ),
//           //   ),
//           // ),
//           Container(
//             color: Colors.grey.shade200.withOpacity(0.5),
//             child: SafeArea(
//               top: false,
//               child: Container(
//                 padding: const EdgeInsets.symmetric(
//                     horizontal: hAppDefaultPadding / 2),
//                 child: Column(
//                   children: <Widget>[
//                     Obx(() => hasProduct.value == true
//                         ? Container(
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: hAppDefaultPadding / 2),
//                             child: Row(
//                               children: <Widget>[
//                                 Stack(
//                                   children: [
//                                     ImageNetwork(
//                                       image: model.image,
//                                       height: 80,
//                                       width: 80,
//                                       duration: 500,
//                                       curve: Curves.easeIn,
//                                       onPointer: true,
//                                       debugPrint: false,
//                                       fullScreen: false,
//                                       fitAndroidIos: BoxFit.cover,
//                                       fitWeb: BoxFitWeb.cover,
//                                       borderRadius: BorderRadius.circular(10),
//                                       onLoading:
//                                           CustomShimmerWidget.rectangular(
//                                               width: 80, height: 80),
//                                       onError: const Icon(
//                                         Icons.error,
//                                         color: Colors.red,
//                                       ),
//                                     ),
//                                     model.salePersent != 0
//                                         ? Positioned(
//                                             bottom: 5,
//                                             left: 5,
//                                             child: Container(
//                                               padding:
//                                                   const EdgeInsets.fromLTRB(
//                                                       5, 3, 5, 3),
//                                               decoration: BoxDecoration(
//                                                   borderRadius:
//                                                       BorderRadius.circular(10),
//                                                   color:
//                                                       HAppColor.hOrangeColor),
//                                               child: Text(
//                                                   '${model.salePersent}%',
//                                                   style: HAppStyle.label4Bold
//                                                       .copyWith(
//                                                           color: HAppColor
//                                                               .hWhiteColor)),
//                                             ),
//                                           )
//                                         : Container()
//                                   ],
//                                 ),
//                                 gapW10,
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: <Widget>[
//                                       Row(
//                                         children: [
//                                           Expanded(
//                                               child: Text(
//                                             model.name,
//                                             maxLines: 2,
//                                             style: HAppStyle.label2Bold,
//                                           )),
//                                           gapW10,
//                                           model.status != ""
//                                               ? Container(
//                                                   padding:
//                                                       const EdgeInsets.fromLTRB(
//                                                           5, 3, 5, 3),
//                                                   decoration: BoxDecoration(
//                                                       borderRadius:
//                                                           const BorderRadius
//                                                               .only(
//                                                               topLeft: Radius
//                                                                   .circular(5),
//                                                               bottomLeft: Radius
//                                                                   .circular(5)),
//                                                       color: HAppColor
//                                                           .hGreyColorShade300),
//                                                   child: Center(
//                                                       child: Text(
//                                                     model.status,
//                                                     style:
//                                                         HAppStyle.label4Regular,
//                                                   )),
//                                                 )
//                                               : Container()
//                                         ],
//                                       ),
//                                       gapH4,
//                                       Row(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.center,
//                                         children: [
//                                           Row(
//                                             children: [
//                                               const Icon(
//                                                 EvaIcons.star,
//                                                 color: HAppColor.hOrangeColor,
//                                                 size: 16,
//                                               ),
//                                               gapW2,
//                                               Text.rich(
//                                                 TextSpan(
//                                                   style:
//                                                       HAppStyle.paragraph2Bold,
//                                                   text: "4.3",
//                                                   children: [
//                                                     TextSpan(
//                                                       text: '/5',
//                                                       style: HAppStyle
//                                                           .paragraph3Regular
//                                                           .copyWith(
//                                                               color: HAppColor
//                                                                   .hGreyColorShade600),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                           gapW10,
//                                           Text.rich(
//                                             TextSpan(
//                                               style: HAppStyle.paragraph2Bold,
//                                               text: '${model.countBuyed} ',
//                                               children: [
//                                                 TextSpan(
//                                                   text: 'Đã bán',
//                                                   style: HAppStyle
//                                                       .paragraph3Regular
//                                                       .copyWith(
//                                                           color: HAppColor
//                                                               .hGreyColorShade600),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       gapH4,
//                                       model.salePersent == 0
//                                           ? Text(
//                                               HAppUtils
//                                                   .vietNamCurrencyFormatting(
//                                                       model.price),
//                                               style: HAppStyle.label2Bold
//                                                   .copyWith(
//                                                       color: HAppColor
//                                                           .hBluePrimaryColor),
//                                             )
//                                           : Text.rich(
//                                               TextSpan(
//                                                 style: HAppStyle.label2Bold
//                                                     .copyWith(
//                                                         color: HAppColor
//                                                             .hOrangeColor,
//                                                         decoration:
//                                                             TextDecoration
//                                                                 .none),
//                                                 text:
//                                                     '${HAppUtils.vietNamCurrencyFormatting(model.priceSale)} ',
//                                                 children: [
//                                                   TextSpan(
//                                                     text: HAppUtils
//                                                         .vietNamCurrencyFormatting(
//                                                             model.price),
//                                                     style: HAppStyle
//                                                         .label4Regular
//                                                         .copyWith(
//                                                             color: HAppColor
//                                                                 .hGreyColor,
//                                                             decoration:
//                                                                 TextDecoration
//                                                                     .lineThrough),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                     ],
//                                   ),
//                                 ),
//                                 gapW10,
//                                 GestureDetector(
//                                   onTap: () {
//                                     hasProduct.value = false;
//                                   },
//                                   child: Container(
//                                     height: 20,
//                                     width: 20,
//                                     decoration: BoxDecoration(
//                                       shape: BoxShape.circle,
//                                       color: HAppColor.hGreyColorShade300,
//                                     ),
//                                     child: const Icon(
//                                       Icons.close,
//                                       color: HAppColor.hDarkColor,
//                                       size: 10,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ))
//                         : const SizedBox.shrink()),
//                     TextField(
//                       // controller: chatController.controller,
//                       focusNode: _focusNode,
//                       onSubmitted: (_) {
//                         _focusNode.canRequestFocus;
//                       },
//                       decoration: InputDecoration(
//                         contentPadding: const EdgeInsets.all(16),
//                         hintText: 'Gửi tin nhắn ...',
//                         suffixIcon: GestureDetector(
//                           child: Container(
//                             height: 30,
//                             width: 30,
//                             decoration: const BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: HAppColor.hBluePrimaryColor,
//                             ),
//                             child: const Icon(
//                               EneftyIcons.send_3_bold,
//                               color: HAppColor.hWhiteColor,
//                               size: 25,
//                             ),
//                           ),
//                         ),
//                         enabledBorder: const UnderlineInputBorder(
//                             borderSide: BorderSide.none),
//                         border: const UnderlineInputBorder(
//                             borderSide: BorderSide.none),
//                         // ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:convert';

import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:image_picker/image_picker.dart';
import 'package:on_demand_grocery/src/features/personalization/controllers/user_controller.dart';
import 'package:uuid/uuid.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ProductModel? model = Get.arguments['model'];
  final String storeId = Get.arguments['storeId'];
  final bool? check = Get.arguments['check'];

  var store = StoreModel.empty().obs;

  final chatController = Get.put(ChatController());

  final List<types.Message> _messages = [];
  final _user = types.User(
      id: UserController.instance.user.value.id,
      firstName: UserController.instance.user.value.name.substring(
          0,
          UserController.instance.user.value.name.length > 10
              ? 10
              : UserController.instance.user.value.name.length),
      imageUrl: UserController.instance.user.value.profileImage);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      store.value = await StoreRepository.instance.getStoreInformation(storeId);
      _loadMessages();
      await chatController.checkChatExists(
          UserController.instance.user.value.id, storeId);
    });
  }

  Future<void> _addMessage(types.Message message) async {
    String chatId = chatController.getChatId(
        UserController.instance.user.value.id, storeId);

    await FirebaseFirestore.instance
        .collection('Chats')
        .doc(chatId)
        .collection('Message')
        .add(message.toJson());

    String lastMessage = '';
    for (var message in _messages) {
      if (message is types.TextMessage) {
        lastMessage =
            '${message.text}-${message.createdAt != null ? DateFormat('EEEE, d-M-y', 'vi').format(DateTime.fromMillisecondsSinceEpoch(message.createdAt!)) : ''}';
        break;
      }
    }
    await FirebaseFirestore.instance
        .collection("Chats")
        .doc(chatId)
        .update({"LastMessage": lastMessage});
    chatController.resetData.toggle();
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);

      final message = types.ImageMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        height: image.height.toDouble(),
        id: const Uuid().v4(),
        name: result.name,
        size: bytes.length,
        uri: result.path,
        width: image.width.toDouble(),
      );

      _addMessage(message);
    }
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final index = _messages.indexWhere((element) => element.id == message.id);
    final updatedMessage = (_messages[index] as types.TextMessage).copyWith(
      previewData: previewData,
    );
    _messages[index] = updatedMessage;

    if (!mounted) {
      return;
    } else {
      setState(() {});
    }
  }

  void _handleAttachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: HAppColor.hBackgroundColor,
      builder: (BuildContext context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(hAppDefaultPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleImageSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Row(children: [
                    Icon(
                      EvaIcons.image,
                      color: HAppColor.hDarkColor,
                    ),
                    gapW10,
                    Text(
                      'Ảnh',
                      style: HAppStyle.label2Bold,
                    )
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  late final StreamSubscription _messagesSubscription;

  @override
  void dispose() {
    _messagesSubscription.cancel();
    super.dispose();
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    _addMessage(textMessage);
  }

  void _loadMessages() {
    String chatId = chatController.getChatId(
        UserController.instance.user.value.id, storeId);
    _messagesSubscription = FirebaseFirestore.instance
        .collection('Chats')
        .doc(chatId)
        .collection('Message')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((event) {
      if (event.docs.isNotEmpty) {
        _messages.clear();
        for (var doc in event.docs) {
          var message =
              types.Message.fromJson(jsonDecode(jsonEncode(doc.data())));
          _messages.add(message);
        }
        if (!mounted) {
          return;
        } else {
          setState(() {});
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
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
                Obx(() => CircleAvatar(
                      backgroundImage: NetworkImage(store.value.storeImage),
                    )),
                gapW16,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() => Text(
                          store.value.name,
                          style: HAppStyle.label2Bold,
                        )),
                  ],
                )
              ],
            ),
          ),
          actions: [
            Padding(
              padding:
                  const EdgeInsets.only(right: hAppDefaultPadding, left: 10),
              child: GestureDetector(
                child: const Icon(Icons.more_horiz_outlined),
                onTap: () {},
              ),
            )
          ],
        ),
        body: Chat(
          messages: _messages,
          onPreviewDataFetched: _handlePreviewDataFetched,
          onSendPressed: _handleSendPressed,
          onAttachmentPressed: _handleAttachmentPressed,
          showUserAvatars: true,
          showUserNames: true,
          user: _user,
          l10n: const ChatL10nVi(),
          theme: const DefaultChatTheme(
              backgroundColor: HAppColor.hBackgroundColor),
        ),
      );
}

@immutable
class ChatL10nVi extends ChatL10n {
  const ChatL10nVi({
    super.attachmentButtonAccessibilityLabel = 'Gửi phương tiện',
    super.emptyChatPlaceholder = 'Chưa có tin nhắn ở đây',
    super.fileButtonAccessibilityLabel = 'Tệp',
    super.inputPlaceholder = 'Tin nhắn',
    super.sendButtonAccessibilityLabel = 'Gửi',
    super.unreadMessagesLabel = 'Tin nhắn chưa đọc',
  });
}
