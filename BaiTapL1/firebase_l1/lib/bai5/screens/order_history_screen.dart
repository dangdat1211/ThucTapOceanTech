import 'package:firebase_l1/bai5/models/order_model.dart';
import 'package:firebase_l1/bai5/services/order_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderHistoryScreen extends StatelessWidget {
  final OrderService _orderService = OrderService();
  final String userId = 'testid'; // Replace with actual user ID

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Order History')),
      body: StreamBuilder<List<OrderModel>>(
        stream: _orderService.getUserOrders(userId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final orders = snapshot.data!;
          if (orders.isEmpty) {
            return Center(child: Text('No orders yet'));
          }

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return Card(
                margin: EdgeInsets.all(8),
                child: ExpansionTile(
                  title: Text(
                    'Order #${order.id.substring(0, 8)}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Date: ${DateFormat('dd/MM/yyyy HH:mm').format(order.orderDate)}\n'
                    'Status: ${order.status}',
                  ),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Items:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: order.items.length,
                            itemBuilder: (context, index) {
                              final item = order.items[index];
                              return ListTile(
                                title: Text(item.productName),
                                subtitle: Text('Quantity: ${item.quantity}'),
                                trailing: Text(
                                  '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                                ),
                              );
                            },
                          ),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '\$${order.total.toStringAsFixed(2)}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Delivery Address:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(order.address),
                          SizedBox(height: 8),
                          Text(
                            'Phone:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(order.phone),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}