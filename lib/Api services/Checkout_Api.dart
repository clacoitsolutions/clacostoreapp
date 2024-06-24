import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String _baseUrl = 'https://clacostoreapi.onrender.com';

  static Future<Map<String, dynamic>> fetchAddressData(String customerId) async {
    final url = Uri.parse('$_baseUrl/address');
    final response = await http.post(
      url,
      body: jsonEncode({'CustomerId': customerId}),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      return responseData['data'];
    } else {
      throw Exception('Failed to load address data');
    }
  }


}


class CartApiService {
  static const String baseUrl = 'https://clacostoreapi.onrender.com';

  static Future<List<dynamic>> fetchCartItems(String customerId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/addToCart'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'CustomerId': customerId,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['data'];
    } else {
      throw Exception('Failed to load cart items');
    }
  }
  static Future<Map<String, dynamic>?> fetchAddressData(String customerId) async {
    final url = '$baseUrl/defaultaddress';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"CustomerId": customerId}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'][0];
    } else {
      print('Failed to load address data');
      return null;
    }
  }

}

class TotalAmountApiService {
  static Future<Map<String, dynamic>?> fetchTotalAmount(String customerCode) async {
    try {
      final response = await http.post(
        Uri.parse('https://clacostoreapi.onrender.com/getTotalNetAmmount'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'customerCode': customerCode,
        }),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return jsonData;
      } else {
        print('Failed to fetch total amounts: ${response.statusCode}');
        return null; // or handle the error as needed
      }
    } catch (e) {
      print('Error fetching total amounts: $e');
      return null; // or handle the error as needed
    }
  }
}





class OrderApiService {
  static Future<Map<String, dynamic>> postOnlineOrder(
      String customerId,
      double grossAmount,
      double deliveryCharges,
      bool isCoupenApplied,
      String? coupenAmount,
      String? discountAmount,
      String deliveryAddressId,
      String paymentMode,
      String paymentStatus,
      double netPayable,
      double gstAmount,
      ) async {
    final String apiUrl = 'https://clacostoreapi.onrender.com/postOnlineOrder1';

    // Construct the API request body
    Map<String, dynamic> requestBody = {
      "customerid": customerId,
      "grossamount": grossAmount,
      "deliverycharges": deliveryCharges,
      "iscoupenapplied": isCoupenApplied,
      "coupenamount": coupenAmount,
      "discountamount": discountAmount,
      "deliveryaddressid": deliveryAddressId,
      "paymentmode": paymentMode,
      "paymentstatus": paymentStatus,
      "NetPayable": netPayable,
      "GSTAmount": gstAmount,
    };

    // Convert the request body to JSON
    String jsonBody = json.encode(requestBody);

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonBody,
      );

      if (response.statusCode == 200) {
        // Decode the JSON response
        return json.decode(response.body);
      } else {
        // Decode the JSON response to extract the error message
        return {
          'status': response.statusCode,
          'message': json.decode(response.body)['message'] ?? 'Failed to place order',
        };
      }
    } catch (e) {
      // Handle network or unexpected errors
      return {
        'status': 'error',
        'message': e.toString(),
      };
    }
  }
}

