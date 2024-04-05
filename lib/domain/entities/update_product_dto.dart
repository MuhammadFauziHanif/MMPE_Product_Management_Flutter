import 'dart:io';

class UpdateProductDto {
  int productId;
  String productName;
  int categoryId;
  String description;
  double price;
  int stockQuantity;
  String imageUrl;

  UpdateProductDto({
    required this.productId,
    required this.productName,
    required this.categoryId,
    required this.description,
    required this.price,
    required this.stockQuantity,
    required this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'ProductID': productId,
      'ProductName': productName,
      'CategoryID': categoryId,
      'Description': description,
      'Price': price,
      'StockQuantity': stockQuantity,
      'ImageUrl': imageUrl,
    };
  }
}
