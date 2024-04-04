class Product {
  int productId;
  String productName;
  int categoryId;
  String description;
  double price;
  int stockQuantity;
  String imageUrl;

  Product({
    required this.productId,
    required this.productName,
    required this.categoryId,
    required this.description,
    required this.price,
    required this.stockQuantity,
    required this.imageUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'ProductID': int productId,
        'ProductName': String productName,
        'CategoryID': int categoryId,
        'Description': String description,
        'Price': double price,
        'StockQuantity': int stockQuantity,
        'ImageUrl': String imageUrl,
      } =>
        Product(
          productId: productId,
          productName: productName,
          categoryId: categoryId,
          description: description,
          price: price,
          stockQuantity: stockQuantity,
          imageUrl: imageUrl,
        ),
      _ => throw const FormatException('Gagal membuat product')
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'ProductID': this.productId,
      'ProductName': this.productName,
      'CategoryID': this.categoryId,
      'Description': this.description,
      'Price': this.price,
      'StockQuantity': this.stockQuantity,
      'ImageUrl': this.imageUrl,
    };
  }
}
