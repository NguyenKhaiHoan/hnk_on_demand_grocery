import 'package:cloud_firestore/cloud_firestore.dart';

class StoreAddressModel {
  String id;
  String city;
  String district;
  String ward;
  String street;
  double latitude;
  double longitude;

  StoreAddressModel({
    required this.id,
    this.city = 'Hà Nội',
    required this.district,
    required this.ward,
    required this.street,
    required this.latitude,
    required this.longitude,
  });

  static StoreAddressModel empty() => StoreAddressModel(
        id: '',
        district: '',
        ward: '',
        street: '',
        latitude: 0.0,
        longitude: 0.0,
      );

  @override
  String toString() {
    return [street, ward, district, city].join(', ');
  }

  Map<String, dynamic> toJon() {
    return {
      'City': city,
      'District': district,
      'Ward': ward,
      'Street': street,
      'Latitude': latitude,
      'Longitude': longitude,
    };
  }

  factory StoreAddressModel.fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return StoreAddressModel(
        id: document.id,
        city: data['City'] ??= 'Hà Nội',
        district: data['District'] ?? '',
        ward: data['Ward'] ?? '',
        street: data['Street'] ?? '',
        latitude: double.parse((data['Latitude'] ?? 5.0).toString()),
        longitude: double.parse((data['Longitude'] ?? 5.0).toString()),
      );
    }
    return StoreAddressModel.empty();
  }
}
