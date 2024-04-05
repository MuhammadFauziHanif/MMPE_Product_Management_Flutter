import 'dart:io';

class AddProductDto {
  String productName;
  int categoryId;
  String description;
  double price;
  int stockQuantity;
  File? imageUrl;

  AddProductDto({
    required this.productName,
    required this.categoryId,
    required this.description,
    required this.price,
    required this.stockQuantity,
    required this.imageUrl,
  });
}
