import 'package:cloud_firestore/cloud_firestore.dart';

class DeliveryPersonModel {
  String? id;
  String? name;
  String? image;
  String? phoneNumber;
  String? vehicleRegistrationNumber;
  String? drivingLicenseNumber;
  String? creationDate;
  String? activeDeliveryRequestId;
  String? status;
  String? cloudMessagingToken;

  DeliveryPersonModel(
      {this.id,
      this.name,
      this.image,
      this.phoneNumber,
      this.vehicleRegistrationNumber,
      this.drivingLicenseNumber,
      this.creationDate,
      this.activeDeliveryRequestId,
      this.status,
      this.cloudMessagingToken});

  static DeliveryPersonModel empty() => DeliveryPersonModel();

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Name': name,
      'Image': image,
      'PhoneNumber': phoneNumber,
      'VehicleRegistrationNumber': vehicleRegistrationNumber,
      'DrivingLicenseNumber': drivingLicenseNumber,
      'CreationDate': creationDate,
      'ActiveDeliveryRequestId': activeDeliveryRequestId,
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
          vehicleRegistrationNumber: data['VehicleRegistrationNumber'] ?? '',
          drivingLicenseNumber: data['DrivingLicenseNumber'] ?? '',
          creationDate: data['CreationDate'] ?? '',
          activeDeliveryRequestId: data['ActiveDeliveryRequestId'],
          status: data['Status'] ?? '',
          cloudMessagingToken: data['CloudMessagingToken'] ?? '');
    }
    return DeliveryPersonModel.empty();
  }

  factory DeliveryPersonModel.fromJson(Map<String, dynamic> json) {
    return DeliveryPersonModel(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      phoneNumber: json['phoneNumber'],
      vehicleRegistrationNumber: json['vehicleRegistrationNumber'],
      drivingLicenseNumber: json['drivingLicenseNumber'],
      creationDate: json['creationDate'],
      activeDeliveryRequestId: json['activeDeliveryRequestId'],
      status: json['status'],
      cloudMessagingToken: json['cloudMessagingToken'],
    );
  }
}
