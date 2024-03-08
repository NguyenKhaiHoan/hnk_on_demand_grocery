import 'package:cloud_firestore/cloud_firestore.dart';

class BannerModel {
  bool isActive;
  String image;

  BannerModel({
    required this.isActive,
    required this.image,
  });

  static BannerModel empty() => BannerModel(isActive: false, image: '');

  Map<String, dynamic> toJon() {
    return {
      'IsActive': isActive,
      'Image': image,
    };
  }

  factory BannerModel.fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return BannerModel(
        isActive: data['IsActive'] ?? false,
        image: data['Image'] ?? '',
      );
    }
    return BannerModel.empty();
  }
}
