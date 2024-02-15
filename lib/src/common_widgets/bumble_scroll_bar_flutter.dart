import 'package:flutter/material.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';

class CustomBumbleScrollbar extends StatefulWidget {
  const CustomBumbleScrollbar({
    super.key,
    required this.child,
    required this.heightContent,
  });

  final Widget child;
  final double heightContent;

  @override
  _CustomBumbleScrollbarState createState() => _CustomBumbleScrollbarState();
}

class _CustomBumbleScrollbarState extends State<CustomBumbleScrollbar> {
  late ScrollController _controller;
  late double _thumbWidth;
  final double strokeWidth = HAppSize.deviceWidth * 0.15;

  final double strokeHeight = 6;
  final Color thumbColor = HAppColor.hBluePrimaryColor;
  final Color backgroundColor = HAppColor.hWhiteColor;
  final AlignmentGeometry alignment = Alignment.bottomCenter;
  final EdgeInsetsGeometry scrollbarMargin = const EdgeInsets.all(8.0);

  double _thumbPosition = 0;

  @override
  void initState() {
    super.initState();
    _thumbWidth = strokeWidth * 0.3;
    _controller = ScrollController()..addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_controller.hasClients) {
      final double maxScrollSize = _controller.position.maxScrollExtent;
      final double currentPosition = _controller.position.pixels;
      final scrollPosition =
          ((strokeWidth - _thumbWidth) / (maxScrollSize / currentPosition));

      setState(() {
        _thumbPosition = scrollPosition.clamp(0, strokeWidth - _thumbWidth);
      });
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_scrollListener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.heightContent,
      child: Stack(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: _controller,
            child: widget.child,
          ),
          Align(
            alignment: alignment,
            child: Stack(
              children: [
                Container(
                  width: strokeWidth,
                  height: strokeHeight,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(strokeHeight),
                  ),
                ),
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 100),
                  left: _thumbPosition,
                  child: Container(
                    width: _thumbWidth,
                    height: strokeHeight,
                    decoration: BoxDecoration(
                      color: thumbColor,
                      borderRadius: BorderRadius.circular(strokeHeight),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
