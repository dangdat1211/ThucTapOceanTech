import 'package:firebase_l1/bai5/models/cart_item.dart';
import 'package:firebase_l1/bai5/services/cart_service.dart';
import 'package:flutter/material.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;
  final CartService _cartService = CartService();

  CartItemWidget({required this.cartItem});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(cartItem.id),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 30,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        _cartService.removeItem(cartItem.id!);
      },
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: Image.network(
              cartItem.productImage,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            title: Text(cartItem.productName),
            subtitle: Text(
              'Total: \$${(cartItem.productPrice * cartItem.quantity).toStringAsFixed(2)}'
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: cartItem.quantity > 1
                      ? () => _cartService.updateQuantity(
                          cartItem.id!,
                          cartItem.quantity - 1)
                      : null,
                ),
                Text('${cartItem.quantity}'),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => _cartService.updateQuantity(
                      cartItem.id!,
                      cartItem.quantity + 1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}