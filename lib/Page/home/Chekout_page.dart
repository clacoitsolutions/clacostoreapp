import 'package:claco_store/Page/OrderSuccesful_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Api services/Add_address_api.dart';
import '../../Api services/Checkout_Api.dart';
import '../../pageUtills/common_appbar.dart';
import '../addressscreen.dart';
import '../paymentgateway.dart';
import 'order_sucees_summery.dart';

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
  List<dynamic> coupons = [];
  String? appliedCouponOffer;
  double? offerCoupon; // Store the discount percentage
  dynamic selectedCoupon;
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
  double deliveryCharge = 0.0;
  String paymentMethod = '';
  String _customerId = '';
  String _addressId = '';
  String? userName;
  String? userEmail;
  String? mobileNo;

  @override
  void initState() {
    super.initState();
    _fetchAddressData();
    _fetchCartItems();
    _fetchTotalAmounts();
    fetchCoupons();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('name');
      userEmail = prefs.getString('emailAddress');
      mobileNo = prefs.getString('mobileNo');
      _customerId = prefs.getString('CustomerId') ?? '';
    });
  }

  void _handlePayment() async {
    if (paymentMethod == 'Online') {
      // Navigate to RazorpayPaymentScreen and pass necessary data
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RazorpayPaymentScreen(),
        ),
      );
    } else if (paymentMethod == 'Cash on Delivery') {
      _placeCodOrder();
    }
  }

  Future<void> _placeCodOrder() async {
    if (_customerId.isEmpty || _addressId.isEmpty) {
      print('Customer ID or Address ID is empty');
      return;
    }

    final grossAmount = totalSalePrice;
    final payableAmount = totalSalePrice + deliveryCharge;
    final netPayable =
        payableAmount * (1 - (offerCoupon ?? 0.0) / 100); // Apply discount
    final GSTAmount = totalGSTAmount;

    Map<String, dynamic> requestBody = {
      "customerid": _customerId,
      "grossamount": grossAmount,
      "deliverycharges": deliveryCharge,
      "iscoupenapplied": offerCoupon != null,
      "coupenamount": offerCoupon != null ? offerCoupon : null,
      "discountamount": null,
      "deliveryaddressid": _addressId,
      "paymentmode": paymentMethod,
      "paymentstatus": "Pending", // Assuming COD orders start as pending
      "NetPayable": netPayable,
      "GSTAmount": GSTAmount
    };

    try {
      final response = await http.post(
        Uri.parse('https://clacostoreapi.onrender.com/postOnlineOrder1'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = json.decode(response.body);
        String message = responseBody['message'] ?? 'Order placed successfully';
        print('Order placed successfully: $message');

        // Navigate to OrderSummaryScreen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderSuccessful(),
          ),
        );
      } else {
        Map<String, dynamic> responseBody = json.decode(response.body);
        String errorMessage =
            responseBody['message'] ?? 'Failed to place order';
        print(
            'Failed to place order. Status code: ${response.statusCode}. Message: $errorMessage');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _fetchAddressData() async {
    final prefs = await SharedPreferences.getInstance();
    _customerId = prefs.getString('CustomerId') ?? '';
    final addressData = await CartApiService.fetchAddressData(_customerId);
    if (addressData != null) {
      setState(() {
        _Srno = addressData['SrNo'];
        _name = addressData['Name'];
        _address = addressData['Address'];
        _pinCode = addressData['PinCode'];
        _mobileNo = addressData['MobileNo'];
        _state = addressData['State_name'];
        _city = addressData['CityName'];
        _addressId = addressData['SrNo'];
      });
    }
  }

  Future<void> _fetchCartItems() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _customerId = prefs.getString('CustomerId') ?? '';
      final cartItems = await CartApiService.fetchCartItems(_customerId);
      setState(() {
        _cartItems = cartItems;
      });
    } catch (e) {
      print('Error fetching cart items: $e');
    }
  }

  Future<void> _fetchTotalAmounts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _customerId = prefs.getString('CustomerId') ?? '';
      final jsonData =
          await TotalAmountApiService.fetchTotalAmount(_customerId);

      if (jsonData != null &&
          jsonData['addresses'] != null &&
          jsonData['addresses'].isNotEmpty &&
          jsonData['addresses'][0]['TotalSalePrice'] != null &&
          jsonData['addresses'][0]['TotalGSTAmount'] != null) {
        setState(() {
          totalSalePrice = jsonData['addresses'][0]['TotalSalePrice'];
          totalGSTAmount = jsonData['addresses'][0]['TotalGSTAmount'];
          deliveryCharge = totalSalePrice < 100 ? 40.0 : 0.0;
        });
      } else {
        print('Invalid data format received');
      }
    } catch (e) {
      print('Error fetching total amounts: $e');
    }
  }

  Future<void> _updateCartSize(
      String customerId, String productId, int quantity) async {
    try {
      final response = await http.post(
        Uri.parse('https://clacostoreapi.onrender.com/updatecartsize1'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode({
          "customerid": customerId,
          "productid": productId,
          "quantity": quantity.toString(),
        }),
      );

      if (response.statusCode == 200) {
        print('Cart size updated successfully');
        setState(() {
          final index =
              _cartItems.indexWhere((item) => item['ProductID'] == productId);
          if (index != -1) {
            _cartItems[index]['Quantity'] = quantity;
          }
        });
        _fetchTotalAmounts();
      } else {
        print(
            'Failed to update cart size. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating cart size: $e');
    }
  }

  Future<void> fetchCoupons() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _customerId = prefs.getString('CustomerId') ?? '';
      final response = await http.post(
        Uri.parse('https://clacostoreapi.onrender.com/assigncoupan'),
        body: jsonEncode({
          'CustomerId': _customerId,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        var jsonResponse = json.decode(response.body);
        setState(() {
          coupons = jsonResponse['data'];
        });
      } else {
        throw Exception('Failed to load coupons: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching coupons: $e');
    }
  }

  Future<void> redeemCoupon(String couponCode) async {
    try {
      final response = await http.post(
        Uri.parse('https://clacostoreapi.onrender.com/redeem-coupon'),
        body: jsonEncode({
          'CoupanCode': couponCode,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        var jsonResponse = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(jsonResponse['message'])),
        );
      } else {
        throw Exception('Failed to redeem coupon: ${response.statusCode}');
      }
    } catch (e) {
      print('Error redeeming coupon: $e');
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
        paymentMethod = 'Online';
      }
    });
  }

  void _incrementCounter(String productId, int currentQuantity) {
    setState(() {
      int newQuantity = currentQuantity + 1;
      _updateCartSize(_customerId, productId, newQuantity);
    });
  }

  void _decrementCounter(String productId, int currentQuantity) {
    if (currentQuantity > 1) {
      setState(() {
        int newQuantity = currentQuantity - 1;
        _updateCartSize(_customerId, productId, newQuantity);
      });
    }
  }

  Future<void> _saveTotalAmount(double totalAmount) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('totalAmount', totalAmount);
  }

  bool get _isContinueButtonEnabled => _isSelected1 || _isSelected2;

  Widget _buildCartItems() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _cartItems.length,
      itemBuilder: (context, index) {
        final productId = _cartItems[index]['ProductID'];
        final currentQuantity = _cartItems[index]['Quantity'];

        return Container(
          height: 140,
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
                      SizedBox(
                        height: 25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '₹ ${_cartItems[index]['OnlinePrice'].toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.pink,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () => _decrementCounter(
                                    productId, currentQuantity),
                                padding: EdgeInsets.all(0),
                                constraints: BoxConstraints(),
                                splashRadius: 20,
                                iconSize: 24,
                                icon: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 3),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey, width: 0.2),
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  child: Icon(Icons.remove, color: Colors.grey),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey, width: 0.2),
                                  borderRadius: BorderRadius.circular(0),
                                  color: Color(0xFFF5F4F4FF),
                                ),
                                child: Text(
                                  currentQuantity.toString(),
                                  style: const TextStyle(
                                    fontSize: 17,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () => _incrementCounter(
                                    productId, currentQuantity),
                                padding: EdgeInsets.all(0),
                                constraints: BoxConstraints(),
                                splashRadius: 20,
                                iconSize: 24,
                                icon: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 3),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey, width: 0.2),
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
    final double totalAmount = totalSalePrice + deliveryCharge;

    // Save the total amount to SharedPreferences
    _saveTotalAmount(totalAmount);
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
                Text('Items (${_cartItems.length})',
                    style: TextStyle(color: Colors.grey)),
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
                Text(
                  'Total Amount',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '₹ ${totalAmount.toStringAsFixed(2)}',
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
      height: 130,
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
      height: 150,
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

  Widget couponCard(dynamic coupon) {
    return Container(
      margin: EdgeInsets.all(2),
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
      child: Container(
        height: 120.0,
        child: Row(
          children: <Widget>[
            Container(
              width: 100.0,
              height: 100.0,
              padding: EdgeInsets.all(5.0),
              child: Center(
                child: Image.network(
                  '${coupon['Image']}',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 5),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '${coupon['Discount']}% off',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      coupon['CoupanName'],
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Min-Max: ₹${coupon['startingPrice']} -  ₹${coupon['EndingPrice']}',
                      style: TextStyle(
                        fontSize: 9.0,
                        color: Colors.green.shade900,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '${coupon['StartDate'].substring(0, 7)} - ${coupon['EndDate'].substring(0, 7)}',
                      style: TextStyle(
                        fontSize: 9.0,
                        color: Colors.red.shade900,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(right: 7),
              child: ElevatedButton(
                onPressed: () {
                  // When the "Apply Coupon" button is pressed
                  redeemCoupon(coupon['CoupanCode']);
                  setState(() {
                    offerCoupon = double.tryParse(coupon['Discount']) ??
                        0.0; // Store the discount value
                    selectedCoupon =
                        coupon; // Update the selected coupon in the UI
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: Text(
                  'Apply Coupon',
                  style: TextStyle(
                    fontSize: 9.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
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
              color: Colors.lightBlue.withOpacity(0.01),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(0.0),
                    child: Material(
                      elevation: 4,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: Text(
                                'Coupons',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            ListTile(
                              leading:
                                  Icon(Icons.local_offer, color: Colors.pink),
                              title: DropdownButton<dynamic>(
                                value: selectedCoupon,
                                hint: Text('Select coupon'),
                                onChanged: (dynamic newValue) {
                                  setState(() {
                                    selectedCoupon = newValue;
                                    // You can update the offerCoupon here as well if needed
                                  });
                                },
                                items: coupons.map<DropdownMenuItem<dynamic>>(
                                    (dynamic coupon) {
                                  return DropdownMenuItem<dynamic>(
                                    value: coupon,
                                    child: Text(
                                        '${coupon['CoupanName']} - ${coupon['Discount']}% off'),
                                  );
                                }).toList(),
                                isExpanded: true,
                                underline: SizedBox(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (selectedCoupon != null)
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: couponCard(selectedCoupon),
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
