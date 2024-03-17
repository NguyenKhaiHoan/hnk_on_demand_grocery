import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id;
  String name;
  String email;
  String phoneNumber;
  String profileImage;
  String creationDate;
  String authenticationBy;
  List<String> listOfFavoriteProduct;
  List<String> listOfFavoriteStore;
  List<String> listOfRegisterNotificationProduct;
  String? cloudMessagingToken;

  UserModel(
      {required this.id,
      required this.name,
      required this.email,
      required this.phoneNumber,
      required this.profileImage,
      required this.creationDate,
      required this.authenticationBy,
      required this.listOfFavoriteProduct,
      required this.listOfFavoriteStore,
      required this.listOfRegisterNotificationProduct,
      this.cloudMessagingToken});

  static UserModel empty() => UserModel(
      id: '',
      name: '',
      email: '',
      phoneNumber: '',
      profileImage: '',
      creationDate: '',
      authenticationBy: '',
      listOfFavoriteProduct: [],
      listOfFavoriteStore: [],
      listOfRegisterNotificationProduct: []);

  Map<String, dynamic> toJon() {
    return {
      'Id': id,
      'Name': name,
      'Email': email,
      'PhoneNumber': phoneNumber,
      'ProfileImage': profileImage,
      'CreationDate': creationDate,
      'AuthenticationBy': authenticationBy,
      'ListOfFavoriteProduct': listOfFavoriteProduct,
      'ListOfFavoriteStore': listOfFavoriteStore,
      'ListOfRegisterNotificationProduct': listOfRegisterNotificationProduct,
      'CloudMessagingToken': cloudMessagingToken
    };
  }

  factory UserModel.fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserModel(
        id: document.id,
        name: data['Name'] ?? '',
        email: data['Email'] ?? '',
        phoneNumber: data['PhoneNumber'] ?? '',
        profileImage: data['ProfileImage'] ?? '',
        creationDate: data['CreationDate'] ?? '',
        authenticationBy: data['AuthenticationBy'] ?? '',
        listOfFavoriteProduct: data['ListOfFavoriteProduct'] != null
            ? List<String>.from(data['ListOfFavoriteProduct'])
            : [],
        listOfFavoriteStore: data['ListOfFavoriteStore'] != null
            ? List<String>.from(data['ListOfFavoriteStore'])
            : [],
        listOfRegisterNotificationProduct:
            data['ListOfRegisterNotificationProduct'] != null
                ? List<String>.from(data['ListOfRegisterNotificationProduct'])
                : [],
        cloudMessagingToken: data['CloudMessagingToken'] ?? '');
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['Id'] ?? '',
      name: json['Name'] ?? '',
      email: json['Email'] ?? '',
      phoneNumber: json['PhoneNumber'] ?? '',
      profileImage: json['ProfileImage'] ?? '',
      creationDate: json['CreationDate'] ?? '',
      authenticationBy: json['AuthenticationBy'] ?? '',
      listOfFavoriteProduct: List<String>.from(json['ListOfFavoriteProduct']),
      listOfFavoriteStore: List<String>.from(json['ListOfFavoriteStore']),
      listOfRegisterNotificationProduct:
          List<String>.from(json['ListOfRegisterNotificationProduct']),
      cloudMessagingToken: json['CloudMessagingToken'],
    );
  }
}
