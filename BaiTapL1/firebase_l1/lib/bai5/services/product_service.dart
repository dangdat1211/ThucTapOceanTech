import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_l1/bai5/models/product.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Product>> getProducts() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('products').get();
      return snapshot.docs.map((doc) => 
        Product.fromMap(doc.data() as Map<String, dynamic>, doc.id)
      ).toList();
    } catch (e) {
      print('Error getting products: $e');
      return [];
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      await _firestore.collection('products').add(product.toMap());
    } catch (e) {
      print('Error adding product: $e');
      rethrow;
    }
  }

  Future<void> updateProduct(Product product) async {
    try {
      await _firestore
        .collection('products')
        .doc(product.id)
        .update(product.toMap());
    } catch (e) {
      print('Error updating product: $e');
      rethrow;
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      await _firestore.collection('products').doc(id).delete();
    } catch (e) {
      print('Error deleting product: $e');
      rethrow;
    }
  }
}