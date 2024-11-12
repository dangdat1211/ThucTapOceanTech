class CartModel {
  final String id;
  final String productId;
  final String productName;
  final double price;
  int quantity;

  CartModel({
    required this.id,
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'productName': productName,
      'price': price,
      'quantity': quantity,
    };
  }

  factory CartModel.fromMap(Map<String, dynamic> map) {
    return CartModel(
      id: map['id'],
      productId: map['productId'],
      productName: map['productName'],
      price: map['price'].toDouble(),
      quantity: map['quantity'],
    );
  }
}