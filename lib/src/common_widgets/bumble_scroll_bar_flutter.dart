// import 'package:flutter/material.dart';

// enum StrokeConnerType { rounded, sharp }

// class BumbleScrollbar extends StatefulWidget {
//   const BumbleScrollbar({
//     super.key,
//     required this.child,
//     this.strokeWidth = 6,
//     this.strokeHeight = 100,
//     this.backgroundColor = Colors.black12,
//     this.thumbColor = Colors.white,
//     this.alignment = Alignment.topRight,
//     this.padding = EdgeInsets.zero,
//     this.strokeConnerType = StrokeConnerType.rounded,
//     this.showScrollbar = true,
//     this.scrollbarMargin = const EdgeInsets.all(8.0),
//   });

//   final Widget child;
//   final double strokeWidth;
//   final double strokeHeight;
//   final Color thumbColor;
//   final Color backgroundColor;
//   final AlignmentGeometry alignment;
//   final EdgeInsetsGeometry padding;
//   final EdgeInsetsGeometry scrollbarMargin;
//   final StrokeConnerType strokeConnerType;
//   final bool showScrollbar;

//   @override
//   _BumbleScrollbarState createState() => _BumbleScrollbarState();
// }

// class _BumbleScrollbarState extends State<BumbleScrollbar> {
//   late ScrollController _controller;
//   late double _thumbHeight;
//   late double _strokeHeight;
//   late bool _showScrollbar;

//   double _thumbPosition = 0;

//   @override
//   void initState() {
//     super.initState();
//     _showScrollbar = widget.showScrollbar;
//     _thumbHeight = widget.strokeHeight * 0.2;
//     _strokeHeight = widget.strokeHeight;
//     _controller = ScrollController()..addListener(_scrollListener);
//   }

//   void _scrollListener() {
//     if (_controller.hasClients) {
//       final double maxScrollSize = _controller.position.maxScrollExtent;
//       final double currentPosition = _controller.position.pixels;
//       final scrollPosition =
//           ((_strokeHeight - _thumbHeight) / (maxScrollSize / currentPosition));

//       setState(() {
//         _thumbPosition = scrollPosition.clamp(0, _strokeHeight - _thumbHeight);
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _controller.removeListener(_scrollListener);
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         _child,
//         if (_showScrollbar) _scrollbar,
//       ],
//     );
//   }

//   Widget get _child {
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       padding: widget.padding,
//       controller: _controller,
//       child: widget.child,
//     );
//   }

//   Widget get _scrollbar {
//     final width = widget.strokeWidth;

//     final connerRadius = widget.strokeConnerType == StrokeConnerType.rounded
//         ? BorderRadius.circular(width)
//         : BorderRadius.zero;

//     return Align(
//       alignment: widget.alignment,
//       child: Padding(
//         padding: widget.scrollbarMargin,
//         child: Stack(
//           children: [
//             Container(
//               width: width,
//               height: _strokeHeight,
//               decoration: BoxDecoration(
//                 color: widget.backgroundColor,
//                 borderRadius: connerRadius,
//               ),
//             ),
//             AnimatedPositioned(
//               duration: const Duration(milliseconds: 100),
//               top: _thumbPosition,
//               child: Container(
//                 width: width,
//                 height: _thumbHeight,
//                 decoration: BoxDecoration(
//                   color: widget.thumbColor,
//                   borderRadius: connerRadius,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';

class CustomBumbleScrollbar extends StatefulWidget {
  CustomBumbleScrollbar({
    Key? key,
    required this.child,
    required this.heightContent,
  }) : super(key: key);

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
