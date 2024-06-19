import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;



class MyyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyyHomePage> {
  List<dynamic> apiData = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('https://clacostoreapi.onrender.com/Bindmain'));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      setState(() {
        apiData = jsonData['data'];
      });
    } else {
      print('Error: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('API Integration'),
      ),
      body: apiData.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: apiData.length,
        itemBuilder: (context, index) {
          final item = apiData[index];
          return Card(
            child: ListTile(
              leading: Image.network(item['CatImg']),
              title: Text('SrNo: ${item['SrNo']}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ProductCategory: ${item['ProductCategory']}'),
                  Text('Count: ${item['cnt']}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}