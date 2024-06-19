import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/Add_address_model.dart';

class APIService {
  static const baseUrl = 'https://clacostoreapi.onrender.com';

  static Future<List<Map<String, String>>> fetchStates() async {
    final response = await http.get(Uri.parse('$baseUrl/getState'));
    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body);
      List<Map<String, String>> states = [];
      for (var state in parsed['states']) {
        states.add({
          'State_id': state['State_id'].toString(),
          'State_name': state['State_name'],
        });
      }
      return states;
    } else {
      throw Exception('Failed to fetch states');
    }
  }

  static Future<List<Map<String, String>>> fetchCities(int stateId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/getCity'));

      if (response.statusCode == 200) {
        final List<dynamic> citiesData = jsonDecode(response.body)['cities'];
        List<Map<String, String>> cities = citiesData
            .where((city) =>
        city['StateId'] == stateId && city['IsActive'] == true)
            .map<Map<String, String>>((city) {
          return {
            'City_id': city['ID'].toString(),
            'City_name': city['CityName'],
          };
        })
            .toList();
        return cities;
      } else {
        throw Exception('Failed to load cities: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load cities: $e');
    }
  }


  static Future<http.Response> insertAddress(Address address) async {
    final response = await http.post(
      Uri.parse('$baseUrl/insertAddress'),
      body: jsonEncode(address.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
    return response;
  }


}
Future<List<ShowAddress>> fetchAddresses() async {
  final response = await http.post(
    Uri.parse('https://clacostoreapi.onrender.com/displayAddress'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'CustomerCode': 'CUST000394',
    }),
  );

  if (response.statusCode == 200) {
    final jsonResponse = jsonDecode(response.body);
    final List<dynamic> data = jsonResponse['data'];
    return data.map((json) => ShowAddress.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load addresses');
  }
}



class ApiService {
  static const String _baseUrl = 'https://clacostoreapi.onrender.com';

  static Future<Map<String, dynamic>?> fetchAddressData(String customerId) async {
    final url = '$_baseUrl/defaultaddress';
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

