// import 'package:eva_icons_flutter/eva_icons_flutter.dart';
// import 'package:flutter/material.dart';
// import 'package:on_demand_grocery/src/common_widgets/cart_cirle_widget.dart';
// import 'package:on_demand_grocery/src/constants/app_colors.dart';
// import 'package:on_demand_grocery/src/constants/app_sizes.dart';
// import 'package:on_demand_grocery/src/utils/theme/app_style.dart';

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           actions: [
//             Padding(
//               padding: hAppDefaultPaddingR,
//               child: CartCircle(),
//             )
//           ],
//           toolbarHeight: 80,
//           leadingWidth: 120,
//           leading: const Row(children: [
//             gapW24,
//             Text(
//               'GroFast',
//               style: HAppStyle.heading3Style,
//             )
//           ]),
//         ),
//         body: SingleChildScrollView(
//           child: Padding(
//             padding: hAppDefaultPaddingLR,
//             child:
//                 Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               Row(
//                 children: [
//                   Container(
//                     width: 80,
//                     height: 80,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(100),
//                       image: const DecorationImage(
//                           image: AssetImage('assets/logos/logo.png'),
//                           fit: BoxFit.fill),
//                     ),
//                   ),
//                   gapW10,
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'Nguyễn Khải Hoàn',
//                         style: HAppStyle.heading4Style,
//                       ),
//                       gapH4,
//                       Text(
//                         'Xem hồ sơ',
//                         style: HAppStyle.paragraph3Regular
//                             .copyWith(color: HAppColor.hGreyColorShade600),
//                       )
//                     ],
//                   ),
//                   const Spacer(),
//                   const Icon(
//                     Icons.arrow_forward_ios,
//                     size: 15,
//                   )
//                 ],
//               ),
//               gapH20,
//               const Text(
//                 'Tài khoản',
//                 style: HAppStyle.heading4Style,
//               ),
//               const ListTile(
//                 contentPadding: EdgeInsets.zero,
//                 leading: Icon(EvaIcons.shoppingBagOutline),
//                 title: Text('Đơn hàng'),
//                 trailing: Icon(
//                   Icons.arrow_forward_ios,
//                   size: 15,
//                 ),
//               ),
//               const ListTile(
//                 contentPadding: EdgeInsets.zero,
//                 leading: Icon(EvaIcons.shoppingCartOutline),
//                 title: Text('Giỏ hàng'),
//                 trailing: Icon(
//                   Icons.arrow_forward_ios,
//                   size: 15,
//                 ),
//               ),
//               const ListTile(
//                 contentPadding: EdgeInsets.zero,
//                 leading: Icon(EvaIcons.pricetagsOutline),
//                 title: Text('Mã ưu đãi'),
//                 trailing: Icon(
//                   Icons.arrow_forward_ios,
//                   size: 15,
//                 ),
//               ),
//               const ListTile(
//                 contentPadding: EdgeInsets.zero,
//                 leading: Icon(EvaIcons.bellOutline),
//                 title: Text('Thông báo'),
//                 trailing: Icon(
//                   Icons.arrow_forward_ios,
//                   size: 15,
//                 ),
//               ),
//               const ListTile(
//                 contentPadding: EdgeInsets.zero,
//                 leading: Icon(EvaIcons.externalLinkOutline),
//                 title: Text('Giới thiệu với bạn bè'),
//                 trailing: Icon(
//                   Icons.arrow_forward_ios,
//                   size: 15,
//                 ),
//               ),
//               const ListTile(
//                 contentPadding: EdgeInsets.zero,
//                 leading: Icon(EvaIcons.settingsOutline),
//                 title: Text('Cài đặt'),
//                 trailing: Icon(
//                   Icons.arrow_forward_ios,
//                   size: 15,
//                 ),
//               ),
//               gapH20,
//               const Text(
//                 'Trợ giúp và hỗ trợ',
//                 style: HAppStyle.heading4Style,
//               ),
//               const ListTile(
//                 contentPadding: EdgeInsets.zero,
//                 leading: Icon(EvaIcons.headphonesOutline),
//                 title: Text('Liên hệ'),
//                 trailing: Icon(
//                   Icons.arrow_forward_ios,
//                   size: 15,
//                 ),
//               ),
//               const ListTile(
//                 contentPadding: EdgeInsets.zero,
//                 leading: Icon(EvaIcons.questionMarkCircleOutline),
//                 title: Text('Câu hỏi thường gặp'),
//                 trailing: Icon(
//                   Icons.arrow_forward_ios,
//                   size: 15,
//                 ),
//               ),
//               gapH6,
//               const Center(
//                 child: Text('Đăng xuất'),
//               ),
//               gapH24,
//             ]),
//           ),
//         ));
//   }
// }

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:swipeable_tile/swipeable_tile.dart';
import 'package:vibration/vibration.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();
  Messenge? _selectedPerson;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Swipe To Reply',
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(children: <Widget>[
              ...messengeList.map(
                (Messenge person) => SwipeableTile.swipeToTrigger(
                  behavior: HitTestBehavior.translucent,
                  isElevated: false,
                  color: Colors.white,
                  swipeThreshold: 0.2,
                  direction: SwipeDirection.endToStart,
                  onSwiped: (_) {
                    _focusNode.requestFocus();
                    setState(() {
                      _selectedPerson = person;
                    });
                  },
                  backgroundBuilder: (
                    _,
                    SwipeDirection direction,
                    AnimationController progress,
                  ) {
                    bool vibrated = false;
                    return AnimatedBuilder(
                      animation: progress,
                      builder: (_, __) {
                        if (progress.value > 0.9999 && !vibrated) {
                          Vibration.vibrate(duration: 40);
                          vibrated = true;
                        } else if (progress.value < 0.9999) {
                          vibrated = false;
                        }
                        return Container(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: Transform.scale(
                              scale: Tween<double>(
                                begin: 0.0,
                                end: 1.2,
                              )
                                  .animate(
                                    CurvedAnimation(
                                      parent: progress,
                                      curve: const Interval(0.5, 1.0,
                                          curve: Curves.linear),
                                    ),
                                  )
                                  .value,
                              child: Icon(
                                Icons.reply,
                                color: Colors.black.withOpacity(0.7),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  key: UniqueKey(),
                  child: MessageBubble(
                    message: person.message,
                  ),
                ),
              ),
            ]),
          ),
          ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
              child: Container(
                color: Colors.grey.shade200.withOpacity(0.5),
                child: SafeArea(
                  top: false,
                  child: Column(
                    children: <Widget>[
                      _selectedPerson != null
                          ? Container(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                children: <Widget>[
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.reply_rounded,
                                      color: Colors.blue,
                                      size: 30,
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          // _selectedPerson!.name,
                                          "Đang trả lời",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            color: Colors.blue,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 4.0,
                                        ),
                                        Text(
                                          _selectedPerson!.message,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedPerson = null;
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.black.withOpacity(0.6),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox.shrink(),
                      TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        onSubmitted: (_) {
                          _focusNode.canRequestFocus;
                        },
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(16),
                          hintText: 'Gửi tin nhắn ...',
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.send),
                            onPressed: () {},
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
          ),
        ],
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String message;
  const MessageBubble({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: const Color(0xFFa1ffb7),
                borderRadius: BorderRadius.circular(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  height: 8.0,
                ),
                Text(message),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

List<Messenge> messengeList = <Messenge>[
  Messenge(
      message:
          'I heard babies needs more love nowadays. Please hug and kiss me more often.'),
  Messenge(
      message:
          'I wan\'t to sleep more don\'t wake me up. I will stay awake all night I promise.'),
  Messenge(
      message:
          'What happened? Everyone is alright? I was under the blanket. It was so dark I can\'t believe.'),
  Messenge(message: 'I can\'t believe how much I am happy to see you.'),
  Messenge(message: 'Who wants to play with me? I am ready now.'),
];

class Messenge {
  final String message;

  Messenge({
    required this.message,
  });
}
