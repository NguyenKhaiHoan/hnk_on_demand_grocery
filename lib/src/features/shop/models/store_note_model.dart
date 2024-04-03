class StoreOrderModel {
  String storeId;
  String note;
  bool checkChooseInCart;
  int acceptByStore;
  String name;
  String address;
  double latitude;
  double longitude;
  int isCheckFullProduct;
  StoreOrderModel(
      {required this.storeId,
      this.address = '',
      this.name = '',
      this.note = '',
      required this.checkChooseInCart,
      this.acceptByStore = 0,
      this.latitude = 0.0,
      this.longitude = 0.0,
      this.isCheckFullProduct = 0});

  static StoreOrderModel empty() => StoreOrderModel(
        storeId: '',
        checkChooseInCart: true,
      );

  Map<String, dynamic> toJson() {
    return {
      'StoreId': storeId,
      'Note': note,
      'AcceptByStore': acceptByStore,
      'Name': name,
      'Address': address,
      'Latitude': latitude,
      'Longitude': longitude,
      'IsCheckFullProduct': isCheckFullProduct
    };
  }

  factory StoreOrderModel.fromJson(Map<String, dynamic> json) {
    return StoreOrderModel(
        storeId: json['StoreId'] ?? '',
        note: json['Note'] ?? '',
        acceptByStore: json['AcceptByStore'] ?? 0,
        name: json['Name'] ?? '',
        address: json['Address'] ?? '',
        checkChooseInCart: true,
        latitude: json['Latitude'] ?? 0,
        longitude: json['Longitude'] ?? 0,
        isCheckFullProduct: json['IsCheckFullProduct'] ?? 0);
  }

  @override
  bool operator ==(Object other) {
    if (other is StoreOrderModel) {
      return storeId == other.storeId;
    }
    return false;
  }

  @override
  int get hashCode => storeId.hashCode;
}
