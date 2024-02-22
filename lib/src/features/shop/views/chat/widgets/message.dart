import 'package:flutter/material.dart';
import 'package:on_demand_grocery/src/features/shop/models/chat_message_model.dart';
import 'package:on_demand_grocery/src/features/shop/views/chat/widgets/text_message.dart';
import 'package:on_demand_grocery/src/features/shop/views/chat/widgets/image_message.dart';

class Message extends StatelessWidget {
  const Message({
    super.key,
    required this.message,
  });

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    Widget messageContaint(ChatMessage message) {
      switch (message.messageType) {
        case ChatMessageType.text:
          return TextMessage(message: message);
        case ChatMessageType.video:
          return const SizedBox();
        case ChatMessageType.image:
          return const ImageMessage();
        default:
          return const SizedBox();
      }
    }

    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment:
            message.isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          messageContaint(message),
        ],
      ),
    );
  }
}
