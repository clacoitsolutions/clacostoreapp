class Banner {
  final String srNo;
  final String bannerType;
  final String bannerTitle;
  final String discountType;
  final int discountValue;
  final String categoryId;
  final String bannerImage;
  final bool isActive;
  final String entryDate;
  final dynamic entryBy; // Use dynamic to handle null values

  Banner({
    required this.srNo,
    required this.bannerType,
    required this.bannerTitle,
    required this.discountType,
    required this.discountValue,
    required this.categoryId,
    required this.bannerImage,
    required this.isActive,
    required this.entryDate,
    required this.entryBy,
  });

  factory Banner.fromJson(Map<String, dynamic> json) {
    return Banner(
      srNo: json['SrNo'],
      bannerType: json['BannerType'],
      bannerTitle: json['Bannertitle'],
      discountType: json['DiscountType'],
      discountValue: json['DiscountValue'],
      categoryId: json['CategoryId'],
      bannerImage: json['BannerImage'],
      isActive: json['IsActive'],
      entryDate: json['EntryDate'],
      entryBy: json['EntryBy'],
    );
  }
}