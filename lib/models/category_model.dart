import 'dart:convert';

class Category {
  String srNo;
  String productCategory;
  String parrentCategoryId;
  String categoryImage;
  bool isActive;
  DateTime entryDate;
  String? srNo1; // Make srNo1 nullable
  String? entryBy; // Make entryBy nullable

  Category({
    required this.srNo,
    required this.productCategory,
    required this.parrentCategoryId,
    required this.categoryImage,
    required this.isActive,
    required this.entryDate,
    this.srNo1, // No need for required
    this.entryBy, // No need for required
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      srNo: json['SrNo'] ?? '',
      productCategory: json['ProductCategory'] ?? '',
      parrentCategoryId: json['ParrentCategoryId'] ?? '',
      categoryImage: json['CategoryImage'] ?? '',
      isActive: json['IsActive'] ?? false,
      entryDate: json['EntryDate'] != null
          ? DateTime.parse(json['EntryDate'])
          : DateTime.now(), // Default to current date if null
      srNo1: json['SrNo1'] != null ? json['SrNo1'].toString() : null, // Handle null or missing
      entryBy: json['EntryBy'], // Handle null or missing
    );
  }
}