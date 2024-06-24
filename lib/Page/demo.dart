import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Order App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: OrderPage(),
    );
  }
}

class OrderRequest {
  String customerid;
  double grossamount;
  double deliverycharges;
  bool iscoupenapplied;
  double coupenamount;
  double discountamount;
  String deliveryaddressid;
  String paymentmode;
  String paymentstatus;
  double netPayable;
  String stockiestId;
  double gstAmount;

  OrderRequest({
    required this.customerid,
    required this.grossamount,
    required this.deliverycharges,
    required this.iscoupenapplied,
    required this.coupenamount,
    required this.discountamount,
    required this.deliveryaddressid,
    required this.paymentmode,
    required this.paymentstatus,
    required this.netPayable,
    required this.stockiestId,
    required this.gstAmount,
  });

  Map<String, dynamic> toJson() {
    return {
      'customerid': customerid,
      'grossamount': grossamount,
      'deliverycharges': deliverycharges,
      'iscoupenapplied': iscoupenapplied,
      'coupenamount': coupenamount,
      'discountamount': discountamount,
      'deliveryaddressid': deliveryaddressid,
      'paymentmode': paymentmode,
      'paymentstatus': paymentstatus,
      'NetPayable': netPayable,
      'StockiestId': stockiestId,
      'GSTAmount': gstAmount,
    };
  }
}

class OrderResponse {
  String message;
  List<OrderItem> orderItems;

  OrderResponse({required this.message, required this.orderItems});

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    return OrderResponse(
      message: json['message'],
      orderItems: List<OrderItem>.from(json['orderItems'].map((item) => OrderItem.fromJson(item))),
    );
  }
}

class OrderItem {
  int id;
  String orderId;
  String name;
  String mobileNo;
  String emailAddress;
  double netPayable;

  OrderItem({
    required this.id,
    required this.orderId,
    required this.name,
    required this.mobileNo,
    required this.emailAddress,
    required this.netPayable,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      orderId: json['OrderId'],
      name: json['Name'],
      mobileNo: json['MobileNo'],
      emailAddress: json['EmailAddress'],
      netPayable: json['NetPayable'],
    );
  }
}

class ApiService {
  Future<OrderResponse> postOnlineOrder(OrderRequest orderRequest) async {
    final url = Uri.parse('https://clacostoreapi.onrender.com/postOnlineOrder1');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(orderRequest.toJson()),
    );

    if (response.statusCode == 200) {
      return OrderResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to post order');
    }
  }
}

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();

  final _customerIdController = TextEditingController(text: "CUST000394");
  final _grossAmountController = TextEditingController(text: "1000.0");
  final _deliveryChargesController = TextEditingController(text: "50.0");
  final _couponAppliedController = TextEditingController(text: "true");
  final _couponAmountController = TextEditingController(text: "100.0");
  final _discountAmountController = TextEditingController(text: "50.0");
  final _deliveryAddressIdController = TextEditingController(text: "79");
  final _paymentModeController = TextEditingController(text: "Cash");
  final _paymentStatusController = TextEditingController(text: "Paid");
  final _netPayableController = TextEditingController(text: "900.0");
  final _stockiestIdController = TextEditingController(text: "STOCK001");
  final _gstAmountController = TextEditingController(text: "50.0");

  bool _isLoading = false;

  void _placeOrder() async {
    setState(() {
      _isLoading = true;
    });

    OrderRequest orderRequest = OrderRequest(
      customerid: _customerIdController.text,
      grossamount: double.parse(_grossAmountController.text),
      deliverycharges: double.parse(_deliveryChargesController.text),
      iscoupenapplied: _couponAppliedController.text.toLowerCase() == 'true',
      coupenamount: double.parse(_couponAmountController.text),
      discountamount: double.parse(_discountAmountController.text),
      deliveryaddressid: _deliveryAddressIdController.text,
      paymentmode: _paymentModeController.text,
      paymentstatus: _paymentStatusController.text,
      netPayable: double.parse(_netPayableController.text),
      stockiestId: _stockiestIdController.text,
      gstAmount: double.parse(_gstAmountController.text),
    );

    try {
      OrderResponse orderResponse = await _apiService.postOnlineOrder(orderRequest);
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(orderResponse.message)),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to place order: ${e.toString()}')),
      );
    }
  }

  @override
  void dispose() {
    _customerIdController.dispose();
    _grossAmountController.dispose();
    _deliveryChargesController.dispose();
    _couponAppliedController.dispose();
    _couponAmountController.dispose();
    _discountAmountController.dispose();
    _deliveryAddressIdController.dispose();
    _paymentModeController.dispose();
    _paymentStatusController.dispose();
    _netPayableController.dispose();
    _stockiestIdController.dispose();
    _gstAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Place Order'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _customerIdController,
                decoration: InputDecoration(labelText: 'Customer ID'),
                readOnly: true,
              ),
              TextFormField(
                controller: _grossAmountController,
                decoration: InputDecoration(labelText: 'Gross Amount'),
                keyboardType: TextInputType.number,
                readOnly: true,
              ),
              TextFormField(
                controller: _deliveryChargesController,
                decoration: InputDecoration(labelText: 'Delivery Charges'),
                keyboardType: TextInputType.number,
                readOnly: true,
              ),
              TextFormField(
                controller: _couponAppliedController,
                decoration: InputDecoration(labelText: 'Coupon Applied (true/false)'),
                readOnly: true,
              ),
              TextFormField(
                controller: _couponAmountController,
                decoration: InputDecoration(labelText: 'Coupon Amount'),
                keyboardType: TextInputType.number,
                readOnly: true,
              ),
              TextFormField(
                controller: _discountAmountController,
                decoration: InputDecoration(labelText: 'Discount Amount'),
                keyboardType: TextInputType.number,
                readOnly: true,
              ),
              TextFormField(
                controller: _deliveryAddressIdController,
                decoration: InputDecoration(labelText: 'Delivery Address ID'),
                readOnly: true,
              ),
              TextFormField(
                controller: _paymentModeController,
                decoration: InputDecoration(labelText: 'Payment Mode'),
                readOnly: true,
              ),
              TextFormField(
                controller: _paymentStatusController,
                decoration: InputDecoration(labelText: 'Payment Status'),
                readOnly: true,
              ),
              TextFormField(
                controller: _netPayableController,
                decoration: InputDecoration(labelText: 'Net Payable'),
                keyboardType: TextInputType.number,
                readOnly: true,
              ),
              TextFormField(
                controller: _stockiestIdController,
                decoration: InputDecoration(labelText: 'Stockiest ID'),
                readOnly: true,
              ),
              TextFormField(
                controller: _gstAmountController,
                decoration: InputDecoration(labelText: 'GST Amount'),
                keyboardType: TextInputType.number,
                readOnly: true,
              ),
              SizedBox(height: 20),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: _placeOrder,
                child: Text('Place Order'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
