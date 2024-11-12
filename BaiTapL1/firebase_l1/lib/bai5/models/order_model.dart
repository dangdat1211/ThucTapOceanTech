import 'package:firebase_l1/bai5/models/cart_model.dart';

class OrderModel {
  final String id;
  final String userId;
  final List<CartModel> items;
  final double total;
  final String address;
  final String phone;
  final DateTime orderDate;
  final String status;

  OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.total,
    required this.address,
    required this.phone,
    required this.orderDate,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((item) => item.toMap()).toList(),
      'total': total,
      'address': address,
      'phone': phone,
      'orderDate': orderDate.toIso8601String(),
      'status': status,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'],
      userId: map['userId'],
      items: (map['items'] as List)
          .map((item) => CartModel.fromMap(item))
          .toList(),
      total: map['total'].toDouble(),
      address: map['address'],
      phone: map['phone'],
      orderDate: DateTime.parse(map['orderDate']),
      status: map['status'],
    );
  }
}