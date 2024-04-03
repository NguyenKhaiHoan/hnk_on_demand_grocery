import 'package:cloud_firestore/cloud_firestore.dart';

class DeliveryPersonModel {
  String? id;
  String? name;
  String? image;
  String? phoneNumber;
  bool? status;
  String? cloudMessagingToken;

  DeliveryPersonModel(
      {this.id,
      this.name,
      this.image,
      this.phoneNumber,
      this.status,
      this.cloudMessagingToken});

  static DeliveryPersonModel empty() => DeliveryPersonModel();

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Name': name,
      'Image': image,
      'PhoneNumber': phoneNumber,
      'Status': status,
      'CloudMessagingToken': cloudMessagingToken,
    };
  }

  factory DeliveryPersonModel.fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return DeliveryPersonModel(
          id: document.id,
          name: data['Name'] ?? '',
          image: data['Image'] ?? '',
          phoneNumber: data['PhoneNumber'] ?? '',
          status: data['Status'] ?? false,
          cloudMessagingToken: data['CloudMessagingToken'] ?? '');
    }
    return DeliveryPersonModel.empty();
  }

  factory DeliveryPersonModel.fromJson(Map<String, dynamic> json) {
    return DeliveryPersonModel(
      id: json['Id'] ?? '',
      name: json['Name'] ?? '',
      image: json['Image'] ?? '',
      phoneNumber: json['PhoneNumber'] ?? '',
      status: json['Status'] ?? false,
      cloudMessagingToken: json['CloudMessagingToken'] ?? '',
    );
  }
}
