import 'package:on_demand_grocery/src/features/shop/models/product_model.dart';

enum ChatMessageType { text, image, video }

enum MessageStatus { not_sent, not_view, viewed }

class ChatMessage {
  final String text;
  final ChatMessageType messageType;
  final MessageStatus messageStatus;
  final bool isSender;
  final ProductModel? product;

  ChatMessage(
      {this.text = '',
      required this.messageType,
      required this.messageStatus,
      required this.isSender,
      this.product});
}

List<ChatMessage> demeChatMessages = [
  ChatMessage(
    text: "Xin chào, chúng tôi có thể giúp gì được cho bạn ?",
    messageType: ChatMessageType.text,
    messageStatus: MessageStatus.viewed,
    isSender: false,
  ),
];
