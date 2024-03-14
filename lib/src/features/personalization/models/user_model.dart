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
      required this.listOfRegisterNotificationProduct});

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
      'ListOfRegisterNotificationProduct': listOfRegisterNotificationProduct
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
                : []);
  }
}
