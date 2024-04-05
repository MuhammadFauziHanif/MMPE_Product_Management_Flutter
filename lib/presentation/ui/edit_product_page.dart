import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mitsubishi_motors_parts_e_commerce/domain/entities/category.dart';
import 'package:mitsubishi_motors_parts_e_commerce/domain/entities/product.dart';
import 'package:mitsubishi_motors_parts_e_commerce/domain/entities/update_product_dto.dart';
import 'package:mitsubishi_motors_parts_e_commerce/presentation/widget/image_input.dart';
import 'package:mitsubishi_motors_parts_e_commerce/presentation/provider/product_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProductPage extends StatefulWidget {
  final Product product;

  const EditProductPage({Key? key, required this.product}) : super(key: key);

  @override
  _EditProductPageState createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockQuantityController =
      TextEditingController();
  Category? _selectedCategory;
  SharedPreferences? prefs;
  late List<Category> _categories;

  Future<void> _fetchCategories() async {
    await Provider.of<ProductProvider>(context, listen: false).getCategories();
    _categories =
        Provider.of<ProductProvider>(context, listen: false).listCategory;
    _selectedCategory = _categories.firstWhere((category) =>
        category.categoryId == widget.product.category.categoryId);
    setState(() {
      // set the selected category to the product's category
    });
  }

  @override
  void initState() {
    super.initState();
    _populateFields();
    _fetchCategories();
  }

  void _populateFields() {
    _productNameController.text = widget.product.productName;
    _descriptionController.text = widget.product.description;
    _priceController.text = widget.product.price.toString();
    _stockQuantityController.text = widget.product.stockQuantity.toString();
  }

  Future<void> _updateProduct() async {
    try {
      UpdateProductDto updateProductDto = UpdateProductDto(
        productId: widget.product.productId,
        productName: _productNameController.text,
        categoryId: _selectedCategory!.categoryId,
        description: _descriptionController.text,
        price: double.parse(_priceController.text),
        stockQuantity: int.parse(_stockQuantityController.text),
        imageUrl: widget.product.imageUrl,
      );

      print(
          'productId: ${updateProductDto.productId}, productName: ${updateProductDto.productName}, categoryId: ${updateProductDto.categoryId}, description: ${updateProductDto.description}, price: ${updateProductDto.price}, stockQuantity: ${updateProductDto.stockQuantity}, imageUrl: ${updateProductDto.imageUrl}');
      var response = await Provider.of<ProductProvider>(context, listen: false)
          .editProduct(updateProductDto);

      print('response from editProduct: $response');
      // if successful, show snackbar and navigate back to product list
      if (response) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Product ${updateProductDto.productName} updated successfully!'),
          ),
        );
        await Provider.of<ProductProvider>(context, listen: false)
            .getProducts();
        Navigator.pop(context);
      }
    } catch (e) {
      // Error occurred during the product update process
      // Handle the error, show an error message, etc.
      print('Error updating product: $e');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to update product. Please try again later.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
                child: Image.network(
                  widget.product.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            TextField(
              controller: _productNameController,
              decoration: InputDecoration(labelText: 'Product Name'),
            ),
            SizedBox(height: 10),
            Consumer<ProductProvider>(
              builder: (context, provider, child) {
                List<Category> _categories = provider.listCategory;
                return (_categories.isNotEmpty && _selectedCategory != null)
                    ? DropdownButtonFormField<Category>(
                        value: _selectedCategory,
                        onChanged: (Category? value) {
                          setState(() {
                            _selectedCategory = value!;
                          });
                        },
                        items: _categories.map<DropdownMenuItem<Category>>(
                            (Category category) {
                          return DropdownMenuItem<Category>(
                            value: category,
                            child: Text(category.categoryName),
                          );
                        }).toList(),
                        decoration: InputDecoration(labelText: 'Category'),
                        selectedItemBuilder: (BuildContext context) {
                          return _categories.map<Widget>((Category category) {
                            return Text(category.categoryName);
                          }).toList();
                        },
                      )
                    : LinearProgressIndicator();
              },
            ),
            SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            TextField(
              controller: _stockQuantityController,
              decoration: InputDecoration(labelText: 'Stock Quantity'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateProduct,
              child: Text('Update Product'),
            ),
          ],
        ),
      ),
    );
  }
}
