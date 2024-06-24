import 'dart:convert';

class SizeModel {
  final String SrNo;
  final String CompanyCode;
  final String CenterCode;
  final String ProductGroupCode;
  final String ProductCode;
  final double OnlinePrice;
  final int StockQuantity;
  final String ProductDescription;
  final String ProductMainImageUrl;
  final bool IsAvilableForSale;
  final bool IsActive;
  final DateTime EntryDate;
  final String EntryBy;
  final String? ProductSpecification;
  final String ProductName;
  final String MainCategoryCode;
  final String SubCategoryCode;
  final String ProductType;
  final bool IsInventoryProduct;
  final int RegularPrice;
  final double SalePrice;
  final int DiscPer;
  final String KeyWords;
  final dynamic IsFeatured;
  final int GSTRate;
  final int CessRate;
  final String ManufacturerId;
  final String RefundAndreturnPolicy;
  final String Taxstatus;
  final double GstAmount;
  final dynamic GstExcludeRate;
  final dynamic ColorCode;
  final dynamic SizeCode;
  final dynamic VendorId;
  final String VendarStatus;
  final bool FashionType;
  final dynamic DailydealId;
  final String DeliveryTime;

  SizeModel({
    required this.SrNo,
    required this.CompanyCode,
    required this.CenterCode,
    required this.ProductGroupCode,
    required this.ProductCode,
    required this.OnlinePrice,
    required this.StockQuantity,
    required this.ProductDescription,
    required this.ProductMainImageUrl,
    required this.IsAvilableForSale,
    required this.IsActive,
    required this.EntryDate,
    required this.EntryBy,
    this.ProductSpecification,
    required this.ProductName,
    required this.MainCategoryCode,
    required this.SubCategoryCode,
    required this.ProductType,
    required this.IsInventoryProduct,
    required this.RegularPrice,
    required this.SalePrice,
    required this.DiscPer,
    required this.KeyWords,
    this.IsFeatured,
    required this.GSTRate,
    required this.CessRate,
    required this.ManufacturerId,
    required this.RefundAndreturnPolicy,
    required this.Taxstatus,
    required this.GstAmount,
    this.GstExcludeRate,
    this.ColorCode,
    this.SizeCode,
    this.VendorId,
    required this.VendarStatus,
    required this.FashionType,
    this.DailydealId,
    required this.DeliveryTime,
  });

  factory SizeModel.fromJson(Map<String, dynamic> json) {
    return SizeModel(
      SrNo: json['SrNo'] ?? '',
      CompanyCode: json['CompanyCode'] ?? '',
      CenterCode: json['CenterCode'] ?? '',
      ProductGroupCode: json['ProductGroupCode'] ?? '',
      ProductCode: json['ProductCode'] ?? '',
      OnlinePrice: json['OnlinePrice']?.toDouble() ?? 0.0,
      StockQuantity: json['StockQuantity']?.toInt() ?? 0,
      ProductDescription: json['ProductDescription'] ?? '',
      ProductMainImageUrl: json['ProductMainImageUrl'] ?? '',
      IsAvilableForSale: json['IsAvilableForSale'] ?? false,
      IsActive: json['IsActive'] ?? false,
      EntryDate: DateTime.tryParse(json['EntryDate']) ??
          DateTime.now(), // Try to parse DateTime
      EntryBy: json['EntryBy'] ?? '',
      ProductSpecification: json['ProductSpecification'],
      ProductName: json['ProductName'] ?? '',
      MainCategoryCode: json['MainCategoryCode'] ?? '',
      SubCategoryCode: json['SubCategoryCode'] ?? '',
      ProductType: json['ProductType'] ?? '',
      IsInventoryProduct: json['IsInventoryProduct'] ?? false,
      RegularPrice: json['RegularPrice']?.toInt() ?? 0,
      SalePrice: json['SalePrice']?.toDouble() ?? 0.0,
      DiscPer: json['DiscPer']?.toInt() ?? 0,
      KeyWords: json['KeyWords'] ?? '',
      IsFeatured: json['IsFeatured'], // Keep as dynamic for now
      GSTRate: json['GSTRate']?.toInt() ?? 0,
      CessRate: json['CessRate']?.toInt() ?? 0,
      ManufacturerId: json['ManufacturerId'] ?? '',
      RefundAndreturnPolicy: json['RefundAndreturnPolicy'] ?? '',
      Taxstatus: json['Taxstatus'] ?? '',
      GstAmount: json['GstAmount']?.toDouble() ?? 0.0,
      GstExcludeRate: json['GstExcludeRate'], // Keep as dynamic for now
      ColorCode: json['ColorCode'],
      SizeCode: json['SizeCode'],
      VendorId: json['VendorId'],
      VendarStatus: json['VendarStatus'] ?? '',
      FashionType: json['FashionType'] ?? false,
      DailydealId: json['DailydealId'], // Keep as dynamic for now
      DeliveryTime: json['DeliveryTime'] ?? '',
    );
  }
}

class Data {
  final String productMainImageUrl;
  final String productName;
  final double regularPrice;
  final String productDescription;
  final String deliveryTime;

  Data({
    required this.productMainImageUrl,
    required this.productName,
    required this.regularPrice,
    required this.productDescription,
    required this.deliveryTime,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      productMainImageUrl: json['ProductMainImageUrl'] ?? '',
      productName: json['ProductName'] ?? '',
      regularPrice: json['RegularPrice'] != null
          ? double.parse(json['RegularPrice'].toString())
          : 0.0,
      productDescription: json['ProductDescription'] ?? '',
      deliveryTime: json['DeliveryTime'] ?? '',
    );
  }
}
