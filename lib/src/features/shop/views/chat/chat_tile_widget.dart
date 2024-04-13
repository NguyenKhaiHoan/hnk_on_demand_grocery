import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_network/image_network.dart';
import 'package:on_demand_grocery/src/common_widgets/custom_shimmer_widget.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/features/shop/models/store_model.dart';
import 'package:on_demand_grocery/src/repositories/store_repository.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';

class ChatTileWidget extends StatefulWidget {
  const ChatTileWidget(
      {super.key,
      required this.storeId,
      required this.ontap,
      required this.lastMessage});

  final String storeId;
  final String lastMessage;

  final Function() ontap;

  @override
  State<ChatTileWidget> createState() => _ChatTileWidgetState();
}

class _ChatTileWidgetState extends State<ChatTileWidget> {
  var store = StoreModel.empty().obs;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      store.value =
          await StoreRepository.instance.getStoreInformation(widget.storeId);
    });
  }

  @override
  Widget build(BuildContext context) {
    String getSubtitle(int index) {
      List<String> parts = widget.lastMessage.split('-');
      switch (index) {
        case 0:
          return parts[0];
        case 1:
          return parts.length > 1 ? ' • ${parts[1]}' : '';
      }
      return '';
    }

    return Obx(() => ListTile(
          contentPadding: EdgeInsets.zero,
          onTap: widget.ontap,
          dense: false,
          leading: store.value.storeImage == ''
              ? const CustomShimmerWidget.circular(width: 50, height: 50)
              : ImageNetwork(
                  image: store.value.storeImage,
                  height: 50,
                  width: 50,
                  borderRadius: BorderRadius.circular(100),
                  onLoading:
                      const CustomShimmerWidget.circular(width: 50, height: 50),
                ),
          title: Text(
            store.value.name,
            style: HAppStyle.heading4Style,
          ),
          subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                    child: Text(
                  getSubtitle(0),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: HAppStyle.paragraph2Regular
                      .copyWith(color: HAppColor.hGreyColorShade600),
                )),
                Text(
                  getSubtitle(1),
                  style: HAppStyle.paragraph2Regular
                      .copyWith(color: HAppColor.hGreyColorShade600),
                )
              ]),
        ));
  }
}

class ShimmerChatTileWidget extends StatelessWidget {
  const ShimmerChatTileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: false,
      leading: const CustomShimmerWidget.circular(width: 50, height: 50),
      title: CustomShimmerWidget.rectangular(
        height: 16,
        width: 100,
      ),
      subtitle: CustomShimmerWidget.rectangular(
        height: 12,
        width: 50,
      ),
    );
  }
}
