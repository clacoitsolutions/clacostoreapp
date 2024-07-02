class Coupon {
  int assignmentId;
  String customerId;
  String couponCode;
  String couponName;
  String image;
  DateTime startDate;
  DateTime endDate;
  String startingPrice;
  String endingPrice;
  String discount;
  DateTime assignmentDate;
  bool isActive;

  Coupon({
    required this.assignmentId,
    required this.customerId,
    required this.couponCode,
    required this.couponName,
    required this.image,
    required this.startDate,
    required this.endDate,
    required this.startingPrice,
    required this.endingPrice,
    required this.discount,
    required this.assignmentDate,
    required this.isActive,
  });

  factory Coupon.fromJson(Map<String, dynamic> json) {
    return Coupon(
      assignmentId: json['AssignmentId'],
      customerId: json['CustomerId'],
      couponCode: json['CoupanCode'],
      couponName: json['CoupanName'],
      image: json['Image'],
      startDate: DateTime.parse(json['StartDate']),
      endDate: DateTime.parse(json['EndDate']),
      startingPrice: json['startingPrice'],
      endingPrice: json['EndingPrice'],
      discount: json['Discount'],
      assignmentDate: DateTime.parse(json['AssignmentDate']),
      isActive: json['IsActive'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'AssignmentId': assignmentId,
      'CustomerId': customerId,
      'CoupanCode': couponCode,
      'CoupanName': couponName,
      'Image': image,
      'StartDate': startDate.toIso8601String(),
      'EndDate': endDate.toIso8601String(),
      'startingPrice': startingPrice,
      'EndingPrice': endingPrice,
      'Discount': discount,
      'AssignmentDate': assignmentDate.toIso8601String(),
      'IsActive': isActive,
    };
  }
}
