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
