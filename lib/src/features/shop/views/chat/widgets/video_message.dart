import 'package:flutter/material.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';

class ImageMessage extends StatelessWidget {
  const ImageMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.6,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              "https://th.bing.com/th/id/OIP.vQ6PNWOFyjFcLFO0mvkGdAHaE6?rs=1&pid=ImgDetMain",
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
