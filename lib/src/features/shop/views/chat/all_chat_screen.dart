import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/common_widgets/no_found_screen_widget.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/personalization/controllers/user_controller.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/chat_controller.dart';
import 'package:on_demand_grocery/src/features/shop/models/chat_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/store_model.dart';
import 'package:on_demand_grocery/src/features/shop/views/chat/chat_tile_widget.dart';
import 'package:on_demand_grocery/src/repositories/store_repository.dart';
import 'package:on_demand_grocery/src/routes/app_pages.dart';

class AllChatScreen extends StatelessWidget {
  AllChatScreen({super.key});

  final chatController = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        leading: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: hAppDefaultPaddingL,
            child: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: const Icon(
                  Icons.arrow_back_ios,
                  size: 20,
                )),
          ),
        ),
        title: const Text(
          'Tin nhắn của bạn',
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.only(
            left: hAppDefaultPadding,
            right: hAppDefaultPadding,
            bottom: hAppDefaultPadding),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Chats')
              .where('UserId', isEqualTo: UserController.instance.user.value.id)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const ShimmerChatTileWidget();
            }

            if (snapshot.hasError) {
              return const Scaffold(
                body: Center(
                  child: Text('Không tải được dữ liệu'),
                ),
              );
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return NotFoundScreenWidget(
                title: 'Không có tin nhắn',
                subtitle: 'Bạn không có tin nhắn với cửa hàng nào ở đây',
                widget: Container(),
                subWidget: Container(),
              );
            }
            final List<ChatModel> list = snapshot.data!.docs
                .map((e) => ChatModel.fromDocumentSnapshot(e))
                .toList();
            return ListView.separated(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  String storeId = list[index].storeId!;
                  String lastMessage = list[index].lastMessage ?? '';
                  return ChatTileWidget(
                      storeId: storeId,
                      ontap: () {
                        Get.toNamed(HAppRoutes.chat,
                            arguments: {'storeId': storeId});
                      },
                      lastMessage: lastMessage);
                },
                separatorBuilder: (context, index) => gapH12,
                itemCount: list.length);
          },
        ),
        // child: Obx(() => FutureBuilder(
        //       key: Key('Chats${chatController.resetData.value.toString()}'),
        //       future: chatController
        //           .fetchAllChats(UserController.instance.user.value.id),
        //       builder: (context, snapshot) {
        //         if (snapshot.connectionState == ConnectionState.waiting) {
        //           return const ShimmerChatTileWidget();
        //         }

        //         if (snapshot.hasError) {
        //           return const Center(
        //             child: Text('Đã xảy ra sự cố. Xin vui lòng thử lại sau.'),
        //           );
        //         }

        //         if (!snapshot.hasData ||
        //             snapshot.data == null ||
        //             snapshot.data!.isEmpty) {
        //           return NotFoundScreenWidget(
        //             title: 'Không có tin nhắn',
        //             subtitle: 'Bạn không có tin nhắn với cửa hàng nào ở đây',
        //             widget: Container(),
        //             subWidget: Container(),
        //           );
        //         } else {
        //           final data = snapshot.data!;
        //           return ListView.separated(
        //               shrinkWrap: true,
        //               scrollDirection: Axis.vertical,
        //               itemBuilder: (context, index) {
        //                 String storeId = data[index].storeId!;
        //                 String lastMessage = data[index].lastMessage ?? '';
        //                 return ChatTileWidget(
        //                     storeId: storeId,
        //                     ontap: () {
        //                       Get.toNamed(HAppRoutes.chat,
        //                           arguments: {'storeId': storeId});
        //                     },
        //                     lastMessage: lastMessage);
        //               },
        //               separatorBuilder: (context, index) => gapH12,
        //               itemCount: data.length);
        //         }
        //       },
        //     )),
      )),
    );
  }
}
