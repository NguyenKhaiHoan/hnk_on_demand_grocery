import 'package:flutter/material.dart';

class OnboardingContent {
  String image = "";
  String title = "";
  String discription = "";

  OnboardingContent({
    required this.image,
    required this.title,
    required this.discription,
  });
}

List<OnboardingContent> contentsList = [
  OnboardingContent(
    title: "Ưu đãi ngập tràn",
    image: 'assets/images/on_boarding_screen/on_boarding_1.jpg',
    discription:
        "Thỏa thích mua sắm hàng tạp hóa với các ưu đãi tuyệt vời, hấp dẫn",
  ),
  OnboardingContent(
    title: 'Đặt hàng nhanh chóng',
    image: 'assets/images/on_boarding_screen/on_boarding_2.jpg',
    discription:
        "Đơn giản hóa đặt hàng và theo dõi tình trạng đơn hàng mọi lúc mọi nơi",
  ),
  OnboardingContent(
    title: 'Giao hàng an toàn',
    image: 'assets/images/on_boarding_screen/on_boarding_3.jpg',
    discription: "Hàng hóa giao đến tận nhà, đảm bảo tươi ngon và an toàn nhất",
  ),
];
