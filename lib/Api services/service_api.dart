import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/slider_model.dart'; // Import the models class once

const String apiUrl = 'https://clacostoreapi.onrender.com'; // URL variable

Future<List<Banner>> fetchBanners() async {
  final response = await http.get(Uri.parse('$apiUrl/getBanner')); // Using the URL variable
  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    List<Banner> banners = [];
    for (var item in data) {
      banners.add(Banner.fromJson(item)); // Use the models class directly
    }
    return banners;
  } else {
    throw Exception('Failed to load banner data');
  }
}









// Future<void> registerUser({
//   required String name,
//   required String phoneNumber,
//   required String referralCode,
//   required String email,
//   required String password,
// }) async {
//   final url = Uri.parse('$apiUrl/getregister');
//   try {
//     final response = await http.post(
//       url,
//       body: {
//         'name': name,
//         'mobileno': phoneNumber,
//         'UsedReferal': referralCode,
//         'EmailId': email,
//         'Password': password,
//         'Action': '1',
//       },
//     );
//     if (response.statusCode == 200) {
//       // Handle success
//       print('Registration successful');
//     } else {
//       // Handle other status codes
//       print('Registration failed');
//     }
//   } catch (error) {
//     // Handle errors
//     print('Error: $error');
//   }
// }