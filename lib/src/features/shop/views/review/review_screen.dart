
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:image_network/image_network.dart';
import 'package:intl/intl.dart';
import 'package:lorem_ipsum/lorem_ipsum.dart';
import 'package:on_demand_grocery/src/common_widgets/custom_shimmer_widget.dart';
import 'package:on_demand_grocery/src/common_widgets/user_image_logo.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
import 'package:on_demand_grocery/src/features/personalization/models/user_model.dart';
import 'package:on_demand_grocery/src/features/shop/controllers/review_controller.dart';
import 'package:on_demand_grocery/src/features/shop/models/product_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/review_model.dart';
import 'package:on_demand_grocery/src/repositories/user_repository.dart';
import 'package:on_demand_grocery/src/utils/theme/app_style.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:readmore/readmore.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final List<double> rates = [0.1, 0.3, 0.5, 0.7, 0.9];

  int length = Get.arguments['length'];
  ProductModel product = Get.arguments['product'];
  String storeName = Get.arguments['storeName'];

  final reviewController = Get.put(ReviewController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        leading: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: hAppDefaultPadding),
            child: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: const Icon(
                  Icons.arrow_back_ios,
                  size: 20,
                )),
          ),
        ),
        title: const Text("Đánh giá"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
            hAppDefaultPadding, 0, hAppDefaultPadding, hAppDefaultPadding),
        child: Column(children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(TextSpan(
                          style: HAppStyle.heading3Style,
                          text: '4.3',
                          children: [
                            TextSpan(
                                text: '/5',
                                style: HAppStyle.paragraph1Regular.copyWith(
                                    color: HAppColor.hGreyColorShade600))
                          ])),
                      Text(
                        'Dựa trên $length Đánh giá',
                        style: HAppStyle.paragraph2Regular
                            .copyWith(color: HAppColor.hGreyColorShade600),
                      ),
                      gapH10,
                      RatingBar.builder(
                        itemSize: 20,
                        initialRating: 4.3,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding: const EdgeInsets.only(right: 4.0),
                        itemBuilder: (context, _) => const Icon(
                          EvaIcons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {},
                      ),
                    ]),
              ),
              Expanded(
                flex: 1,
                child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: 5,
                    reverse: true,
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          const Spacer(),
                          Text(
                            "${index + 1}",
                            style: HAppStyle.paragraph3Regular
                                .copyWith(color: HAppColor.hGreyColorShade600),
                          ),
                          gapW4,
                          const Icon(
                            EvaIcons.star,
                            color: Colors.amber,
                            size: 15,
                          ),
                          gapW4,
                          LinearPercentIndicator(
                            barRadius: const Radius.circular(100),
                            backgroundColor: HAppColor.hGreyColorShade300,
                            width: (HAppSize.deviceWidth / 2.8),
                            lineHeight: 5,
                            animation: true,
                            animationDuration: 2000,
                            percent: rates[index],
                            progressColor: Colors.amber,
                          )
                        ],
                      );
                    }),
              )
            ],
          ),
          gapH24,
          FutureBuilder(
            future: reviewController.fetchAllProductReview(product.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const ShimmerReviewItemWidget();
              }

              if (snapshot.hasError) {
                return const Center(
                  child: Text('Đã xảy ra sự cố. Xin vui lòng thử lại sau.'),
                );
              }

              if (!snapshot.hasData || snapshot.data == null) {
                return const Text('Không có đánh giá được hiển thị');
              } else {
                final list = snapshot.data!;

                return ListView.separated(
                  shrinkWrap: true,
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return ReviewItemWidget(
                      review: list[index],
                      storeName: storeName,
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        gapH12,
                        Divider(
                          color: HAppColor.hGreyColorShade300,
                        )
                      ],
                    );
                  },
                );
              }
            },
          ),
          gapH24
        ]),
      ),
    );
  }
}

class ReviewItemWidget extends StatefulWidget {
  const ReviewItemWidget({
    super.key,
    required this.review,
    required this.storeName,
  });

  final String storeName;
  final ReviewModel review;

  @override
  State<ReviewItemWidget> createState() => _ReviewItemWidgetState();
}

class _ReviewItemWidgetState extends State<ReviewItemWidget> {
  var user = UserModel.empty().obs;

  final String discription =
      loremIpsum(words: 30, paragraphs: 1, initWithLorem: true);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      user.value = await UserRepository.instance.getUserInformation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Obx(() => user.value.profileImage == ''
                ? Image.asset(
                    'assets/logos/logo.png',
                    height: 40,
                    width: 40,
                  )
                : ImageNetwork(
                    image: user.value.profileImage,
                    height: 40,
                    width: 40,
                    borderRadius: BorderRadius.circular(100),
                    onLoading: const CustomShimmerWidget.circular(
                        width: 40, height: 40),
                  )),
            gapW10,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() => Text(
                      user.value.name,
                      style: HAppStyle.heading5Style,
                    )),
                Row(
                  children: [
                    RatingBar.builder(
                      itemSize: 10,
                      initialRating: 4.3,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.only(right: 4.0),
                      itemBuilder: (context, _) => const Icon(
                        EvaIcons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {},
                    ),
                    gapW10,
                    Text(
                      DateFormat('EEEE, d-M-y', 'vi')
                          .format(widget.review.uploadTime),
                      style: HAppStyle.paragraph3Regular
                          .copyWith(color: HAppColor.hGreyColorShade600),
                    )
                  ],
                ),
              ],
            ),
            const Spacer(),
            const Icon(EvaIcons.moreVerticalOutline)
          ],
        ),
        widget.review.review != null || widget.review.review == ""
            ? Container(
                margin: const EdgeInsets.only(top: 12),
                child: ReadMoreText(
                  widget.review.review!,
                  trimLines: 2,
                  style: HAppStyle.paragraph2Regular
                      .copyWith(color: HAppColor.hGreyColorShade600),
                  trimMode: TrimMode.Line,
                  trimCollapsedText: 'Hiển thị thêm',
                  trimExpandedText: ' Rút gọn',
                  moreStyle: HAppStyle.label3Bold
                      .copyWith(color: HAppColor.hBluePrimaryColor),
                  lessStyle: HAppStyle.label3Bold
                      .copyWith(color: HAppColor.hBluePrimaryColor),
                ),
              )
            : Container(),
        widget.review.images != null || widget.review.images!.isNotEmpty
            ? Container(
                margin: const EdgeInsets.only(top: 12),
                child: SizedBox(
                    width: double.infinity,
                    height: 100,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.review.images!.length > 5
                          ? 5
                          : widget.review.images!.length,
                      itemBuilder: (BuildContext context, indexPrivate) {
                        return ImageNetwork(
                          image: widget.review.images![indexPrivate],
                          height: 100,
                          width: 100,
                          onLoading: CustomShimmerWidget.rectangular(
                            height: 100,
                            width: 100,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          gapW10,
                    )))
            : Container(),
        widget.review.review != null ||
                widget.review.review == "" ||
                widget.review.images != null ||
                widget.review.images!.isNotEmpty
            ? Align(
                alignment: Alignment.centerRight,
                child: Container(
                  width: HAppSize.deviceWidth - hAppDefaultPadding - 50,
                  margin: const EdgeInsets.only(top: 12),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: HAppColor.hGreyColorShade300),
                  child: Padding(
                    padding: const EdgeInsets.all(hAppDefaultPadding),
                    child: Column(children: [
                      Row(
                        children: [
                          Text(
                            'Phản hồi từ ${widget.storeName}',
                            style: HAppStyle.heading5Style,
                          ),
                          const Spacer(),
                          Text(
                            DateFormat('EEEE, d-M-y', 'vi')
                                .format(widget.review.uploadTime),
                            style: HAppStyle.paragraph3Regular
                                .copyWith(color: HAppColor.hGreyColorShade600),
                          )
                        ],
                      ),
                      gapH12,
                      ReadMoreText(
                        discription,
                        trimLines: 2,
                        style: HAppStyle.paragraph2Regular
                            .copyWith(color: HAppColor.hGreyColorShade600),
                        trimMode: TrimMode.Line,
                        trimCollapsedText: 'Hiển thị thêm',
                        trimExpandedText: ' Rút gọn',
                        moreStyle: HAppStyle.label3Bold
                            .copyWith(color: HAppColor.hBluePrimaryColor),
                        lessStyle: HAppStyle.label3Bold
                            .copyWith(color: HAppColor.hBluePrimaryColor),
                      ),
                    ]),
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}

class ShimmerReviewItemWidget extends StatelessWidget {
  const ShimmerReviewItemWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            UserImageLogoWidget(
              size: 40,
              hasFunction: false,
            ),
            gapW10,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomShimmerWidget.rectangular(
                  height: 14,
                  width: 100,
                ),
                Row(
                  children: [
                    RatingBar.builder(
                      itemSize: 10,
                      initialRating: 4.3,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.only(right: 4.0),
                      itemBuilder: (context, _) => const Icon(
                        EvaIcons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {},
                    ),
                    gapW10,
                    CustomShimmerWidget.rectangular(
                      height: 10,
                      width: 50,
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            const CustomShimmerWidget.circular(width: 20, height: 20)
          ],
        ),
        gapH12,
        CustomShimmerWidget.rectangular(
          height: 12,
        ),
        gapH4,
        CustomShimmerWidget.rectangular(
          height: 12,
        ),
        gapH12,
        const CustomShimmerWidget.circular(width: 100, height: 100),
        gapH12,
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            width: HAppSize.deviceWidth - hAppDefaultPadding - 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: HAppColor.hGreyColorShade300),
            child: Padding(
              padding: const EdgeInsets.all(hAppDefaultPadding),
              child: Column(children: [
                Row(
                  children: [
                    CustomShimmerWidget.rectangular(
                      height: 14,
                      width: 100,
                    ),
                    const Spacer(),
                    CustomShimmerWidget.rectangular(
                      height: 10,
                      width: 50,
                    ),
                  ],
                ),
                gapH12,
                CustomShimmerWidget.rectangular(
                  height: 12,
                ),
                gapH4,
                CustomShimmerWidget.rectangular(
                  height: 12,
                ),
              ]),
            ),
          ),
        ),
        gapH12,
        Divider(
          color: HAppColor.hGreyColorShade300,
        )
      ],
    );
  }
}
