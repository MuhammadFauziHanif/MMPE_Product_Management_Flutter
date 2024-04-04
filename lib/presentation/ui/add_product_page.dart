import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
    try {
      // Get the bearer token from the provider
      prefs = await SharedPreferences.getInstance();
      var token = await prefs?.getString('token') ?? '';

      // Check if the token is available
      if (token == null) {
        throw Exception('Bearer token not available.');
      }

      // Create a multipart request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://app.actualsolusi.com/bsi/MitsubishiMotorsPartsECommerce/api/Products/upload'),
      );

      // Set the bearer token in the request headers
      request.headers['Authorization'] = 'Bearer $token';

      // Add fields to the request
      request.fields['ProductName'] = _productNameController.text;
      request.fields['CategoryID'] = _selectedCategory!.categoryId.toString();
      request.fields['Description'] = _descriptionController.text;
      request.fields['Price'] = _priceController.text;
      request.fields['StockQuantity'] = _stockQuantityController.text;

      // Add file to the request
      if (_selectedImage != null) {
        request.files.add(
          await http.MultipartFile.fromPath('file', _selectedImage!.path),
        );
      }

      // Send the request
      var response = await request.send();

      // Check the response status
      if (response.statusCode == 201) {
        // Product added successfully
        // Navigate back to the previous page or show a success message
        Navigator.pop(context);
      } else {
        // Error occurred
        // Handle the error, show an error message, etc.
        throw Exception('Failed to add product: ${response.reasonPhrase}');
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
            content: Text('Failed to add product. Please try again later.'),
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
