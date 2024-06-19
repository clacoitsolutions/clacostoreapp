import 'dart:convert';

class Product {
  final String entryDate;
  final String productCode;
  final String productName;
  final int regularPrice;
  final int salePrice;
  final String productMainImageUrl;
  final String productDescription;
  final String productType;
  final String refundAndReturnPolicy;
  final String productNameShort;
  final int discPer;
  final String mainCategoryCode;
  final String productCategory;
  final int attrId;
  final int varId;
  final int saleValue;

  Product({
    required this.entryDate,
    required this.productCode,
    required this.productName,
    required this.regularPrice,
    required this.salePrice,
    required this.productMainImageUrl,
    required this.productDescription,
    required this.productType,
    required this.refundAndReturnPolicy,
    required this.productNameShort,
    required this.discPer,
    required this.mainCategoryCode,
    required this.productCategory,
    required this.attrId,
    required this.varId,
    required this.saleValue,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      entryDate: json['EntryDate'],
      productCode: json['ProductCode'],
      productName: json['ProductName'],
      regularPrice: json['RegularPrice'],
      salePrice: json['SalePrice'],
      productMainImageUrl: json['ProductMainImageUrl'],
      productDescription: json['ProductDescription'],
      productType: json['ProductType'],
      refundAndReturnPolicy: json['RefundAndreturnPolicy'],
      productNameShort: json['pName'],
      discPer: json['Discper'],
      mainCategoryCode: json['MainCategoryCode'],
      productCategory: json['ProductCategory'],
      attrId: json['AttrId'],
      varId: json['VarId'],
      saleValue: json['saleValue'],
    );
  }
}
