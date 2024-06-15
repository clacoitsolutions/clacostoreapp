class WishList {
  int amount;
  int RegularPrice;
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
      amount: json['amount'] ?? 0,
      RegularPrice: json['RegularPrice'] ?? 0,
      productId: json['productId'] ?? '',
      ProductMainImageUrl: json['ProductMainImageUrl'] ?? '',
      ProductName: json['ProductName'] ?? '',
      productType: json['productType'] ?? '',
      mainCategoryCode: json['mainCategoryCode'] ?? '',
      productCategory: json['productCategory'] ?? '',
    );
  }
}
