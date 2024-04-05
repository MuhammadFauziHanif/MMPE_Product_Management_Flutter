import 'package:mitsubishi_motors_parts_e_commerce/domain/entities/category.dart';

class Product {
  int productId;
  String productName;
  int categoryId;
  String description;
  double price;
  int stockQuantity;
  String imageUrl;
  Category category;

  Product({
    required this.productId,
    required this.productName,
    required this.categoryId,
    required this.description,
    required this.price,
    required this.stockQuantity,
    required this.imageUrl,
    required this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: json['ProductID'] as int,
      productName: json['ProductName'] as String,
      categoryId: json['CategoryID'] as int,
      description: json['Description'] as String,
      price: (json['Price'] as num).toDouble(),
      stockQuantity: json['StockQuantity'] as int,
      imageUrl: json['ImageUrl'] as String,
      category: Category.fromJson(json['Category'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ProductID': productId,
      'ProductName': productName,
      'CategoryID': categoryId,
      'Description': description,
      'Price': price,
      'StockQuantity': stockQuantity,
      'ImageUrl': imageUrl,
      'Category': category.toJson(),
    };
  }
}
