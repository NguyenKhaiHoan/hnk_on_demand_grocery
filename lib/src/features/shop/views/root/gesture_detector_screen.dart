import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/cart_controller.dart';

class GestureDetectorScreen extends StatelessWidget {
  GestureDetectorScreen({super.key, required this.screen});

  Widget screen;

  final cartController = Get.put(CartController());

  void handleAllGestures() {
    cartController.toggleAnimation.value = false;
    cartController.listIdToggleAnimation.clear();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTapDown: (_) => handleAllGestures(),
        onTapUp: (_) => handleAllGestures(),
        onTapCancel: handleAllGestures,
        onSecondaryTap: handleAllGestures,
        onSecondaryTapDown: (_) => handleAllGestures(),
        onSecondaryTapUp: (_) => handleAllGestures(),
        onSecondaryTapCancel: handleAllGestures,
        onTertiaryTapDown: (_) => handleAllGestures(),
        onTertiaryTapUp: (_) => handleAllGestures(),
        onTertiaryTapCancel: handleAllGestures,
        onDoubleTapDown: (_) => handleAllGestures(),
        onDoubleTap: handleAllGestures,
        onDoubleTapCancel: handleAllGestures,
        onLongPressDown: (_) => handleAllGestures(),
        onLongPressCancel: handleAllGestures,
        onLongPress: handleAllGestures,
        onLongPressStart: (_) => handleAllGestures(),
        onLongPressMoveUpdate: (_) => handleAllGestures(),
        onLongPressUp: handleAllGestures,
        onLongPressEnd: (_) => handleAllGestures(),
        onSecondaryLongPressDown: (_) => handleAllGestures(),
        onSecondaryLongPressCancel: handleAllGestures,
        onSecondaryLongPress: handleAllGestures,
        onSecondaryLongPressStart: (_) => handleAllGestures(),
        onSecondaryLongPressMoveUpdate: (_) => handleAllGestures(),
        onSecondaryLongPressUp: handleAllGestures,
        onSecondaryLongPressEnd: (_) => handleAllGestures(),
        onTertiaryLongPressDown: (_) => handleAllGestures(),
        onTertiaryLongPressCancel: handleAllGestures,
        onTertiaryLongPress: handleAllGestures,
        onTertiaryLongPressStart: (_) => handleAllGestures(),
        onTertiaryLongPressMoveUpdate: (_) => handleAllGestures(),
        onTertiaryLongPressUp: handleAllGestures,
        onTertiaryLongPressEnd: (_) => handleAllGestures(),
        onVerticalDragDown: (_) => handleAllGestures(),
        onVerticalDragStart: (_) => handleAllGestures(),
        onVerticalDragUpdate: (_) => handleAllGestures(),
        onVerticalDragEnd: (_) => handleAllGestures(),
        onVerticalDragCancel: handleAllGestures,
        onHorizontalDragDown: (_) => handleAllGestures(),
        onHorizontalDragStart: (_) => handleAllGestures(),
        onHorizontalDragUpdate: (_) => handleAllGestures(),
        onHorizontalDragEnd: (_) => handleAllGestures(),
        onHorizontalDragCancel: handleAllGestures,
        onForcePressStart: (_) => handleAllGestures(),
        onForcePressPeak: (_) => handleAllGestures(),
        onForcePressUpdate: (_) => handleAllGestures(),
        onForcePressEnd: (_) => handleAllGestures(),
        child: screen);
  }
}
