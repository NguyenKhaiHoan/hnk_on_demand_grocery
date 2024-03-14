import 'package:flutter/material.dart';
import 'package:image_network/image_network.dart';
import 'package:on_demand_grocery/src/common_widgets/custom_shimmer_widget.dart';

class ImageMessage extends StatelessWidget {
  const ImageMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.6,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ImageNetwork(
            image:
                'https://th.bing.com/th/id/OIP.vQ6PNWOFyjFcLFO0mvkGdAHaE6?rs=1&pid=ImgDetMain',
            height: 100,
            width: 100,
            duration: 500,
            curve: Curves.easeIn,
            onPointer: true,
            debugPrint: false,
            fullScreen: false,
            fitAndroidIos: BoxFit.cover,
            fitWeb: BoxFitWeb.cover,
            borderRadius: BorderRadius.circular(10),
            onLoading: CustomShimmerWidget.rectangular(width: 100, height: 100),
            onError: const Icon(
              Icons.error,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
