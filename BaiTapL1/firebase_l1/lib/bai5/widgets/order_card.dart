import 'package:firebase_l1/bai5/models/order.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;

  OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('Order #${order.id}'),
            subtitle: Text(
              'Total: \$${order.total.toStringAsFixed(2)}\n'
              'Date: ${DateFormat('dd/MM/yyyy HH:mm').format(order.orderDate)}'
            ),
            trailing: Text(
              order.status,
              style: TextStyle(
                color: order.status == 'Pending' ? Colors.orange : Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ExpansionTile(
            title: Text('Order Details'),
            children: [
              ...order.items.map((item) => ListTile(
                leading: Image.network(
                  item.productImage,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
                title: Text(item.productName),
                trailing: Text('${item.quantity} x \$${item.productPrice}'),
              )).toList(),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Shipping Address: ${order.address}'),
                    Text('Phone: ${order.phone}'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}