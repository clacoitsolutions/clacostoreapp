import 'dart:convert';

/// Category API Model //////////

class CategoryProduct {
  final String srNo;
  final String productCategory;
  final String catImg;
  final int cnt;

  CategoryProduct({
    required this.srNo,
    required this.productCategory,
    required this.catImg,
    required this.cnt,
  });

  factory CategoryProduct.fromJson(Map<String, dynamic> json) {
    return CategoryProduct(
      srNo: json['SrNo'] ?? '',
      productCategory: json['ProductCategory'] ?? '',
      catImg: json['CatImg'] ?? '',
      cnt: json['cnt'] ?? 0,
    );
  }
}

/// Rating API Model //////////

class RatingModel {
  final String ReviewId;
  final String ReviewStatus;
  final String ReviewDiscription;
  final String? CustomerId; // Can be null
  final String? CustomertName; // Can be null
  final DateTime AddedOn;
  final bool IsActive;
  final String productId;
  final dynamic image; // ... other fields from your API response

  RatingModel({
    required this.ReviewId,
    required this.ReviewStatus,
    this.CustomerId,
    this.CustomertName,
    required this.ReviewDiscription,
    required this.AddedOn,
    required this.IsActive,
    required this.productId,
    this.image,
    // ... initialize other fields
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      ReviewId: json['ReviewId'],
      ReviewStatus: json['ReviewStatus'],
      CustomerId: json['CustomerId'],
      CustomertName: json['CustomertName'],
      ReviewDiscription: json['ReviewDiscription'] ?? '',
      AddedOn: DateTime.tryParse(json['AddedOn']) ?? DateTime.now(),
      IsActive: json['IsActive'] ?? false,
      productId: json['productId'] ?? '',
      image: json['image'],
    );
  }
}

/// Discount API Model //////////

class DiscountModel {
  final String ProductCode;
  final double RegularPrice;
  final String ProductMainImageUrl;
  final String ProductName;
  final bool IsAvilableforsale;
  final double SalePrice;
  final double DiscountPercentage;

  DiscountModel({
    required this.ProductCode,
    required this.RegularPrice,
    required this.ProductMainImageUrl,
    required this.ProductName,
    required this.IsAvilableforsale,
    required this.SalePrice,
    required this.DiscountPercentage,
  });

  factory DiscountModel.fromJson(Map<String, dynamic> json) {
    return DiscountModel(
      ProductCode: json['ProductCode'] ?? '', // Provide a default value if null
      RegularPrice: json['RegularPrice']?.toDouble() ??
          0.0, // Handle potential null and type
      ProductMainImageUrl: json['ProductMainImageUrl'] ?? '',
      ProductName: json['ProductName'] ?? '',
      IsAvilableforsale: json['IsAvilableforsale'] ?? false,
      SalePrice: json['SalePrice']?.toDouble() ?? 0.0,
      DiscountPercentage: json['DiscountPercentage']?.toDouble() ?? 0.0,
    );
  }
}

/// Size Model ////
