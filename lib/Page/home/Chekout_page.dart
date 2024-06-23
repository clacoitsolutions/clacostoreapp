import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Api services/Add_address_api.dart';
import '../../Api services/Checkout_Api.dart';
import '../../pageUtills/common_appbar.dart';
import '../addressscreen.dart';

class Checkout extends StatelessWidget {
  const Checkout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: 'Checkout',
      ),
      body: MyCart(),
    );
  }
}

class MyCart extends StatefulWidget {
  @override
  _MyCartState createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
  int _counter = 1;
  bool _isSelected1 = false;
  bool _isSelected2 = false;
  String _Srno = '';
  String _name = '';
  String _address = '';
  String _pinCode = '';
  String _mobileNo = '';
  String _state = '';
  String _city = '';
  List<dynamic> _cartItems = [];
  double totalSalePrice = 0.0;
  double totalGSTAmount = 0.0;
  double deliveryCharge = 0.0; // Delivery charge variable
  String paymentMethod = ''; // Payment method variable
  String _customerId = ''; // CustomerId as global variable
  String _addressId = ''; // SrNo (address ID) as global variable

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    await _fetchAddressData();
    await _fetchCartItems();
    await _fetchTotalAmounts();
  }

  Future<void> _fetchAddressData() async {
    final addressData = await CartApiService.fetchAddressData("CUST000394");
    if (addressData != null) {
      setState(() {
        _Srno = addressData['SrNo'];
        _name = addressData['Name'];
        _address = addressData['Address'];
        _pinCode = addressData['PinCode'];
        _mobileNo = addressData['MobileNo'];
        _state = addressData['State_name'];
        _city = addressData['CityName'];
      });

      // Store CustomerId and SrNo in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('CustomerId', 'CUST000394');
      await prefs.setString('SrNo', addressData['SrNo']);

      // Update global variables
      _customerId = 'CUST000394';
      _addressId = addressData['SrNo'];
    }
  }

  Future<void> _fetchCartItems() async {
    try {
      final cartItems = await CartApiService.fetchCartItems('CUST000394');
      setState(() {
        _cartItems = cartItems;
      });
    } catch (e) {
      print('Error fetching cart items: $e');
      // Handle error
    }
  }

  Future<void> _fetchTotalAmounts() async {
    try {
      final jsonData = await TotalAmountApiService.fetchTotalAmount('CUST000394');

      if (jsonData != null &&
          jsonData['addresses'] != null &&
          jsonData['addresses'].isNotEmpty &&
          jsonData['addresses'][0]['TotalSalePrice'] != null &&
          jsonData['addresses'][0]['TotalGSTAmount'] != null) {
        setState(() {
          totalSalePrice = jsonData['addresses'][0]['TotalSalePrice'];
          totalGSTAmount = jsonData['addresses'][0]['TotalGSTAmount'];

          // Add delivery charge if totalSalePrice is less than 100
          deliveryCharge = totalSalePrice < 100 ? 40.0 : 0.0;
        });

        // Store TotalSalePrice and TotalGSTAmount in SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setDouble('TotalSalePrice', totalSalePrice);
        await prefs.setDouble('TotalGSTAmount', totalGSTAmount);
      } else {
        print('Invalid data format received');
      }
    } catch (e) {
      print('Error fetching total amounts: $e');
    }
  }

  void _handlePayment() async {
    // Ensure customerId and addressId are not null
    if (_customerId.isEmpty || _addressId.isEmpty) {
      print('Customer ID or Address ID is empty');
      return;
    }

    final grossAmount = totalSalePrice;
    final netPayable = totalSalePrice + deliveryCharge;
    final GSTAmount = totalGSTAmount;

    // Debug statements to check the values
    print('Customer ID: $_customerId');
    print('Address ID: $_addressId');
    print('Gross Amount: $grossAmount');
    print('Net Payable: $netPayable');
    print('GST Amount: $GSTAmount');
    print('Payment Method: $paymentMethod');

    // Construct the API request body
    Map<String, dynamic> requestBody = {
      "customerid": _customerId,
      "grossamount": grossAmount,
      "deliverycharges": deliveryCharge,
      "iscoupenapplied": true,
      "coupenamount": null,
      "discountamount": null,
      "deliveryaddressid": _addressId,
      "paymentmode": paymentMethod,
      "paymentstatus": "Paid",
      "NetPayable": netPayable,
      "GSTAmount": GSTAmount
    };

    // Convert the request body to JSON
    String jsonBody = json.encode(requestBody);

    // Make API call using http package
    try {
      final response = await http.post(
        Uri.parse('https://clacostoreapi.onrender.com/postOnlineOrder1'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonBody,
      );

      if (response.statusCode == 200) {
        // Handle success scenario
        print('Order placed successfully');
        // Navigate to success page or show success message
      } else {
        // Handle error scenario
        print('Failed to place order. Status code: ${response.statusCode}');
        // Show error message to user
      }
    } catch (e) {
      // Handle network or unexpected errors
      print('Error: $e');
      // Show error message to user
    }
  }

  void _toggleSelection(int boxNumber) {
    setState(() {
      if (boxNumber == 1) {
        _isSelected1 = true;
        _isSelected2 = false;
        paymentMethod = 'Cash on Delivery';
      } else {
        _isSelected1 = false;
        _isSelected2 = true;
        paymentMethod = 'Online Payment';
      }
    });
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      if (_counter > 1) _counter--;
    });
  }

  bool get _isContinueButtonEnabled => _isSelected1 || _isSelected2;

  Widget _buildCartItems() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _cartItems.length,
      itemBuilder: (context, index) {
        return Container(
          height: 100,
          margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 4,
              ),
            ],
          ),
          child: Row(
            children: [
              // Image Container (20% width)
              Expanded(
                flex: 3,
                child: Container(
                  height: 80,
                  margin: EdgeInsets.all(8),
                  child: Image.network(
                    _cartItems[index]['ProductMainImageUrl'],
                    fit: BoxFit.cover,
                    height: 60,
                  ),
                ),
              ),
              // Text Container (80% width)
              Expanded(
                flex: 7,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _cartItems[index]['ProductName'],
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black.withOpacity(0.6),
                        ),
                      ),
                      SizedBox(height: 25,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '₹ ${_cartItems[index]['OnlinePrice'].toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 14,
                              color:
                              Colors.pink,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: _decrementCounter,
                                padding: EdgeInsets.all(0),
                                constraints: BoxConstraints(),
                                splashRadius: 20,
                                iconSize: 24,
                                icon: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 3),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey, width: 0.2),
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  child: Icon(Icons.remove, color: Colors.grey),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey, width: 0.2),
                                  borderRadius: BorderRadius.circular(0),
                                  color: Color(0xFFF5F4F4FF),
                                ),
                                child: Text(
                                  '$_counter',
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: _incrementCounter,
                                padding: EdgeInsets.all(0),
                                constraints: BoxConstraints(),
                                splashRadius: 20,
                                iconSize: 24,
                                icon: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 3),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey, width: 0.2),
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  child: Icon(Icons.add, color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummarySection() {
    return Container(
        height: 170,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 4,
            ),
          ],
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
            SizedBox(height: 12),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Items (${_cartItems.length})', style: TextStyle(color: Colors.grey)),
              Text('...'),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Shipping', style: TextStyle(color: Colors.grey)),
              Text('$totalGSTAmount'),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Delivery charge', style: TextStyle(color: Colors.grey)),
              Text('₹ ${deliveryCharge.toStringAsFixed(2)}'),
            ],
          ),
        ),
        Divider(thickness: 1, color: Colors.grey.withOpacity(0.5)),
        Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
    child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
    Text(                'Total Amount',
      style: TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
    ),
      Text(
        '₹ ${(totalSalePrice + deliveryCharge).toStringAsFixed(2)}',
        style: TextStyle(
          color: Colors.pink,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
    ],
    ),
        ),
          ],
        ),
    );
  }

  Widget _buildPaymentSelection() {
    return Container(
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ListTile(
            title: Text('Cash on Delivery'),
            trailing: _isSelected1
                ? Icon(Icons.check_circle, color: Colors.pink)
                : Icon(Icons.radio_button_unchecked),
            onTap: () => _toggleSelection(1),
          ),
          ListTile(
            title: Text('Other'),
            trailing: _isSelected2
                ? Icon(Icons.check_circle, color: Colors.pink)
                : Icon(Icons.radio_button_unchecked),
            onTap: () => _toggleSelection(2),
          ),
        ],
      ),
    );
  }





  Widget _buildContinueButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isContinueButtonEnabled ? _handlePayment : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: _isContinueButtonEnabled ? Colors.pink : Colors.grey,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        child: Text(
          'Continue',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }


  Widget _buildAddressCard() {
    return Container(
      height: 130,
      width: double.infinity,
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Deliver to:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to address selection screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddAddressPage()),
                  );
                },
                child: Text(
                  'Change',
                  style: TextStyle(
                    color: Colors.pink,
                    fontWeight: FontWeight.w600,
                    fontSize: 17,
                  ),
                ),
              ),
            ],
          ),
          Text(
            _name,
            style: TextStyle(fontSize: 16),
          ),
          Text(
            '$_address, $_city, $_state - $_pinCode',
            style: TextStyle(fontSize: 15),
          ),
          Text(
            'Phone: $_mobileNo',
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildAddressCard(),
            SizedBox(height: 16),
            _buildCartItems(),
            SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      'Coupons',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.local_offer,color: Colors.pink,),
                    title: TextField(
                      decoration: InputDecoration(
                        hintText: 'Enter coupon code',
                        border: InputBorder.none,
                      ),
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {
                        // Handle apply coupon button press
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink.withOpacity(0.9) ,
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: Text('Apply',style: TextStyle(color: Colors.white),),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            _buildSummarySection(),
            SizedBox(height: 16),
            _buildPaymentSelection(),
            SizedBox(height: 16),
            _buildContinueButton(),
          ],
        ),
      ),
    );
  }
}


