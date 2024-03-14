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

  Map<String, dynamic> toJon() {
    return {
      'Name': name,
      'PhoneNumber': phoneNumber,
      'City': city,
      'District': district,
      'Ward': ward,
      'Street': street,
      'SelectedAddress': selectedAddress,
      'Latitude': latitude,
      'Longitude': longitude,
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
}
