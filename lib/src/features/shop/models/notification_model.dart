import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NotificationModel {
  String id;
  Icon? icon;
  final String title;
  final String body;
  final DateTime time;
  final String type; // order, store, product
  String? storeId;
  String? orderId;
  String? productId;
  NotificationModel(
      {required this.id,
      required this.title,
      required this.body,
      required this.time,
      required this.type,
      this.orderId,
      this.productId,
      this.storeId,
      this.icon});

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Title': title,
      'Body': body,
      'Time': time.millisecondsSinceEpoch,
      'Type': type,
      'OrderId': orderId,
      'ProductId': productId,
      'StoreId': storeId,
    };
  }

  factory NotificationModel.fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return NotificationModel(
        id: document.id,
        title: data['Title'] ?? '',
        body: data['Body'] ?? '',
        time: DateTime.fromMillisecondsSinceEpoch((data['Time'] ?? 0)),
        type: data['Type'] ?? '',
        storeId: data['StoreId'] != null ? data['StoreId'] : null,
        orderId: data['OrderId'] != null ? data['OrderId'] : null,
        productId: data['ProductId'] != null ? data['ProductId'] : null,
      );
    }
    return NotificationModel.empty();
  }

  static NotificationModel empty() => NotificationModel(
      id: '', title: '', body: '', time: DateTime.now(), type: '');
}


// List<NotificationModel> notifications = [
//   NotificationModel(
//       icon: const Icon(Icons.storefront_outlined),
//       title: 'Cửa hàng CoopMart có ưu đãi mới',
//       body:
//           'Của hàng CoopMart đã cập nhật thêm mã ưu đãi mới. Hãy truy cập để kiểm tra ngay.',
//       time: DateTime.now(),
//       type: 'store',
//       id: '0'),
//   NotificationModel(
//       icon: const Icon(EvaIcons.shoppingBagOutline),
//       title: 'Đơn hàng mã #0102... được đặt thành công',
//       body:
//           'Bạn đã đặt thành công đơn hàng có mã #010203..., đơn hàng sẽ được giao theo phương thức giao hàng đã chọn.',
//       time: DateTime.now(),
//       type: 'order',
//       id: '1'),
//   NotificationModel(
//       icon: const Icon(Icons.production_quantity_limits_rounded),
//       title: 'Sản phẩm Bơ... có hàng trở lại',
//       body:
//           'Bạn đã có thể đặt hàng ngay với sản phẩm Bơ ... đã được cập nhật trạng thái trở lại.',
//       time: DateTime.now(),
//       type: 'product',
//       id: '2'),
// ];
