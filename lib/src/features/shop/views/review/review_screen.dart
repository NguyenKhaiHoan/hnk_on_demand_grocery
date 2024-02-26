import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:lorem_ipsum/lorem_ipsum.dart';
import 'package:on_demand_grocery/src/constants/app_colors.dart';
import 'package:on_demand_grocery/src/constants/app_sizes.dart';
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

  final String discription =
      loremIpsum(words: 30, paragraphs: 1, initWithLorem: true);

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
        title: const Text("Nhận xét"),
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
                        '2.3k+ Nhận xét',
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
          ReviewItemWidget(discription: discription),
          gapH12,
          ReviewItemWidget(discription: discription),
        ]),
      ),
    );
  }
}

class ReviewItemWidget extends StatelessWidget {
  const ReviewItemWidget({
    super.key,
    required this.discription,
  });

  final String discription;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                image: const DecorationImage(
                    image: AssetImage('assets/logos/logo.png'),
                    fit: BoxFit.fill),
              ),
            ),
            gapW10,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Nguyễn Khải Hoàn',
                  style: HAppStyle.heading5Style,
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
                    Text(
                      '10-2-2024',
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
        gapH12,
        ReadMoreText(
          discription,
          trimLines: 2,
          style: HAppStyle.paragraph2Regular
              .copyWith(color: HAppColor.hGreyColorShade600),
          trimMode: TrimMode.Line,
          trimCollapsedText: 'Hiển thị thêm',
          trimExpandedText: ' Rút gọn',
          moreStyle:
              HAppStyle.label3Bold.copyWith(color: HAppColor.hBluePrimaryColor),
          lessStyle:
              HAppStyle.label3Bold.copyWith(color: HAppColor.hBluePrimaryColor),
        ),
        gapH12,
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: const DecorationImage(
                image: NetworkImage(
                    'https://img2.thuthuatphanmem.vn/uploads/2019/03/14/anh-qua-tao-dep-nhat_095349569.jpg'),
                fit: BoxFit.cover),
          ),
        ),
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
                    const Text(
                      'Phản hồi từ Big C',
                      style: HAppStyle.heading5Style,
                    ),
                    const Spacer(),
                    Text(
                      '10-2-2024',
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
        ),
        gapH12,
        Divider(
          color: HAppColor.hGreyColorShade300,
        )
      ],
    );
  }
}
