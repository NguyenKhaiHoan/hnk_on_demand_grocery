import 'package:cloud_firestore/cloud_firestore.dart';

class ProductInCartModel {
  String productId;
  String? productName;
  String? image;
  int? price;
  int quantity;
  String storeId;
  String? storeName;
  String? unit;
  ProductInCartModel(
      {required this.productId,
      this.productName,
      this.image,
      this.price,
      required this.quantity,
      required this.storeId,
      this.storeName,
      this.unit});

  static ProductInCartModel empty() =>
      ProductInCartModel(productId: '', quantity: 0, storeId: '');

  Map<String, dynamic> toJson() {
    return {
      'ProductId': productId,
      'ProductName': productName,
      'Image': image,
      'Price': price,
      'Quantity': quantity,
      'StoreId': storeId,
      'StoreName': storeName,
      'Unit': unit,
    };
  }

  factory ProductInCartModel.fromJson(Map<String, dynamic> json) {
    return ProductInCartModel(
      productId: json['ProductId'],
      productName: json['ProductName'],
      image: json['Image'],
      price: json['Price'],
      quantity: json['Quantity'],
      storeId: json['StoreId'],
      storeName: json['StoreName'],
      unit: json['Unit'],
    );
  }

  factory ProductInCartModel.fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return ProductInCartModel(
        productId: data['ProductId'] ?? '',
        productName: data['ProductName'] ?? '',
        image: data['Image'] ?? '',
        price: int.parse((data['Price'] ?? 0).toString()),
        quantity: int.parse((data['Quantity'] ?? 0).toString()),
        storeId: data['StoreId'] ?? '',
        storeName: data['StoreName'] ?? '',
        unit: data['Unit'] ?? '',
      );
    }
    return ProductInCartModel.empty();
  }
}
