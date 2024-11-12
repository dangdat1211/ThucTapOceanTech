

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_l1/bai5/models/cart_model.dart';

class CartService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addToCart(String userId, CartModel item) async {
    try {
      await _firestore
          .collection('carts')
          .doc(userId)
          .collection('items')
          .doc(item.id)
          .set(item.toMap());
    } catch (e) {
      throw Exception('Failed to add item to cart: $e');
    }
  }

  Stream<List<CartModel>> getCartItems(String userId) {
    return _firestore
        .collection('carts')
        .doc(userId)
        .collection('items')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => CartModel.fromMap(doc.data()))
          .toList();
    });
  }

  Future<void> updateCartItemQuantity(
      String userId, String itemId, int quantity) async {
    try {
      await _firestore
          .collection('carts')
          .doc(userId)
          .collection('items')
          .doc(itemId)
          .update({'quantity': quantity});
    } catch (e) {
      throw Exception('Failed to update cart item quantity: $e');
    }
  }

  Future<void> removeFromCart(String userId, String itemId) async {
    try {
      await _firestore
          .collection('carts')
          .doc(userId)
          .collection('items')
          .doc(itemId)
          .delete();
    } catch (e) {
      throw Exception('Failed to remove item from cart: $e');
    }
  }
}