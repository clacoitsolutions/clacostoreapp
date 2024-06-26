// models/order_item.dart

class OrderItem {
  final String orderId;
  final String orderDate;
  final String customerId;
  final int? grossAmount; // Use nullable type
  final int? deliveryCharges; // Use nullable type
  final String paymentMode;
  final String deliveryStatus;
  final String deliveryTime;
  final String itemCode;
  final String quantity;
  final double? totalAmount; // Use nullable type
  final String productMainImageUrl;
  final String productName;
  final String customerName;
  final String customerMobile;
  final String customerPinCode;
  final String customerAddressType;
  final String customerAddress;

  OrderItem({
    required this.orderId,
    required this.orderDate,
    required this.customerId,
    this.grossAmount,
    this.deliveryCharges,
    required this.paymentMode,
    required this.deliveryStatus,
    required this.deliveryTime,
    required this.itemCode,
    required this.quantity,
    this.totalAmount,
    required this.productMainImageUrl,
    required this.productName,
    required this.customerName,
    required this.customerMobile,
    required this.customerPinCode,
    required this.customerAddressType,
    required this.customerAddress,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      orderId: json['OrderId'] ?? '', // Handle null or empty strings
      orderDate: json['OrderDate'] ?? '',
      customerId: json['CustomerId'] ?? '',
      grossAmount: int.tryParse(json['GrossAmount']?.toString() ?? '0'), // Handle null and parse to int
      deliveryCharges: int.tryParse(json['DeliveryCharges']?.toString() ?? '0'),
      paymentMode: json['PaymentMode'] ?? '',
      deliveryStatus: json['DeliveryStatus'] ?? '',
      deliveryTime: json['DeliveryTime'] ?? '',
      itemCode: json['ItemCode'] ?? '',
      quantity: json['Quantity'] ?? '',
      totalAmount: double.tryParse(json['TotalAmount']?.toString() ?? '0.0'), // Handle null and parse to double
      productMainImageUrl: json['MainImage'] ?? '',
      productName: json['ProductName'] ?? '',
      customerName: json['CustomerName'] ?? '',
      customerMobile: json['CustomerMobile'] ?? '',
      customerPinCode: json['CustomerPinCode'] ?? '',
      customerAddressType: json['CustomerAddressType'] ?? '',
      customerAddress: json['CustomerAddress'] ?? '',
    );
  }
}