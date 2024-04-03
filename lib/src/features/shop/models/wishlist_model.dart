import 'package:cloud_firestore/cloud_firestore.dart';

class WishlistModel {
  String id;
  String title;
  String description;
  List<String> listIds;
  DateTime uploadTime;

  WishlistModel(
      {required this.id,
      required this.title,
      required this.description,
      required this.listIds,
      required this.uploadTime});

  static WishlistModel empty() => WishlistModel(
      id: '',
      title: '',
      description: '',
      listIds: [],
      uploadTime: DateTime.fromMillisecondsSinceEpoch(0));

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Title': title,
      'Description': description,
      'ListIds': listIds,
      'UploadTime': uploadTime.millisecondsSinceEpoch
    };
  }

  factory WishlistModel.fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return WishlistModel(
          id: document.id,
          title: data['Title'] ?? '',
          description: data['Description'] ?? '',
          listIds:
              data['ListIds'] != null ? List<String>.from(data['ListIds']) : [],
          uploadTime: DateTime.fromMillisecondsSinceEpoch(
              int.parse((data['UploadTime'] ?? 0).toString())));
    }
    return WishlistModel.empty();
  }
}
