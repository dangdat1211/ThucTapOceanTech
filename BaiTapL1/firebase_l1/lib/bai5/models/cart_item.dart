import 'package:firebase_l1/bai5/models/product.dart';

class CartItem {
  String? id;
  String productId;
  String productName;
  double productPrice;
  String productImage;
  int quantity;

  CartItem({
    this.id,
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.productImage,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'productPrice': productPrice,
      'productImage': productImage,
      'quantity': quantity,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map, String id) {
    return CartItem(
      id: id,
      productId: map['productId'],
      productName: map['productName'],
      productPrice: map['productPrice'],
      productImage: map['productImage'],
      quantity: map['quantity'],
    );
  }

  factory CartItem.fromProduct(Product product) {
    return CartItem(
      productId: product.id!,
      productName: product.name,
      productPrice: product.price,
      productImage: product.imageUrl,
      quantity: 1,
    );
  }
}