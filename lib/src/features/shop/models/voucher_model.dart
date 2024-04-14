import 'package:cloud_firestore/cloud_firestore.dart';

// enum VoucherType { Flat, Percentage }

class VoucherModel {
  String id;
  String name;
  String description;
  String type; // 'flat' hoặc 'percentage'
  DateTime startDate;
  DateTime endDate;
  int? minAmount;
  int discountValue;
  List<String> usedById;
  bool isActive;
  int? quantity;
  String? storeId;

  VoucherModel({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.startDate,
    required this.endDate,
    this.minAmount,
    required this.discountValue,
    required this.usedById,
    required this.isActive,
    this.quantity,
    this.storeId = '',
  });

  static VoucherModel empty() => VoucherModel(
      id: '',
      name: '',
      description: '',
      type: '',
      startDate: DateTime.now(),
      endDate: DateTime.now(),
      discountValue: 0,
      usedById: [],
      isActive: false);

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'StartDate': startDate.millisecondsSinceEpoch,
      'EndDate': endDate.millisecondsSinceEpoch,
      'Name': name,
      'Description': description,
      'Type': type,
      'MinAmount': minAmount,
      'DiscountValue': discountValue,
      'UsedById': usedById,
      'IsActive': isActive,
      'Quantity': quantity,
      'StoreId': storeId
    };
  }

  factory VoucherModel.fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return VoucherModel(
        id: document.id,
        usedById:
            data['UsedById'] != null ? List<String>.from(data['UsedById']) : [],
        startDate: DateTime.fromMillisecondsSinceEpoch(
            int.parse((data['StartDate'] ?? 0).toString())),
        endDate: DateTime.fromMillisecondsSinceEpoch(
            int.parse((data['EndDate'] ?? 0).toString())),
        name: data['Name'] ?? '',
        description: data['Description'],
        type: data['Type'] ?? 'Flat',
        minAmount: data['MinAmount'] != null
            ? int.parse((data['MinAmount'] ?? 0).toString())
            : 0,
        discountValue: int.parse((data['DiscountValue'] ?? 0).toString()),
        isActive: data['IsActive'] ?? false,
        quantity: data['Quantity'] != null
            ? int.parse((data['Quantity'] ?? 0).toString())
            : null,
        storeId: data['StoreId'] != null ? data['StoreId'] as String : '');
  }

  factory VoucherModel.fromJson(Map<String, dynamic> json) {
    return VoucherModel(
        id: json['Id'],
        usedById:
            json['UsedById'] != null ? List<String>.from(json['UsedById']) : [],
        startDate: DateTime.fromMillisecondsSinceEpoch(
            int.parse((json['StartDate'] ?? 0).toString())),
        endDate: DateTime.fromMillisecondsSinceEpoch(
            int.parse((json['EndDate'] ?? 0).toString())),
        name: json['Name'] ?? '',
        description: json['Description'],
        type: json['Type'] ?? 'Flat',
        minAmount: json['MinAmount'] != null
            ? int.parse((json['MinAmount'] ?? 0).toString())
            : 0,
        discountValue: int.parse((json['DiscountValue'] ?? 0).toString()),
        isActive: json['IsActive'] ?? false,
        quantity: json['Quantity'] != null
            ? int.parse((json['Quantity'] ?? 0).toString())
            : null,
        storeId: json['StoreId'] != null ? json['StoreId'] as String : '');
  }
}
