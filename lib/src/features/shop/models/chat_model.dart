import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class ChatModel {
  String? id;
  String? lastMessage;
  String? userId;
  String? storeId;
  ChatModel({
    required this.id,
    this.lastMessage,
    required this.userId,
    required this.storeId,
  });

  static ChatModel empty() => ChatModel(id: '', userId: '', storeId: '');

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'LastMessage': lastMessage,
      'UserId': userId,
      'StoreId': storeId,
    };
  }

  factory ChatModel.fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return ChatModel(
        id: document.id,
        userId: data['UserId'] ?? '',
        storeId: data['StoreId'] ?? '',
        lastMessage: data['LastMessage'] ?? '',
      );
    }
    return ChatModel.empty();
  }
}
