import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_l1/bai5/models/cart_item.dart';
import 'package:firebase_l1/bai5/models/order.dart';
import 'package:firebase_l1/bai5/services/cart_service.dart';
import 'package:firebase_l1/bai5/services/order_service.dart';
import 'package:firebase_l1/bai5/widgets/cart_item_widget.dart';
import 'package:firebase_l1/bai5/widgets/cart_sumary.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartService _cartService = CartService();
  final OrderService _orderService = OrderService();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'),
        actions: [
          StreamBuilder<List<CartItem>>(
            stream: _cartService.getCartItems(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return SizedBox();
              }
              return IconButton(
                icon: Icon(Icons.delete_sweep),
                onPressed: () => _showClearCartDialog(context),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : StreamBuilder<List<CartItem>>(
              stream: _cartService.getCartItems(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 60, color: Colors.red),
                        SizedBox(height: 16),
                        Text(
                          'Error loading cart',
                          style: TextStyle(fontSize: 18),
                        ),
                        TextButton(
                          onPressed: () => setState(() {}),
                          child: Text('Try Again'),
                        ),
                      ],
                    ),
                  );
                }

                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_cart_outlined, size: 60),
                        SizedBox(height: 16),
                        Text(
                          'Your cart is empty',
                          style: TextStyle(fontSize: 18),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('Continue Shopping'),
                        ),
                      ],
                    ),
                  );
                }

                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final item = snapshot.data![index];
                          return CartItemWidget(
                            cartItem: item,
                            // onUpdateQuantity: (quantity) async {
                            //   if (quantity > 0) {
                            //     await _cartService.updateQuantity(
                            //       item.id!,
                            //       quantity,
                            //     );
                            //   } else {
                            //     await _cartService.removeItem(item.id!);
                            //   }
                            // },
                          );
                        },
                      ),
                    ),
                    CartSummary(
                      items: snapshot.data!,
                      onCheckout: () => _showOrderDialog(
                        context,
                        snapshot.data!,
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }

  Future<void> _showClearCartDialog(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Clear Cart'),
        content: Text('Are you sure you want to remove all items from your cart?'),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.of(ctx).pop(false),
          ),
          ElevatedButton(
            child: Text('Clear Cart'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.of(ctx).pop(true),
          ),
        ],
      ),
    );

    if (confirm ?? false) {
      await _cartService.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cart cleared')),
      );
    }
  }

  Future<void> _showOrderDialog(
    BuildContext context,
    List<CartItem> items,
  ) async {
    final _formKey = GlobalKey<FormState>();
    String name = '';
    String phone = '';
    String address = '';
    String? note;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Order Information'),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Full Name'),
                  textCapitalization: TextCapitalization.words,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter your name' : null,
                  onSaved: (value) => name = value!,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Phone Number'),
                  keyboardType: TextInputType.phone,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter your phone number' : null,
                  onSaved: (value) => phone = value!,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Delivery Address'),
                  maxLines: 2,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter your address' : null,
                  onSaved: (value) => address = value!,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Note (Optional)',
                    hintText: 'Special instructions for delivery',
                  ),
                  maxLines: 2,
                  onSaved: (value) => note = value,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.of(ctx).pop(false),
          ),
          ElevatedButton(
            child: Text('Place Order'),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                Navigator.of(ctx).pop(true);
              }
            },
          ),
        ],
      ),
    );

    if (confirm ?? false) {
      setState(() => _isLoading = true);
      try {
        final total = items.fold<double>(
          0,
          (sum, item) => sum + (item.productPrice * item.quantity),
        );

        final order = OrderModel(
          userId: FirebaseAuth.instance.currentUser!.uid,
          items: items,
          total: total,
          address: address,
          phone: phone,
          customerName: name,
          orderDate: DateTime.now(),
          note: note,
        );

        await _orderService.placeOrder(order);
        await _cartService.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Order placed successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(); // Return to previous screen
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to place order. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }
}
