import 'package:cloud_firestore/cloud_firestore.dart';

class StoreModel {
  String id;
  String name;
  String email;
  String phoneNumber;
  String storeImage;
  String storeImageBackground;
  String description;
  List<String> listOfCategoryId;
  double rating;
  bool import;
  bool isFamous;
  int productCount;
  bool status;
  String? cloudMessagingToken;

  StoreModel(
      {required this.id,
      required this.name,
      required this.email,
      required this.phoneNumber,
      this.storeImage = '',
      this.storeImageBackground = '',
      required this.description,
      required this.listOfCategoryId,
      required this.rating,
      required this.import,
      required this.isFamous,
      required this.productCount,
      this.status = false,
      this.cloudMessagingToken});

  static StoreModel empty() => StoreModel(
        id: '',
        name: '',
        email: '',
        phoneNumber: '',
        storeImage: '',
        storeImageBackground: '',
        description: '',
        listOfCategoryId: [],
        rating: 5.0,
        import: false,
        isFamous: false,
        productCount: 0,
      );

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Name': name,
      'Email': email,
      'PhoneNumber': phoneNumber,
      'StoreImage': storeImage,
      'StoreImageBackground': storeImageBackground,
      'Description': description,
      'ListOfCategoryId': listOfCategoryId,
      'Rating': rating,
      'Import': import,
      'IsFamous': isFamous,
      'ProductCount': productCount,
      'Status': status,
      'CloudMessagingToken': cloudMessagingToken,
    };
  }

  factory StoreModel.fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return StoreModel(
        id: document.id,
        name: data['Name'] ?? '',
        email: data['Email'] ?? '',
        phoneNumber: data['PhoneNumber'] ?? '',
        storeImage: data['StoreImage'] ?? '',
        storeImageBackground: data['StoreImageBackground'] ?? '',
        description: data['Description'] ?? '',
        listOfCategoryId: data['ListOfCategoryId'] != null
            ? List<String>.from(data['ListOfCategoryId'])
            : [],
        rating: double.parse((data['Rating'] ?? 5.0).toString()),
        import: data['Import'] ?? false,
        isFamous: data['IsFamous'] ?? false,
        productCount: int.parse((data['ProductCount'] ?? 0).toString()),
        status: data['Status'] ?? false,
        cloudMessagingToken: data['CloudMessagingToken'] ?? '');
  }

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      id: json['Id'] ?? '',
      name: json['Name'] ?? '',
      email: json['Email'] ?? '',
      phoneNumber: json['PhoneNumber'] ?? '',
      storeImage: json['StoreImage'] ?? '',
      storeImageBackground: json['StoreImageBackground'] ?? '',
      description: json['Description'] ?? '',
      listOfCategoryId: List<String>.from(json['listOfCategoryId']),
      rating: json['Rating']?.toDouble() ?? 0.0,
      import: json['Import'] ?? false,
      isFamous: json['IsFamous'] ?? false,
      productCount: json['ProductCount']?.toInt() ?? 0,
      status: json['Status'] ?? false,
      cloudMessagingToken: json['CloudMessagingToken'],
    );
  }
}
