import 'package:firebase_l1/bai5/services/product_service.dart';
import 'package:firebase_l1/bai5/widgets/product_card.dart';
import 'package:flutter/material.dart';

import '../models/product.dart';

class ProductListScreen extends StatelessWidget {
  final ProductService _productService = ProductService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
      ),
      body: StreamBuilder<List<Product>>(
        stream: _productService.getProducts().asStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          return GridView.builder(
            padding: EdgeInsets.all(10),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2/3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: snapshot.data!.length,
            itemBuilder: (ctx, i) => ProductCard(
              product: snapshot.data![i],
            ),
          );
        },
      ),
    );
  }
}