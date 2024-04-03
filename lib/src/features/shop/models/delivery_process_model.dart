class DeliveryProcessModel {
  String g;
  List<double> l;
  String? activeOrderId;

  DeliveryProcessModel(
      {required this.g, required this.l, this.activeOrderId = ''});

  factory DeliveryProcessModel.fromJson(Map<String, dynamic> json) {
    return DeliveryProcessModel(
      g: json['g'],
      l: List<double>.from((json['l'] as List<dynamic>)),
      activeOrderId: json['ActiveOrderId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'g': g,
      'l': l,
      'ActiveOrderId': activeOrderId,
    };
  }

  static DeliveryProcessModel empty() => DeliveryProcessModel(g: '', l: []);
}
