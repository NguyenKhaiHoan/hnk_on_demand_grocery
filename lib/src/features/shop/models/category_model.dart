import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  String id;
  String image;
  String name;

  CategoryModel({
    required this.id,
    required this.image,
    required this.name,
  });

  static CategoryModel empty() => CategoryModel(id: '', image: '', name: '');

  Map<String, dynamic> toJon() {
    return {
      'Name': name,
      'Image': image,
    };
  }

  factory CategoryModel.fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return CategoryModel(
        id: document.id,
        name: data['Name'] ?? '',
        image: data['Image'] ?? '',
      );
    }
    return CategoryModel.empty();
  }
}
