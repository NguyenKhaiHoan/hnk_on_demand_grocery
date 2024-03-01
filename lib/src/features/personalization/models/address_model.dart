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
  bool isDefault;

  AddressModel(
      {required this.id,
      required this.name,
      required this.phoneNumber,
      this.city = 'Hà Nội',
      required this.district,
      required this.ward,
      required this.street,
      this.selectedAddress = true,
      this.isDefault = true});

  static AddressModel empty() => AddressModel(
        id: '',
        name: '',
        phoneNumber: '',
        district: '',
        ward: '',
        street: '',
      );

  @override
  String toString() {
    return '$street, $ward, $district, $city';
  }

  Map<String, dynamic> toJon() {
    return {
      'Id': id,
      'Name': name,
      'PhoneNumber': phoneNumber,
      'City': city,
      'District': district,
      'Ward': ward,
      'Street': street,
      'SelectedAddress': selectedAddress,
      'IsDefault': isDefault,
    };
  }

  factory AddressModel.fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
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
      isDefault: data['IsDefault'] as bool,
    );
  }
}
