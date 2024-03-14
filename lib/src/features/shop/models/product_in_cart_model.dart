class ProductInCartModel {
  String productId;
  String? productName;
  String? image;
  int? price;
  int quantity;
  String storeId;
  String? storeName;
  String? categoryId;
  ProductInCartModel(
      {required this.productId,
      this.productName,
      this.image,
      this.price,
      required this.quantity,
      required this.storeId,
      this.storeName,
      this.categoryId});

  static ProductInCartModel empty() =>
      ProductInCartModel(productId: '', quantity: 0, storeId: '');

  Map<String, dynamic> toJson() {
    return {
      'ProductId': productId,
      'ProductName': productName,
      'Pmage': image,
      'Price': price,
      'Quantity': quantity,
      'StoreId': storeId,
      'StoreName': storeName,
      'CategoryId': categoryId,
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
      categoryId: json['CategoryId'],
    );
  }
}
