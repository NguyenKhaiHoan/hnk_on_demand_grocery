class PaymentModel {
  String id;
  String name;
  PaymentModel({
    required this.id,
    required this.name,
  });

  static PaymentModel empty() => PaymentModel(id: '', name: '');
}
