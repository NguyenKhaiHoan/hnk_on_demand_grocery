import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:on_demand_grocery/src/features/personalization/models/address_model.dart';
import 'package:on_demand_grocery/src/features/personalization/models/user_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/delivery_person_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/product_in_cart_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/store_note_model.dart';

class OrderModel {
  String oderId;

  String orderUserId;
  // List<String> orderStoreIds;
  List<ProductInCartModel> orderProducts;
  UserModel orderUser;
  AddressModel orderUserAddress;
  DeliveryPersonModel? deliveryPerson;

  String paymentMethod;
  String paymentStatus;

  int price;

  String? orderStatus;
  DateTime? orderDate;
  DateTime? waitingTimeForConfirmationFromStore;
  DateTime? waitingTimeForConfirmationFromDeliveryPerson;
  DateTime? waitingTimeForPickUp;
  DateTime? waitingTimeToArrive;
  bool? requestedForDelivery;

  List<StoreOrderModel> storeOrders;

  List<String> notificationDelivery;

  OrderModel(
      {required this.oderId,
      required this.orderUserId,
      required this.storeOrders,
      required this.orderProducts,
      required this.orderUser,
      required this.orderUserAddress,
      this.deliveryPerson,
      required this.paymentMethod,
      required this.paymentStatus,
      this.orderStatus,
      this.orderDate,
      this.waitingTimeForConfirmationFromStore,
      this.waitingTimeForConfirmationFromDeliveryPerson,
      this.waitingTimeForPickUp,
      this.waitingTimeToArrive,
      this.requestedForDelivery,
      required this.notificationDelivery,
      required this.price});

  static OrderModel empty() => OrderModel(
        oderId: '',
        orderUserId: '',
        storeOrders: <StoreOrderModel>[],
        orderProducts: <ProductInCartModel>[],
        orderUser: UserModel.empty(),
        orderUserAddress: AddressModel.empty(),
        paymentMethod: '',
        paymentStatus: '',
        notificationDelivery: [],
        price: 0,
      );

  Map<String, dynamic> toJson() {
    return {
      'OrderId': oderId,
      'OrderUserId': orderUserId,
      'StoreOrders': storeOrders.map((e) => e.toJson()).toList(),
      'OrderProducts': orderProducts.map((e) => e.toJson()).toList(),
      'OrderUser': orderUser.toJson(),
      'OrderUserAddress': orderUserAddress.toJson(),
      'DeliveryPerson': deliveryPerson?.toJson(),
      'PaymentMethod': paymentMethod,
      'PaymentStatus': paymentStatus,
      'OrderStatus': orderStatus,
      'OrderDate': orderDate?.millisecondsSinceEpoch,
      'WaitingTimeForConfirmationFromStore':
          waitingTimeForConfirmationFromStore?.millisecondsSinceEpoch,
      'WaitingTimeForConfirmationFromDeliveryPerson':
          waitingTimeForConfirmationFromDeliveryPerson?.millisecondsSinceEpoch,
      'WaitingTimeForPickUp': waitingTimeForPickUp?.millisecondsSinceEpoch,
      'waitingTimeToArrive': waitingTimeToArrive?.millisecondsSinceEpoch,
      'RequestedForDelivery': requestedForDelivery ?? false,
      'NotificationDelivery': notificationDelivery,
      'Price': price
    };
  }

  factory OrderModel.fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return OrderModel(
        oderId: document.id,
        orderUserId: data['OrderUserId'] ?? '',
        storeOrders: (data['StoreOrders'] as List<dynamic>)
            .map((e) => StoreOrderModel.fromJson(e))
            .toList(),
        orderProducts: (data['OrderProducts'] as List<dynamic>)
            .map((e) => ProductInCartModel.fromJson(e))
            .toList(),
        orderUser: UserModel.fromJson(data['OrderUser']),
        orderUserAddress: AddressModel.fromJson(data['OrderUserAddress']),
        deliveryPerson: data['DeliveryPerson'] != null
            ? DeliveryPersonModel.fromJson(data['DeliveryPerson'])
            : null,
        paymentMethod: data['PaymentMethos'] ?? '',
        paymentStatus: data['PaymentStatus'] ?? '',
        orderStatus: data['OrderStatus'] ?? '',
        orderDate: DateTime.fromMillisecondsSinceEpoch(
            int.parse(data['OrderDate'] ?? 0)),
        waitingTimeForConfirmationFromStore:
            data['WaitingTimeForConfirmationFromStore'] != null
                ? DateTime.fromMillisecondsSinceEpoch(
                    int.parse(data['WaitingTimeForConfirmationFromStore'] ?? 0))
                : null,
        waitingTimeForConfirmationFromDeliveryPerson:
            data['WaitingTimeForConfirmationFromDeliveryPerson'] != null
                ? DateTime.fromMillisecondsSinceEpoch(int.parse(
                    data['WaitingTimeForConfirmationFromDeliveryPerson'] ?? 0))
                : null,
        waitingTimeForPickUp: data['WaitingTimeForPickUp'] != null
            ? DateTime.fromMillisecondsSinceEpoch(
                int.parse(data['WaitingTimeForPickUp'] ?? 0))
            : null,
        waitingTimeToArrive: data['WaitingTimeToArrive'] != null
            ? DateTime.fromMillisecondsSinceEpoch(
                int.parse(data['WaitingTimeToArrive'] ?? 0))
            : null,
        requestedForDelivery: data['RequestedForDelivery'] != null
            ? data['RequestedForDelivery'] as bool
            : null,
        notificationDelivery:
            List<String>.from(data['NotificationDelivery'] ?? []),
        price: data['Price'] ?? 0,
      );
    }
    return OrderModel.empty();
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
        oderId: json['OrderId'] ?? '',
        orderUserId: json['OrderUserId'] ?? '',
        storeOrders: (json['StoreOrders'] as List<dynamic>)
            .map((e) => StoreOrderModel.fromJson(e))
            .toList(),
        orderProducts: (json['OrderProducts'] as List<dynamic>)
            .map((e) => ProductInCartModel.fromJson(e))
            .toList(),
        orderUser: UserModel.fromJson(json['OrderUser']),
        orderUserAddress: AddressModel.fromJson(json['OrderUserAddress']),
        deliveryPerson: json['DeliveryPerson'] != null
            ? DeliveryPersonModel.fromJson(json['DeliveryPerson'])
            : null,
        paymentMethod: json['PaymentMethod'] ?? '',
        paymentStatus: json['PaymentStatus'] ?? '',
        orderStatus: json['OrderStatus'] ?? '',
        orderDate: DateTime.fromMillisecondsSinceEpoch(json['OrderDate'] ?? 0),
        waitingTimeForConfirmationFromStore:
            json['WaitingTimeForConfirmationFromStore'] != null
                ? DateTime.fromMillisecondsSinceEpoch(
                    json['WaitingTimeForConfirmationFromStore'] ?? 0)
                : null,
        waitingTimeForConfirmationFromDeliveryPerson:
            json['WaitingTimeForConfirmationFromDeliveryPerson'] != null
                ? DateTime.fromMillisecondsSinceEpoch(
                    json['WaitingTimeForConfirmationFromDeliveryPerson'] ?? 0)
                : null,
        waitingTimeForPickUp: json['WaitingTimeForPickUp'] != null
            ? DateTime.fromMillisecondsSinceEpoch(
                json['WaitingTimeForPickUp'] ?? 0)
            : null,
        waitingTimeToArrive: json['WaitingTimeToArrive'] != null
            ? DateTime.fromMillisecondsSinceEpoch(
                json['WaitingTimeToArrive'] ?? 0)
            : null,
        requestedForDelivery: json['RequestedForDelivery'] != null
            ? json['RequestedForDelivery'] as bool
            : null,
        notificationDelivery: List<String>.from(json['NotificationDelivery'] ?? []),
        price: json['Price'] ?? 0);
  }
}
