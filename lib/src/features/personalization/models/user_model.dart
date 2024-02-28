import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id;
  String name;
  String email;
  String phoneNumber;
  String profileImage;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.profileImage,
  });

  static UserModel empty() =>
      UserModel(id: '', name: '', email: '', phoneNumber: '', profileImage: '');

  Map<String, dynamic> toJon() {
    return {
      'Name': name,
      'Email': email,
      'PhoneNumber': phoneNumber,
      'ProfileImage': profileImage
    };
  }

  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserModel(
        id: document.id,
        name: data['Name'] ?? '',
        email: data['Email'] ?? '',
        phoneNumber: data['PhoneNumber'] ?? '',
        profileImage: data['ProfileImage'] ?? '');
  }
}
