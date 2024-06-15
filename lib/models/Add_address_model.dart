class Address {
  final String customerCode;
  final String name;
  final String mobileNo;
  final String pinCode;
  final String locality;
  final String address;
  final String stateId;
  final String cityId;
  final String landmark;
  final String alternativeMobileNo;
  final String offerType;
  final String latitude;
  final String longitude;
  final String address2;

  Address({
    required this.customerCode,
    required this.name,
    required this.mobileNo,
    required this.pinCode,
    required this.locality,
    required this.address,
    required this.stateId,
    required this.cityId,
    required this.landmark,
    required this.alternativeMobileNo,
    required this.offerType,
    required this.latitude,
    required this.longitude,
    required this.address2,
  });

  Map<String, dynamic> toJson() {
    return {
      'CustomerCode': customerCode,
      'Name': name,
      'MobileNo': mobileNo,
      'PinCode': pinCode,
      'Locality': locality,
      'Address': address,
      'StateId': stateId,
      'CityId': cityId,
      'Landmark': landmark,
      'AlternativeMobileNo': alternativeMobileNo,
      'OfferType': offerType,
      'Latitude': latitude,
      'Longitude': longitude,
      'Address2': address2,
    };
  }
}


// address_model.dart
class ShowAddress {
  final String name;
  final String mobileNo;
  final String pinCode;
  final String address;
  final String cityName;
  final String stateId;
  final String landMark;
  final bool isDefaultAccount;

  ShowAddress({
    required this.name,
    required this.mobileNo,
    required this.pinCode,
    required this.address,
    required this.cityName,
    required this.stateId,
    required this.landMark,
    required this.isDefaultAccount,
  });

  factory ShowAddress.fromJson(Map<String, dynamic> json) {
    return ShowAddress(
      name: json['Name'],
      mobileNo: json['MobileNo'],
      pinCode: json['PinCode'],
      address: json['Address'],
      cityName: json['CityName'],
      stateId: json['StateId'],
      landMark: json['LandMark'],
      isDefaultAccount: json['IsDefaultAccount'],
    );
  }
}
