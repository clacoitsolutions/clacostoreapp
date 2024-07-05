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
  // final String offerType;
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
    // required this.offerType,
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
      // 'OfferType': offerType,
      'Latitude': latitude,
      'Longitude': longitude,
      'Address2': address2,
    };
  }
}

//
// address_model.dart
class ShowAddress {
  final String srNo;
  final String customerCode;
  final String name;
  final String mobileNo;
  final String pinCode;
  final String address;
  final String cityName;
  final String stateId;
  final String locality;
  final String landmark;
  final String latitude;
  final String longitude;
  final String address2;

  ShowAddress({
    required this.srNo,
    required this.customerCode,
    required this.name,
    required this.mobileNo,
    required this.pinCode,
    required this.address,
    required this.cityName,
    required this.stateId,
    required this.locality,
    required this.landmark,
    required this.latitude,
    required this.longitude,
    required this.address2,
  });

  factory ShowAddress.fromJson(Map<String, dynamic> json) {
    return ShowAddress(
      srNo: json['SrNo'] ?? '',
      customerCode: json['CustomerCode'] ?? '',
      name: json['Name'] ?? '',
      mobileNo: json['MobileNo'] ?? '',
      pinCode: json['PinCode'] ?? '',
      address: json['Address'] ?? '',
      cityName: json['CityName'] ?? '',
      stateId: json['StateId'] ?? '',
      locality: json['Locality'] ?? '',
      landmark: json['LandMark'] ?? '',
      latitude: json['latitude'] ?? '',
      longitude: json['longitude'] ?? '',
      address2: json['address2'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'SrNo': srNo,
      'CustomerCode': customerCode,
      'Name': name,
      'MobileNo': mobileNo,
      'PinCode': pinCode,
      'Address': address,
      'CityName': cityName,
      'StateId': stateId,
      'Locality': locality,
      'LandMark': landmark,
      'latitude': latitude,
      'longitude': longitude,
      'address2': address2,
    };
  }
}

// class ShowAddress {
//   final String? customerCode;
//   final String? name;
//   final String? mobileNo;
//   final String? pinCode;
//   final String? locality;
//   final String? address;
//   final String? stateId;
//   final String? cityName;
//   final String? srNo;
//   final String? landMark;
//   final String? latitude;
//   final String? longitude;
//   final String? address2;
//
//   ShowAddress({
//     this.customerCode,
//     this.name,
//     this.mobileNo,
//     this.pinCode,
//     this.locality,
//     this.address,
//     this.stateId,
//     this.cityName,
//     this.srNo,
//     this.landMark,
//     this.latitude,
//     this.longitude,
//     this.address2,
//   });
//
//   factory ShowAddress.fromJson(Map<String, dynamic> json) {
//     return ShowAddress(
//       customerCode: json['customerCode'] as String?,
//       name: json['name'] as String?,
//       mobileNo: json['mobileNo'] as String?,
//       pinCode: json['pinCode'] as String?,
//       locality: json['locality'] as String?,
//       address: json['address'] as String?,
//       stateId: json['stateId'] as String?,
//       cityName: json['cityName'] as String?,
//       srNo: json['srNo'] as String?,
//       landMark: json['landMark'] as String?,
//       latitude: json['latitude'] as String?,
//       longitude: json['longitude'] as String?,
//       address2: json['address2'] as String?,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'customerCode': customerCode,
//       'name': name,
//       'mobileNo': mobileNo,
//       'pinCode': pinCode,
//       'locality': locality,
//       'address': address,
//       'stateId': stateId,
//       'cityName': cityName,
//       'srNo': srNo,
//       'landMark': landMark,
//       'latitude': latitude,
//       'longitude': longitude,
//       'address2': address2,
//     };
//   }
// }
