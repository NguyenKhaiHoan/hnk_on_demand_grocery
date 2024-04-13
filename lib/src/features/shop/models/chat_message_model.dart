// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:on_demand_grocery/src/features/shop/models/product_model.dart';
// import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

// enum MessageType { Default, Product }

// class ChatMessageModel {
//   types.Message? message;
//   MessageType? messageType;
//   ProductModel? product;

//   ChatMessageModel({this.message, this.product, required this.messageType});

//   Map<String, dynamic> toJson() {
//     return {
//       'Message': message,
//       'MessageType': messageType!.name,
//       'Product': product,
//     };
//   }

//   factory ChatMessageModel.fromDocumentSnapshot(
//       DocumentSnapshot<Map<String, dynamic>> document) {
//     final data = document.data()!;
//     return ChatMessageModel(
//       message: data['Message'] != null
//           ? types.Message.fromJson(data['Message'])
//           : null,
//       messageType: MessageType.values.byName(data['MessageType']),
//       product: data['Product'] != null
//           ? ProductModel.fromDocumentSnapshot(data['Product'])
//           : null,
//     );
//   }
// }
