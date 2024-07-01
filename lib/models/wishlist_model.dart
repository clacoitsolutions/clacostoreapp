class WishList {
  String amount; // should be String type
  num RegularPrice;
  String productId;
  String ProductMainImageUrl;
  String ProductName;
  String productType;
  String mainCategoryCode;
  String productCategory;

  WishList({
    required this.amount,
    required this.RegularPrice,
    required this.productId,
    required this.ProductMainImageUrl,
    required this.ProductName,
    required this.productType,
    required this.mainCategoryCode,
    required this.productCategory,
  });

  factory WishList.fromJson(Map<String, dynamic> json) {
    return WishList(
      amount: json['amount'].toString(), // Convert to String
      RegularPrice: json['RegularPrice'] ?? 0,
      productId: json['ProductId'] ?? '',
      ProductMainImageUrl: json['ProductMainImageUrl'] ?? '',
      ProductName: json['ProductName'] ?? '',
      productType: json['ProductType'] ?? '',
      mainCategoryCode: json['MainCategoryCode'] ?? '',
      productCategory: json['ProductCategory'] ?? '',
    );
  }
}
