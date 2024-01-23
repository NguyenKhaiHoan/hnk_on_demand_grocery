import 'package:flutter/material.dart';

class CategoryModel {
  String image;
  String title;
  bool active = false;

  CategoryModel({
    required this.image,
    required this.title,
  });
}

final categoryList = [
  CategoryModel(
      image: 'assets/images/category/icons8-strawberry-64.png',
      title: 'Trái cây'),
  CategoryModel(
      image: 'assets/images/category/icons8-broccoli-64.png', title: 'Rau củ'),
  CategoryModel(
      image: 'assets/images/category/icons8-thanksgiving-64.png',
      title: 'Thịt'),
  CategoryModel(
      image: 'assets/images/category/icons8-crab-64.png', title: 'Hải sản'),
  CategoryModel(
      image: 'assets/images/category/icons8-eggs-64.png', title: 'Trứng'),
  CategoryModel(
      image: 'assets/images/category/icons8-milk-carton-64.png', title: 'Sữa'),
  CategoryModel(
      image: 'assets/images/category/icons8-salt-shaker-64.png',
      title: 'Gia vị'),
  CategoryModel(
      image: 'assets/images/category/icons8-nut-64.png', title: 'Hạt'),
  CategoryModel(
      image: 'assets/images/category/icons8-bread-64.png', title: 'Bánh mỳ'),
  CategoryModel(
      image: 'assets/images/category/icons8-orange-soda-64.png',
      title: 'Đồ uống'),
  CategoryModel(
      image: 'assets/images/category/icons8-chupa-chups-64.png',
      title: 'Ăn vặt'),
  CategoryModel(
      image: 'assets/images/category/icons8-porridge-64.png',
      title: 'Mỳ & Gạo'),
];
