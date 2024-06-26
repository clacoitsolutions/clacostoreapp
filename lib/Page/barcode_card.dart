import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class BarCodecard extends StatefulWidget {
  final String name;
  final String mobile;
  final String customerId;

  BarCodecard({
    required this.name,
    required this.mobile,
    required this.customerId,
  });

  @override
  _BarcodeCardState createState() => _BarcodeCardState();
}

class _BarcodeCardState extends State<BarCodecard> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _customerIdController = TextEditingController();
  String _totalCoins = '';
  String? _selectedCoin; // Dropdown selection
  bool _isCoinAvailable = true; // Flag for coin availability

  final List<String> _coinOptions = [
    '5',
    '10',
    '30',
    '50',
    '100',
    '500',
  ];

  @override
  void initState() {
    super.initState();
    // Initialize controllers with received data
    _nameController.text = widget.name;
    _mobileController.text = widget.mobile;
    _customerIdController.text = widget.customerId;
    _fetchTotalCoins();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _customerIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4.0,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Customer Details',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  // Name field - make it read-only
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                    enabled: false, // Make it read-only
                  ),
                  SizedBox(height: 16.0),
                  // Mobile No. field - make it read-only
                  TextFormField(
                    controller: _mobileController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Mobile No.',
                      border: OutlineInputBorder(),
                    ),
                    enabled: false, // Make it read-only
                  ),
                  SizedBox(height: 16.0),
                  // Customer ID field - make it read-only
                  TextFormField(
                    controller: _customerIdController,
                    decoration: InputDecoration(
                      labelText: 'Customer ID',
                      border: OutlineInputBorder(),
                    ),
                    enabled: false, // Make it read-only
                  ),
                  SizedBox(height: 24.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5.0),
                          border:
                              Border.all(color: Colors.pinkAccent, width: 2.0),
                        ),
                        child: SizedBox(
                          height: 40,
                          width: 60,
                          child: DropdownButton<String>(
                            value: _selectedCoin,
                            hint: Text('Select Coin'),
                            items: _coinOptions.map((coin) {
                              return DropdownMenuItem<String>(
                                value: coin,
                                child: Text(coin),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedCoin = value!;
                                _isCoinAvailable = int.parse(_totalCoins) >=
                                    int.parse(_selectedCoin!);
                              });
                            },
                            isExpanded: true,
                          ),
                        ),
                      ),
                      Spacer(),
                      SizedBox(
                        height: 50,
                        width: 150,
                        child: ElevatedButton(
                          onPressed: _isCoinAvailable
                              ? () {
                                  if (_formKey.currentState!.validate() &&
                                      _selectedCoin != null) {
                                    _shareCoin();
                                  }
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isCoinAvailable
                                ? Colors.pinkAccent
                                : Colors.grey,
                            foregroundColor: Colors.white,
                          ),
                          child: Text(
                            _isCoinAvailable ? 'Share' : 'Not Available',
                            style: TextStyle(fontSize: 19),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (!_isCoinAvailable)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        'Insufficient coins!',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _fetchTotalCoins() async {
    try {
      final response = await http.post(
        Uri.parse('https://clacostoreapi.onrender.com/getSenderCoin'),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "CustomerID": "CUST000388", // Replace with sender's ID
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _totalCoins = data['data'][0]['TotalCoin'];
        });
      } else {
        throw Exception('Failed to fetch total coins');
      }
    } catch (e) {
      print('Error fetching coins: $e');
    }
  }

  Future<void> _shareCoin() async {
    try {
      final response = await http.post(
        Uri.parse('https://clacostoreapi.onrender.com/sharedcoin'),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "CustomerID": widget.customerId, // Receiver's ID
          "ReciverCustomerId": "CUST000473", // Replace with actual sender ID
          "SelectedValue": _selectedCoin, // Use the selected value
        }),
      );

      if (response.statusCode == 200) {
        print('Coin shared successfully');
        print(response.body);
        // Optionally show a success message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Coins shared successfully!')),
        );
      } else {
        throw Exception('Failed to share coin');
      }
    } catch (e) {
      print('Error sharing coin: $e');
      // Optionally show an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to share coins.')),
      );
    }
  }
}
