class Banner {
  final String srNo;
  final String bannerType;
  final String bannerTitle;
  final String discountType;
  final int discountValue;
  final String categoryId;
  final String bannerImage;
  final bool isActive;
  final DateTime? entryDate; // Make entryDate nullable
  final String entryBy;

  Banner({
    required this.srNo,
    required this.bannerType,
    required this.bannerTitle,
    required this.discountType,
    required this.discountValue,
    required this.categoryId,
    required this.bannerImage,
    required this.isActive,
    this.entryDate, // No longer required, can be null
    required this.entryBy,
  });

  factory Banner.fromJson(Map<String, dynamic> json) {
    return Banner(
      srNo: json['SrNo'] ?? "",
      bannerType: json['BannerType'] ?? "",
      bannerTitle: json['Bannertitle']?? "",
      discountType: json['DiscountType']?? "",
      discountValue: json['DiscountValue']?? "",
      categoryId: json['CategoryId']?? "",
      bannerImage: json['BannerImage']?? "",
      isActive: json['IsActive']?? "",
      entryDate: json['EntryDate'] != null ? DateTime.parse(json['EntryDate']) : null, // Handle null value
      entryBy: json['EntryBy']?? "",
    );
  }
}