class CartItem {
  int cartListId;
  String customerId;
  String productId;
  bool isActive;
  int quantity;
  dynamic isdeleted;
  dynamic purchaseBy;
  DateTime cartEntryDate;
  dynamic updateDate;
  dynamic companyCode;
  String variationCode;
  dynamic sizeName;
  dynamic colorName;
  String ProductMainImageUrl;
  int OnlinePrice;
  String productName;

  CartItem({
    required this.cartListId,
    required this.customerId,
    required this.productId,
    required this.isActive,
    required this.quantity,
    required this.isdeleted,
    required this.purchaseBy,
    required this.cartEntryDate,
    required this.updateDate,
    required this.companyCode,
    required this.variationCode,
    required this.sizeName,
    required this.colorName,
    required this.ProductMainImageUrl,
    required this.OnlinePrice,
    required this.productName,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
        cartListId: json['cartListId'] ?? 0,
        customerId: json['customerId'] ?? '',
        productId: json['productId'] ?? '',
        isActive: json['isActive'] ?? false,
        quantity: json['quantity'] ?? 0,
        isdeleted: json['isdeleted'],
        purchaseBy: json['purchaseBy'],
        cartEntryDate: json['cartEntryDate'] != null ? DateTime.parse(json['cartEntryDate']) : DateTime.now(),
    updateDate: json['updateDate'],
    companyCode: json['companyCode'],
    variationCode: json['variationCode'] ?? '',
    sizeName: json['sizeName'],
    colorName: json['colorName'],
      ProductMainImageUrl: json['ProductMainImageUrl'] ?? '',
      OnlinePrice: json['OnlinePrice'] ?? 0,
      productName: json['ProductName'] ?? '',
    );
  }
}