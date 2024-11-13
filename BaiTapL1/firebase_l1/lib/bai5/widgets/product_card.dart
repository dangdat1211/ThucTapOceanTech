import 'package:firebase_l1/bai5/models/product.dart';
import 'package:firebase_l1/bai5/screens/product_detail.dart';
import 'package:firebase_l1/bai5/services/cart_service.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final CartService _cartService = CartService();

  ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Image.network(
            product.imageUrl,
            height: 120,
            fit: BoxFit.cover,
          ),
          Text(product.name),
          Text('\$${product.price}'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(Icons.add_shopping_cart),
                onPressed: () {
                  _cartService.addItem(product);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Added to cart!')),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.info),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => ProductDetail(product: product),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}