import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_l1/bai5/models/cart_item.dart';
import 'package:firebase_l1/bai5/models/product.dart';

class CartService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  String get _userId => _auth.currentUser!.uid;
  String get _cartId => 'cart_$_userId';

  // Stream để lắng nghe thay đổi của giỏ hàng
  Stream<List<CartItem>> getCartItems() {
    return _firestore
        .collection('carts')
        .doc(_cartId)
        .collection('items')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CartItem.fromMap(doc.data(), doc.id))
            .toList());
  }

  // Thêm sản phẩm vào giỏ hàng
  Future<void> addItem(Product product) async {
    try {
      final cartRef = _firestore
          .collection('carts')
          .doc(_cartId)
          .collection('items');

      // Kiểm tra xem sản phẩm đã có trong giỏ hàng chưa
      final existingItemQuery = await cartRef
          .where('productId', isEqualTo: product.id)
          .get();

      if (existingItemQuery.docs.isNotEmpty) {
        // Nếu sản phẩm đã tồn tại, tăng số lượng
        final existingDoc = existingItemQuery.docs.first;
        final currentQuantity = existingDoc.data()['quantity'] as int;
        
        await cartRef
            .doc(existingDoc.id)
            .update({'quantity': currentQuantity + 1});
      } else {
        // Nếu sản phẩm chưa có, thêm mới
        final cartItem = CartItem.fromProduct(product);
        await cartRef.add(cartItem.toMap());
      }
    } catch (e) {
      print('Error adding item to cart: $e');
      rethrow;
    }
  }

  // Cập nhật số lượng sản phẩm
  Future<void> updateQuantity(String itemId, int quantity) async {
    try {
      await _firestore
          .collection('carts')
          .doc(_cartId)
          .collection('items')
          .doc(itemId)
          .update({'quantity': quantity});
    } catch (e) {
      print('Error updating quantity: $e');
      rethrow;
    }
  }

  // Xóa sản phẩm khỏi giỏ hàng
  Future<void> removeItem(String itemId) async {
    try {
      await _firestore
          .collection('carts')
          .doc(_cartId)
          .collection('items')
          .doc(itemId)
          .delete();
    } catch (e) {
      print('Error removing item from cart: $e');
      rethrow;
    }
  }

  // Xóa toàn bộ giỏ hàng
  Future<void> clear() async {
    try {
      final cartRef = _firestore
          .collection('carts')
          .doc(_cartId)
          .collection('items');
      
      final items = await cartRef.get();
      
      for (var item in items.docs) {
        await item.reference.delete();
      }
    } catch (e) {
      print('Error clearing cart: $e');
      rethrow;
    }
  }

  // Tính tổng tiền giỏ hàng
  Future<double> getTotal() async {
    try {
      final cartItems = await _firestore
          .collection('carts')
          .doc(_cartId)
          .collection('items')
          .get();

      return cartItems.docs.fold(0.0, (sum, item) {
        final data = item.data();
        return (data['productPrice'] as double) * (data['quantity'] as int);
      });
    } catch (e) {
      print('Error calculating total: $e');
      return 0.0;
    }
  }
}