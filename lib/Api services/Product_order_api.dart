// api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<dynamic>> fetchOrderItems(String customerId) async {
  final response = await http.post(
    Uri.parse('https://clacostoreapi.onrender.com/getorderitems'),
    body: jsonEncode({'CustomerId': customerId}),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> data = jsonDecode(response.body);
    return data['orderItems'];
  } else {
    throw Exception('Failed to load order items');
  }
}


Future<List<dynamic>> fetchOrderItem(String customerId) async {
  final String apiUrl = 'https://clacostoreapi.onrender.com/clickorderitems';
  final response = await http.post(Uri.parse(apiUrl), body: {'customerId': customerId});

  if (response.statusCode == 200) {
    return jsonDecode(response.body)['orderItems'];
  } else {
    throw Exception('Failed to load order items');
  }
}

Future<Map<String, dynamic>> fetchOrderDetails(String orderId) async {
  final String apiUrl = 'https://clacostoreapi.onrender.com/clickorderdetails';
  final response = await http.post(Uri.parse(apiUrl), body: {'orderId': orderId});

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load order details');
  }
}