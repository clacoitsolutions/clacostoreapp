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
  final String SubCategoryCode;

  ProductDetails({
    required this.SubCategoryCode,
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
      SubCategoryCode: json['SubCategoryCode'] ?? '',
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


class SimilarProduct {
  final String productName;
  final String productCode;
  final double regularPrice;
  final double salePrice;
  final String productMainImageUrl;

  SimilarProduct({
    required this.productName,
    required this.productCode,
    required this.regularPrice,
    required this.salePrice,
    required this.productMainImageUrl,
  });

  factory SimilarProduct.fromJson(Map<String, dynamic> json) {
    return SimilarProduct(
      productName: json['ProductName'],
      productCode: json['ProductCode'],
      regularPrice: json['RegularPrice'].toDouble(),
      salePrice: json['SalePrice'].toDouble(),
      productMainImageUrl: json['ProductMainImageUrl'],
    );
  }
}