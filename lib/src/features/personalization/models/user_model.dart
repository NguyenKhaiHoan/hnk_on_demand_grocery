import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id;
  String name;
  String email;
  String phoneNumber;
  String profileImage;
  String creationDate;
  String authenticationBy;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.profileImage,
    required this.creationDate,
    required this.authenticationBy,
  });

  static UserModel empty() => UserModel(
      id: '',
      name: '',
      email: '',
      phoneNumber: '',
      profileImage: '',
      creationDate: '',
      authenticationBy: '');

  Map<String, dynamic> toJon() {
    return {
      'Name': name,
      'Email': email,
      'PhoneNumber': phoneNumber,
      'ProfileImage': profileImage,
      'CreationDate': creationDate,
      'AuthenticationBy': authenticationBy
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
        authenticationBy: data['AuthenticationBy'] ?? '');
  }
}
