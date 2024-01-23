import 'package:enefty_icons/enefty_icons.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:on_demand_grocery/src/common_widgets/cart_cirle_widget.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/product/models/product_models.dart';
import 'package:on_demand_grocery/src/features/store/models/store_model.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';

class WishlistBottomAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const WishlistBottomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: HAppColor.hBackgroundColor,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TabBar(
                  labelStyle: HAppStyle.label4Regular,
                  isScrollable: true,
                  indicatorColor: HAppColor.hBluePrimaryColor,
                  labelColor: HAppColor.hBluePrimaryColor,
                  unselectedLabelColor: Colors.black,
                  tabs: [
                    Tab(
                      text: 'Sản phẩm (${isFavoritedProduct.length})',
                    ),
                    Tab(
                      text: 'Cửa hàng (${isFavoritedStore.length})',
                    ),
                  ]),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                color: HAppColor.hBackgroundColor,
                height: 48,
                width: 48,
                child: Center(
                    child: Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Icon(EvaIcons.options2Outline),
                )),
              ),
            ),
          ],
        ));
  }

  @override
  Size get preferredSize => const Size.fromHeight(48);
}
