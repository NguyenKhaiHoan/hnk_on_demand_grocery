import 'package:cloud_firestore/cloud_firestore.dart';

class AddressModel {
  String id;
  String name;
  String phoneNumber;
  String city;
  String district;
  String ward;
  String street;
  bool selectedAddress;
  double latitude;
  double longitude;

  AddressModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
    this.city = 'Hà Nội',
    required this.district,
    required this.ward,
    required this.street,
    this.selectedAddress = true,
    required this.latitude,
    required this.longitude,
  });

  static AddressModel empty() => AddressModel(
        id: '',
        name: '',
        phoneNumber: '',
        district: '',
        ward: '',
        street: '',
        latitude: 0,
        longitude: 0,
      );

  Map<String, dynamic> toJson() {
    return {
      'Name': name,
      'PhoneNumber': phoneNumber,
      'City': city,
      'District': district,
      'Ward': ward,
      'Street': street,
      'Latitude': latitude,
      'Longitude': longitude,
      'SelectedAddress': selectedAddress
    };
  }

  factory AddressModel.fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return AddressModel(
        id: document.id,
        name: data['Name'] ?? '',
        phoneNumber: data['PhoneNumber'] ?? '',
        city: data['City'] ??= 'Hà Nội',
        district: data['District'] ?? '',
        ward: data['Ward'] ?? '',
        street: data['Street'] ?? '',
        selectedAddress: data['SelectedAddress'] as bool,
        latitude: double.parse((data['Latitude'] ?? 0.0).toString()),
        longitude: double.parse((data['Longitude'] ?? 0.0).toString()),
      );
    }
    return AddressModel.empty();
  }

  @override
  String toString() {
    return [street, ward, district, city].join(', ');
  }

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['Id'] ?? '',
      name: json['Name'] ?? '',
      phoneNumber: json['PhoneNumber'] ?? '',
      city: json['City'] ?? '',
      district: json['District'] ?? '',
      ward: json['Ward'] ?? '',
      street: json['Street'] ?? '',
      selectedAddress: json['SelectedAddress'] ?? false,
      latitude: json['Latitude']?.toDouble() ?? 0.0,
      longitude: json['Longitude']?.toDouble() ?? 0.0,
    );
  }

  String fullAddressString() {
    return [
      name,
      phoneNumber,
      street,
      ward,
      district,
      city,
      latitude,
      longitude
    ].join(', ');
  }

  @override
  bool operator ==(Object other) {
    if (other is AddressModel) {
      return fullAddressString() == other.fullAddressString();
    }
    return false;
  }
}
