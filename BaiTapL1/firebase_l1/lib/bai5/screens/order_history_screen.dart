import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_l1/bai5/models/order.dart';
import 'package:firebase_l1/bai5/services/order_service.dart';
import 'package:firebase_l1/bai5/widgets/order_card.dart';
import 'package:flutter/material.dart';

class OrderHistoryScreen extends StatelessWidget {
  final OrderService _orderService = OrderService();

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Order History'),
      ),
      body: StreamBuilder<List<OrderModel>>(
        stream: _orderService.getUserOrders(userId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (ctx, i) => OrderCard(
              order: snapshot.data![i],
            ),
          );
        },
      ),
    );
  }
}
