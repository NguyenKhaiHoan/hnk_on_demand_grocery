import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:on_demand_grocery/src/features/personalization/models/address_model.dart';
import 'package:on_demand_grocery/src/features/personalization/models/user_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/delivery_person_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/product_in_cart_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/store_note_model.dart';
import 'package:on_demand_grocery/src/features/shop/models/voucher_model.dart';

class OrderModel {
  String oderId;

  String orderUserId;
  List<ProductInCartModel> orderProducts;
  UserModel orderUser;
  AddressModel orderUserAddress;
  DeliveryPersonModel? deliveryPerson;
  String? deliveryPersonId;

  String paymentMethod;
  String paymentStatus;
  String orderType;
  String? timeOrder;
  int deliveryCost;
  int discount;
  VoucherModel? voucher;

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

  int activeStep;

  OrderModel(
      {required this.oderId,
      required this.orderUserId,
      required this.storeOrders,
      required this.orderProducts,
      required this.orderUser,
      required this.orderUserAddress,
      this.deliveryPerson,
      this.deliveryPersonId,
      required this.paymentMethod,
      required this.paymentStatus,
      required this.orderType,
      this.timeOrder,
      required this.deliveryCost,
      required this.discount,
      this.voucher,
      this.orderStatus,
      this.orderDate,
      this.waitingTimeForConfirmationFromStore,
      this.waitingTimeForConfirmationFromDeliveryPerson,
      this.waitingTimeForPickUp,
      this.waitingTimeToArrive,
      this.requestedForDelivery,
      required this.notificationDelivery,
      required this.price,
      this.activeStep = 0});

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
        orderType: '',
        deliveryCost: 0,
        discount: 0,
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
      'DeliveryPersonId': deliveryPersonId,
      'PaymentMethod': paymentMethod,
      'PaymentStatus': paymentStatus,
      'OrderStatus': orderStatus,
      'OrderDate': orderDate?.millisecondsSinceEpoch,
      'WaitingTimeForConfirmationFromStore':
          waitingTimeForConfirmationFromStore?.millisecondsSinceEpoch,
      'WaitingTimeForConfirmationFromDeliveryPerson':
          waitingTimeForConfirmationFromDeliveryPerson?.millisecondsSinceEpoch,
      'WaitingTimeForPickUp': waitingTimeForPickUp?.millisecondsSinceEpoch,
      'WaitingTimeToArrive': waitingTimeToArrive?.millisecondsSinceEpoch,
      'RequestedForDelivery': requestedForDelivery ?? false,
      'NotificationDelivery': notificationDelivery,
      'Price': price,
      'ActiveStep': activeStep,
      'OrderType': orderType,
      'TimeOrder': timeOrder,
      'DeliveryCost': deliveryCost,
      'Discount': discount,
      'Voucher': voucher!.toJson()
    };
  }

  factory OrderModel.fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return OrderModel(
          oderId: data['OrderId'] ?? '',
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
          deliveryPersonId: data['DeliveryPersonId'] ?? '',
          paymentMethod: data['PaymentMethod'] ?? '',
          paymentStatus: data['PaymentStatus'] ?? '',
          orderStatus: data['OrderStatus'] ?? '',
          orderDate: data['OrderDate'] != null
              ? DateTime.fromMillisecondsSinceEpoch(data['OrderDate'])
              : null,
          waitingTimeForConfirmationFromStore:
              data['WaitingTimeForConfirmationFromStore'] != null
                  ? DateTime.fromMillisecondsSinceEpoch(
                      data['WaitingTimeForConfirmationFromStore'])
                  : null,
          waitingTimeForConfirmationFromDeliveryPerson:
              data['WaitingTimeForConfirmationFromDeliveryPerson'] != null
                  ? DateTime.fromMillisecondsSinceEpoch(
                      data['WaitingTimeForConfirmationFromDeliveryPerson'])
                  : null,
          waitingTimeForPickUp: data['WaitingTimeForPickUp'] != null
              ? DateTime.fromMillisecondsSinceEpoch(
                  data['WaitingTimeForPickUp'])
              : null,
          waitingTimeToArrive: data['WaitingTimeToArrive'] != null
              ? DateTime.fromMillisecondsSinceEpoch(data['WaitingTimeToArrive'])
              : null,
          requestedForDelivery: data['RequestedForDelivery'] ?? false,
          notificationDelivery: data['NotificationDelivery'] != null
              ? List<String>.from(data['NotificationDelivery'])
              : [],
          price: data['Price'] ?? 0,
          activeStep: data['ActiveStep'] ?? 0,
          orderType: data['OrderType'] ?? '',
          timeOrder: data['TimeOrder'] ?? '',
          deliveryCost: data['DeliveryCost'] ?? 0,
          discount: data['Discount'] ?? 0,
          voucher: data['Voucher'] != null
              ? VoucherModel.fromJson(data['Voucher'])
              : null);
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
        deliveryPersonId: json['DeliveryPersonId'] != null
            ? json['DeliveryPersonId'] as String
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
        notificationDelivery: json['NotificationDelivery'] != null ? List<String>.from(json['NotificationDelivery']) : [],
        price: json['Price'] ?? 0,
        activeStep: json['ActiveStep'] ?? 0,
        orderType: json['OrderType'] ?? '',
        timeOrder: json['TimeOrder'] != null ? json['TimeOrder'] as String : null,
        deliveryCost: json['DeliveryCost'] ?? 0,
        discount: json['Discount'] ?? 0,
        voucher: json['Voucher'] != null ? VoucherModel.fromJson(json['Voucher']) : null);
  }

  @override
  bool operator ==(Object other) {
    if (other is OrderModel) {
      return oderId == other.oderId;
    }
    return false;
  }
}
