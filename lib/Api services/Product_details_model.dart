class ProductDetails {
  final String productCode;
  final String productName;
  final double regularPrice;
  final double salePrice;
  final double onlinePrice;
  final String productMainImageUrl;
  final String productDescription;
  final int stockStatus;
  final String deliveryTime;
  final String productCategory;

  ProductDetails({
    required this.productCode,
    required this.productName,
    required this.regularPrice,
    required this.salePrice,
    required this.onlinePrice,
    required this.productMainImageUrl,
    required this.productDescription,
    required this.stockStatus,
    required this.deliveryTime,
    required this.productCategory,
  });

  factory ProductDetails.fromJson(Map<String, dynamic> json) {
    return ProductDetails(
      productCode: json['ProductCode'] ?? '',
      productName: json['ProductName'] ?? '',
      regularPrice: json['RegularPrice'] ?? 0.0,
      salePrice: json['SalePrice'] ?? 0.0,
      onlinePrice: json['OnlinePrice'] ?? 0.0,
      productMainImageUrl: json['ProductMainImageUrl'] ?? '',
      productDescription: json['ProductDescription'] ?? '',
      stockStatus: json['StockStatus'] ?? 0,
      deliveryTime: json['DeliveryTime'] ?? '',
      productCategory: json['ProductCategory'] ?? '',
    );
  }
}
