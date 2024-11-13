import 'package:firebase_l1/bai5/models/cart_item.dart';
import 'package:flutter/material.dart';

class CartSummary extends StatelessWidget {
  final List<CartItem> items;
  final VoidCallback onCheckout;

  const CartSummary({
    Key? key,
    required this.items,
    required this.onCheckout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final subtotal = items.fold<double>(
      0,
      (sum, item) => sum + (item.productPrice * item.quantity),
    );
    
    return Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Subtotal:', style: TextStyle(fontSize: 16)),
                Text(
                  '\$${subtotal.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              child: Text('Proceed to Checkout'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: onCheckout,
            ),
          ],
        ),
      ),
    );
  }
}