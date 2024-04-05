import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mitsubishi_motors_parts_e_commerce/domain/entities/add_product_dto.dart';
import 'package:mitsubishi_motors_parts_e_commerce/domain/entities/category.dart';
import 'package:mitsubishi_motors_parts_e_commerce/presentation/widget/image_input.dart';
import 'package:mitsubishi_motors_parts_e_commerce/presentation/provider/product_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddProductPage extends StatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockQuantityController =
      TextEditingController();
  File? _selectedImage;
  late List<Category> _categories;
  Category? _selectedCategory;
  SharedPreferences? prefs = null;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    await Provider.of<ProductProvider>(context, listen: false).getCategories();
    _categories =
        Provider.of<ProductProvider>(context, listen: false).listCategory;
    setState(() {
      _selectedCategory = _categories.first;
    });
  }

  Future<void> _addProduct() async {
    AddProductDto addProductDto = AddProductDto(
      productName: _productNameController.text,
      categoryId: _selectedCategory!.categoryId,
      description: _descriptionController.text,
      price: double.parse(_priceController.text),
      stockQuantity: int.parse(_stockQuantityController.text),
      imageUrl: _selectedImage,
    );
    try {
      var response = await Provider.of<ProductProvider>(context, listen: false)
          .addProduct(addProductDto);

      //print the product dto
      print(
          'productName: ${addProductDto.productName}, categoryId: ${addProductDto.categoryId}, description: ${addProductDto.description}, price: ${addProductDto.price}, stockQuantity: ${addProductDto.stockQuantity}, imageUrl: ${addProductDto.imageUrl}');
      // Check the response status
      if (response) {
        // Product added successfully
        // Navigate back to the previous page or show a success message
        Provider.of<ProductProvider>(context, listen: false).getProducts();
        Navigator.pop(context);
      }
    } catch (e) {
      // Error occurred during the product addition process
      // Handle the error, show an error message, etc.
      print('Error adding product: $e');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to add product: $e'),
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
        title: Text('Add New Product'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
// Placeholder until categories are fetched
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
            SizedBox(height: 10),
            ImageInput(
              onPickImage: (image) {
                _selectedImage = image;
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addProduct,
              child: Text('Add Product'),
            ),
          ],
        ),
      ),
    );
  }
}
