class Category {
  final String srNo;
  final String productCategory;
  final String categoryImage;

  Category({
    required this.srNo,
    required this.productCategory,
    required this.categoryImage,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      srNo: json['SrNo'],
      productCategory: json['ProductCategory'],
      categoryImage: json['CategoryImage'],
    );
  }
}
