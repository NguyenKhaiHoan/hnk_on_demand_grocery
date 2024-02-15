import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:on_demand_grocery/src/common_widgets/cart_cirle_widget.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: hAppDefaultPaddingR,
              child: CartCircle(),
            )
          ],
          toolbarHeight: 80,
          leadingWidth: 120,
          leading: const Row(children: [
            gapW24,
            Text(
              'GroFast',
              style: HAppStyle.heading3Style,
            )
          ]),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: hAppDefaultPaddingLR,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      image: const DecorationImage(
                          image: AssetImage('assets/logos/logo.png'),
                          fit: BoxFit.fill),
                    ),
                  ),
                  gapW10,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Nguyễn Khải Hoàn',
                        style: HAppStyle.heading4Style,
                      ),
                      gapH4,
                      Text(
                        'Xem hồ sơ',
                        style: HAppStyle.paragraph3Regular
                            .copyWith(color: HAppColor.hGreyColorShade600),
                      )
                    ],
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                  )
                ],
              ),
              gapH20,
              const Text(
                'Tài khoản',
                style: HAppStyle.heading4Style,
              ),
              const ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(EvaIcons.shoppingBagOutline),
                title: Text('Đơn hàng'),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 15,
                ),
              ),
              const ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(EvaIcons.shoppingCartOutline),
                title: Text('Giỏ hàng'),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 15,
                ),
              ),
              const ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(EvaIcons.pricetagsOutline),
                title: Text('Mã ưu đãi'),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 15,
                ),
              ),
              const ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(EvaIcons.bellOutline),
                title: Text('Thông báo'),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 15,
                ),
              ),
              const ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(EvaIcons.externalLinkOutline),
                title: Text('Giới thiệu với bạn bè'),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 15,
                ),
              ),
              const ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(EvaIcons.settingsOutline),
                title: Text('Cài đặt'),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 15,
                ),
              ),
              gapH20,
              const Text(
                'Trợ giúp và hỗ trợ',
                style: HAppStyle.heading4Style,
              ),
              const ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(EvaIcons.headphonesOutline),
                title: Text('Liên hệ'),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 15,
                ),
              ),
              const ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(EvaIcons.questionMarkCircleOutline),
                title: Text('Câu hỏi thường gặp'),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 15,
                ),
              ),
              gapH6,
              const Center(
                child: Text('Đăng xuất'),
              ),
              gapH24,
            ]),
          ),
        ));
  }
}
