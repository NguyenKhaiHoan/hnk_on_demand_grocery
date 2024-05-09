import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/features/shop/models/chat_model.dart';
import 'package:on_demand_grocery/src/repositories/chat_repository.dart';
import 'package:on_demand_grocery/src/utils/utils.dart';

class ChatController extends GetxController {
  var resetData = false.obs;

  static ChatController get instance => Get.find();

  final chatRepository = Get.put(ChatRepository());

  Future<List<ChatModel>> fetchAllChats(String userId) async {
    try {
      final chats = await chatRepository.getAllChats(userId);
      return chats;
    } catch (e) {
      HAppUtils.showSnackBarError('Lỗi', e.toString());
      return [];
    }
  }

  String getChatId(String userId, String storeId) {
    List<String> ids = [userId, storeId];
    ids.sort();
    String chatId = ids.join('');
    return chatId;
  }

  Future<void> checkChatExists(String userId, String storeId) async {
    String chatId = getChatId(userId, storeId);

    final result =
        await FirebaseFirestore.instance.collection('Chats').doc(chatId).get();
    if (!result.exists) {
      var chat = ChatModel(
          id: chatId, userId: userId, storeId: storeId, lastMessage: '');
      await FirebaseFirestore.instance
          .collection('Chats')
          .doc(chatId)
          .set(chat.toJson());
    }
  }
}
