class Category {
  int categoryId;
  String categoryName;

  Category({
    required this.categoryId,
    required this.categoryName,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'CategoryID': int categoryId,
        'CategoryName': String categoryName,
      } =>
        Category(
          categoryId: categoryId,
          categoryName: categoryName,
        ),
      _ => throw const FormatException('Gagal membuat category')
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'CategoryID': this.categoryId,
      'CategoryName': this.categoryName,
    };
  }
}
