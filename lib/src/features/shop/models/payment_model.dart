class PaymentModel {
  String name;
  PaymentModel({
    required this.name,
  });

  static PaymentModel empty() => PaymentModel(name: '');
}
