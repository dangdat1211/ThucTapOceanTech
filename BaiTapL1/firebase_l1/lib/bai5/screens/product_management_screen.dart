import 'package:firebase_l1/bai5/models/product.dart';
import 'package:firebase_l1/bai5/screens/edit_product_screen.dart';
import 'package:firebase_l1/bai5/services/product_service.dart';
import 'package:flutter/material.dart';

class ProductManagementScreen extends StatelessWidget {
  final ProductService _productService = ProductService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Products'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => EditProductScreen(),
              ),
            ),
          ),
        ],
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

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (ctx, i) => ListTile(
              leading: Image.network(
                snapshot.data![i].imageUrl,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              title: Text(snapshot.data![i].name),
              subtitle: Text('\$${snapshot.data![i].price}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => EditProductScreen(
                          product: snapshot.data![i],
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                     icon: Icon(Icons.delete),
                    onPressed: () => showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text('Delete Product'),
                        content: Text('Are you sure you want to delete this product?'),
                        actions: [
                          TextButton(
                            child: Text('Cancel'),
                            onPressed: () => Navigator.of(ctx).pop(),
                          ),
                          ElevatedButton(
                            child: Text('Delete'),
                            onPressed: () async {
                              await _productService.deleteProduct(
                                snapshot.data![i].id!
                              );
                              Navigator.of(ctx).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}