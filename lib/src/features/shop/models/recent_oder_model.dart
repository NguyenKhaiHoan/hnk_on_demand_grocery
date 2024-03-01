import 'package:on_demand_grocery/src/features/shop/models/product_models.dart';

class OrderModel {
  String orderId;
  String active;
  String date;
  String receivedTime;
  List<ProductModel> listProduct;
  String price;

  OrderModel(
      {required this.orderId,
      required this.active,
      required this.date,
      required this.listProduct,
      required this.price,
      this.receivedTime = ""});
}
