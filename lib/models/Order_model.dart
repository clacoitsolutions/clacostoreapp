// models/order_item.dart

class OrderItem {
  final String orderId;
  final String orderDate;
  final String customerId;
  final int grossAmount;
  final int deliveryCharges;
  final String paymentMode;
  final String deliveryStatus;
  final String deliveryTime;
  final String itemCode;
  final String quantity;
  final double totalAmount;
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
    required this.grossAmount,
    required this.deliveryCharges,
    required this.paymentMode,
    required this.deliveryStatus,
    required this.deliveryTime,
    required this.itemCode,
    required this.quantity,
    required this.totalAmount,
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
      orderId: json['OrderId'],
      orderDate: json['OrderDate'],
      customerId: json['CustomerId'],
      grossAmount: json['GrossAmount'],
      deliveryCharges: json['DeliveryCharges'],
      paymentMode: json['PaymentMode'],
      deliveryStatus: json['DeliveryStatus'],
      deliveryTime: json['DeliveryTime'],
      itemCode: json['ItemCode'],
      quantity: json['Quantity'],
      totalAmount: json['TotalAmount'],
      productMainImageUrl: json['ProductMainImageUrl'],
      productName: json['ProductName'],
      customerName: json['CustomerName'],
      customerMobile: json['CustomerMobile'],
      customerPinCode: json['CustomerPinCode'],
      customerAddressType: json['CustomerAddressType'],
      customerAddress: json['CustomerAddress'],
    );
  }
}
