import 'package:cross_file_image/cross_file_image.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/review_controller.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';

class WriteReviewWidget extends StatelessWidget {
  WriteReviewWidget(
      {super.key, required this.orderId, required this.productId});
  final String productId;
  final String orderId;

  final reviewController = Get.put(ReviewController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: hAppDefaultPaddingLR,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          gapH24,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Viết đánh giá',
                style: HAppStyle.heading4Style,
              ),
              GestureDetector(
                onTap: () {
                  Get.back();
                  reviewController.resetReview();
                },
                child: const Icon(EvaIcons.close),
              )
            ],
          ),
          Divider(
            color: HAppColor.hGreyColorShade300,
          ),
          gapH12,
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Xếp hạng: '),
            RatingBar.builder(
              itemSize: 25,
              initialRating: 0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.only(right: 4.0),
              itemBuilder: (context, _) => const Icon(
                EvaIcons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                reviewController.rating.value = rating;
              },
            )
          ]),
          gapH12,
          TextFormField(
            minLines: 3,
            keyboardType: TextInputType.multiline,
            maxLines: 3,
            maxLength: 100,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: HAppColor.hGreyColorShade300, width: 1),
                  borderRadius: BorderRadius.circular(10)),
              focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: HAppColor.hGreyColorShade300, width: 1),
                  borderRadius: BorderRadius.circular(10)),
              hintText: 'Hãy viết đánh giá của bạn (tùy chọn)',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            controller: reviewController.reviewTextController,
          ),
          gapH6,
          SizedBox(
              width: double.infinity,
              height: 100,
              child: Obx(() => ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: reviewController.productImages.length > 5
                        ? 6
                        : reviewController.productImages.length + 1,
                    itemBuilder: (BuildContext context, index) {
                      if (index == reviewController.productImages.length) {
                        return GestureDetector(
                          child: Container(
                            height: 70,
                            width: 70,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: HAppColor.hGreyColorShade300,
                                    width: 1)),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      reviewController.pickReviewImage();
                                    },
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: HAppColor.hBluePrimaryColor,
                                      ),
                                      child: const Icon(
                                        EvaIcons.camera,
                                        size: 20,
                                        color: HAppColor.hWhiteColor,
                                      ),
                                    ),
                                  ),
                                  gapH4,
                                  Text(
                                    'Thêm ảnh',
                                    style: HAppStyle.paragraph3Regular.copyWith(
                                        color: HAppColor.hGreyColorShade600),
                                  )
                                ]),
                          ),
                        );
                      }
                      return Container(
                        alignment: Alignment.topRight,
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                                image: XFileImage(
                                    reviewController.productImages[index]))),
                        child: GestureDetector(
                          onTap: () =>
                              reviewController.productImages.removeAt(index),
                          child: Container(
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10))),
                            child: const Icon(
                              EvaIcons.close,
                              size: 15,
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        gapW10,
                  ))),
          const Spacer(),
          ElevatedButton(
            onPressed: () {
              reviewController.writeReview(productId, orderId);
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: HAppColor.hBluePrimaryColor,
                fixedSize:
                    Size(HAppSize.deviceWidth - hAppDefaultPadding * 2, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50))),
            child: Text("Gửi đánh giá",
                style: HAppStyle.label2Bold
                    .copyWith(color: HAppColor.hWhiteColor)),
          ),
          gapH12
        ],
      ),
    );
  }
}
