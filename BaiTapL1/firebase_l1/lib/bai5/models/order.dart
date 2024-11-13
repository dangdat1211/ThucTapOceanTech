import 'package:firebase_l1/bai5/models/cart_item.dart';

class OrderModel {
  String? id;
  String userId;
  List<CartItem> items;
  double total;
  String address;
  String phone;
  String customerName;
  DateTime orderDate;
  String status;
  String? note;

  OrderModel({
    this.id,
    required this.userId,
    required this.items,
    required this.total,
    required this.address,
    required this.phone,
    required this.customerName,
    required this.orderDate,
    this.status = 'Pending',
    this.note,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'items': items.map((item) => {
        'productId': item.productId,
        'productName': item.productName,
        'productPrice': item.productPrice,
        'productImage': item.productImage,
        'quantity': item.quantity,
        'subtotal': item.productPrice * item.quantity,
      }).toList(),
      'total': total,
      'address': address,
      'phone': phone,
      'customerName': customerName,
      'orderDate': orderDate.toIso8601String(),
      'status': status,
      'note': note,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map, String id) {
    return OrderModel(
      id: id,
      userId: map['userId'],
      items: (map['items'] as List).map((item) => CartItem(
        productId: item['productId'],
        productName: item['productName'],
        productPrice: item['productPrice'],
        productImage: item['productImage'],
        quantity: item['quantity'],
      )).toList(),
      total: map['total'],
      address: map['address'],
      phone: map['phone'],
      customerName: map['customerName'],
      orderDate: DateTime.parse(map['orderDate']),
      status: map['status'],
      note: map['note'],
    );
  }
}