import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_l1/bai5/models/order.dart';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> placeOrder(OrderModel order) async {
    try {
      await _firestore.collection('orders').add(order.toMap());
    } catch (e) {
      print('Error placing order: $e');
      rethrow;
    }
  }

  Stream<List<OrderModel>> getUserOrders(String userId) {
    return _firestore
      .collection('orders')
      .where('userId', isEqualTo: userId)
      .snapshots()
      .map((snapshot) => snapshot.docs
        .map((doc) => OrderModel.fromMap(doc.data(), doc.id))
        .toList());
  }
}