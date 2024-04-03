class StoreLocationModel {
  String storeId;
  double latitude;
  double longitude;
  double distance;
  StoreLocationModel({
    required this.storeId,
    required this.latitude,
    required this.longitude,
    required this.distance,
  });

  static StoreLocationModel empty() =>
      StoreLocationModel(storeId: '', latitude: 0, longitude: 0, distance: 0);

  @override
  bool operator ==(Object other) {
    if (other is StoreLocationModel) {
      return storeId == other.storeId;
    }
    return false;
  }

  @override
  int get hashCode => storeId.hashCode;
}
