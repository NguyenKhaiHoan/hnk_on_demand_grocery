import 'dart:convert';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/personalization/controllers/user_controller.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';
import 'package:uuid/uuid.dart';

class ChatOrderRealtimeScreen extends StatefulWidget {
  const ChatOrderRealtimeScreen({super.key});

  @override
  State<ChatOrderRealtimeScreen> createState() =>
      _ChatOrderRealtimeScreenState();
}

class _ChatOrderRealtimeScreenState extends State<ChatOrderRealtimeScreen> {
  final String orderId = Get.arguments['orderId'];

  final List<types.Message> _messages = [];
  final _user = types.User(
    id: UserController.instance.user.value.id,
  );

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
    DatabaseReference ref =
        FirebaseDatabase.instance.ref().child('Chats/$orderId');
    ref.push().set({'message': message.toJson()});
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

    setState(() {
      _messages[index] = updatedMessage;
    });
  }

  void _handleAttachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: SizedBox(
          height: 144,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleImageSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Ảnh'),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Hủy'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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

  void _loadMessages() async {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref().child('Chats/$orderId');
    ref.onChildAdded.listen((event) {
      if (event.snapshot.value != null) {
        DataSnapshot snapshot = event.snapshot;
        var message = types.Message.fromJson(
            jsonDecode(jsonEncode(((snapshot.value as Map)['message']))));
        setState(() {
          _messages.add(message);
        });
      } else {
        // var message = types.Message.fromJson(dataMap);
      }
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          centerTitle: false,
          automaticallyImplyLeading: false,
          backgroundColor: HAppColor.hTransparentColor,
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
              ],
            ),
          ),
        ),
        body: Chat(
          messages: _messages,
          onPreviewDataFetched: _handlePreviewDataFetched,
          onSendPressed: _handleSendPressed,
          onAttachmentPressed: _handleAttachmentPressed,
          showUserAvatars: true,
          showUserNames: true,
          user: _user,
          theme: const DefaultChatTheme(
            backgroundColor: HAppColor.hBackgroundColor,
            seenIcon: Text(
              'read',
              style: HAppStyle.paragraph3Regular,
            ),
          ),
        ),
      );
}
