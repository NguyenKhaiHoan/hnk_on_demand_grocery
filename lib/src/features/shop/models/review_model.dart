import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  String? id;
  List<String>? images;
  double rating;
  String? review;
  String? userId;
  String? orderId;
  DateTime uploadTime;

  ReviewModel(
      {this.id,
      this.images,
      required this.rating,
      this.review,
      this.userId,
      this.orderId,
      required this.uploadTime});

  Map<String, dynamic> toJson() {
    return {
      'Images': images,
      'Rating': rating,
      'Review': review,
      'UserId': userId,
      'OrderId': orderId,
      'UploadTime': uploadTime.millisecondsSinceEpoch
    };
  }

  factory ReviewModel.fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return ReviewModel(
      id: document.id,
      images: data['Images'] != null
          ? List<String>.from((data['Images'] as List<dynamic>)).toList()
          : null,
      rating: double.parse((data['Rating'] ?? 5.0).toString()),
      review: data['Review'] != null ? data['Review'] as String : null,
      userId: data['UserId'] != null ? data['UserId'] as String : null,
      orderId: data['UserId'] != null ? data['OrderId'] as String : null,
      uploadTime: DateTime.fromMillisecondsSinceEpoch(
          int.parse((data['UploadTime'] ?? 0).toString())),
    );
  }
}
