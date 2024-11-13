import 'package:firebase_l1/bai5/models/product.dart';
import 'package:firebase_l1/bai5/services/product_service.dart';
import 'package:flutter/material.dart';

class EditProductScreen extends StatefulWidget {
  final Product? product;

  EditProductScreen({this.product});

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final ProductService _productService = ProductService();
  
  late String name;
  late double price;
  late String description;
  late String imageUrl;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      name = widget.product!.name;
      price = widget.product!.price;
      description = widget.product!.description;
      imageUrl = widget.product!.imageUrl;
    } else {
      name = '';
      price = 0.0;
      description = '';
      imageUrl = '';
    }
  }

  Future<void> _saveForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        final product = Product(
          id: widget.product?.id,
          name: name,
          price: price,
          description: description,
          imageUrl: imageUrl,
        );

        if (widget.product == null) {
          await _productService.addProduct(product);
        } else {
          await _productService.updateProduct(product);
        }

        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.product == null
                  ? 'Product added successfully!'
                  : 'Product updated successfully!'
            ),
          ),
        );
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occurred!'),
            content: Text('Something went wrong.'),
            actions: [
              TextButton(
                child: Text('Okay'),
                onPressed: () => Navigator.of(ctx).pop(),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? 'Add Product' : 'Edit Product'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: name,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a name' : null,
                onSaved: (value) => name = value!,
              ),
              TextFormField(
                initialValue: price.toString(),
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Please enter a number greater than zero';
                  }
                  return null;
                },
                onSaved: (value) => price = double.parse(value!),
              ),
              TextFormField(
                initialValue: description,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a description' : null,
                onSaved: (value) => description = value!,
              ),
              TextFormField(
                initialValue: imageUrl,
                decoration: InputDecoration(labelText: 'Image URL'),
                keyboardType: TextInputType.url,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter an image URL';
                  }
                  if (!value.startsWith('http') && !value.startsWith('https')) {
                    return 'Please enter a valid URL';
                  }
                  return null;
                },
                onSaved: (value) => imageUrl = value!,
              ),
            ],
          ),
        ),
      ),
    );
  }
}