import 'package:flutter/material.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:swipeable_tile/swipeable_tile.dart';
import 'package:vibration/vibration.dart';

class SwipeActionWidget extends StatelessWidget {
  const SwipeActionWidget({
    super.key,
    required this.child,
    required this.function,
    required this.backgroundColorIcon,
    required this.colorIcon,
    required this.icon,
    required this.check,
  });

  final Function(SwipeDirection) function;
  final Widget child;
  final Color backgroundColorIcon;
  final Color colorIcon;
  final IconData icon;
  final int check;

  @override
  Widget build(BuildContext context) {
    return SwipeableTile.swipeToTrigger(
      behavior: HitTestBehavior.translucent,
      isElevated: false,
      color: HAppColor.hBackgroundColor,
      swipeThreshold:
          check == 1 ? 64 / HAppSize.deviceWidth : 84 / HAppSize.deviceWidth,
      direction:
          check == 1 ? SwipeDirection.endToStart : SwipeDirection.startToEnd,
      onSwiped: function,
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
              alignment:
                  check == 1 ? Alignment.centerRight : Alignment.centerLeft,
              child: Transform.scale(
                scale: Tween<double>(
                  begin: 0.0,
                  end: 1,
                )
                    .animate(
                      CurvedAnimation(
                        parent: progress,
                        curve: const Interval(0.5, 1.0, curve: Curves.linear),
                      ),
                    )
                    .value,
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: backgroundColorIcon,
                  ),
                  child: Icon(
                    icon,
                    color: colorIcon,
                    size: 17,
                  ),
                ),
              ),
            );
          },
        );
      },
      key: UniqueKey(),
      child: child,
    );
  }
}
