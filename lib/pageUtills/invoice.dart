import 'package:flutter/material.dart';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class InvoicePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Remove back arrow button
        title: null,
        // Remove the title "Invoice"
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Text(
                  'Invoice Download',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
              ],
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: Container(
                height: 800,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1.0),
                ),
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Tax Invoice/Bill of Supply',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(width: 1.0, color: Colors.black),
                          bottom: BorderSide(width: 1.0, color: Colors.black),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 100,
                              width: 80,
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Claco',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 35,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              height: 100,
                              width: 130,
                              child: Column(
                                children: [
                                  Text(
                                    'Lucknow, Uttar Pradesh, 226022',
                                    style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Contact us: +91 - xxxxx',
                                    style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Mail us at',
                                    style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'GSTIN:',
                                    style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(width: 1.0, color: Colors.black),
                          bottom: BorderSide(width: 1.0, color: Colors.black),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(width: 7,),
                          Expanded(
                            child: Container(
                              height: 100,
                              width: 130,
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Order Number:-ORD101000292',
                                    style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Order Date: 16-Apr-2024 5:38PM',
                                    style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Mode :COD',
                                    style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 7,),
                          Expanded(
                            child: Container(
                              height: 100,
                              width: 130,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Name:Shailja Tiwari',
                                    style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Address : Ambedkarnagr',
                                    style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Mobile No. :6387706960',
                                    style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'GSTIN:',
                                    style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 30,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                  top: BorderSide(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                  bottom: BorderSide(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                              child: Text(
                                'S.N.',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                  top: BorderSide(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                  bottom: BorderSide(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                              child: Text(
                                'Items Name',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                  top: BorderSide(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                  bottom: BorderSide(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                              child: Text(
                                'Qty',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                  top: BorderSide(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                  bottom: BorderSide(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                              child: Text(
                                'MRP',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                  top: BorderSide(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                  bottom: BorderSide(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                              child: Text(
                                'Rate',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                  top: BorderSide(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                  bottom: BorderSide(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                              child: Text(
                                '',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                  top: BorderSide(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                  bottom: BorderSide(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                              child: Text(
                                'CGST',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                  top: BorderSide(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                  bottom: BorderSide(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                              child: Text(
                                'SGST',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                  top: BorderSide(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                  bottom: BorderSide(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                              child: Text(
                                'AMT',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(width: 1.0, color: Colors.black),
                          bottom: BorderSide(width: 1.0, color: Colors.black),
                        ),
                      ),

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              alignment: Alignment.center,
                              height: 30,
                              width: 50,
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                ),
                              ),

                            ),

                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              height: 30,
                              width: 60,
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                ),
                              ),

                            ),

                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              height: 30,
                              width: 40,
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                ),
                              ),

                            ),

                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              height: 30,
                              width: 40,
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                ),
                              ),

                            ),

                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              height: 30,
                              width: 40,
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                ),
                              ),

                            ),

                          ),

                          Expanded(
                            flex: 2,
                            child: Container(
                              height: 30,
                              width: 40,
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                ),
                              ),

                            ),

                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              alignment: Alignment.center,
                              height: 30,
                              width: 40,
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                              child: Text(
                                'Rate %',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                          ),

                          Expanded(
                            flex:2,
                            child: Container(
                              alignment: Alignment.center,
                              height: 30,
                              width: 130,
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                              child: Text(
                                'Amount',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              alignment: Alignment.center,
                              height: 30,
                              width: 130,
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                              child: Text(
                                'Rate%',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              alignment: Alignment.center,
                              height: 30,
                              width: 130,
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                              child: Text(
                                'AMT',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(width: 1.0, color: Colors.black),
                          bottom: BorderSide(width: 1.0, color: Colors.black),
                        ),
                      ),

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              alignment: Alignment.center,
                              height: 30,
                              width: 50,
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                              child: Text(
                                '1',
                                style: TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              alignment: Alignment.center,
                              height: 30,
                              width: 60,
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                              child: Text(
                                'Mens T-shirt',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              alignment: Alignment.center,
                              height: 30,
                              width: 40,
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                              child: Text(
                                '2',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              alignment: Alignment.center,
                              height: 30,
                              width: 40,
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                              child: Text(
                                '400.00',
                                style: TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              alignment: Alignment.center,
                              height: 30,
                              width: 40,
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                              child: Text(
                                '313.96',
                                style: TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                          ),

                          Expanded(
                            flex: 1,
                            child: Container(
                              height: 30,
                              width: 40,
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                ),
                              ),

                            ),

                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              alignment: Alignment.center,
                              height: 30,
                              width: 40,
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                              child: Text(
                                '2.5',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              alignment: Alignment.center,
                              height: 30,
                              width: 40,
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                              child: Text(
                                '14.95',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                          ),

                          Expanded(
                            flex:2,
                            child: Container(
                              alignment: Alignment.center,
                              height: 30,
                              width: 130,
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                              child: Text(
                                '2.5',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              alignment: Alignment.center,
                              height: 30,
                              width: 130,
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                              child: Text(
                                '14.95',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              alignment: Alignment.center,
                              height: 30,
                              width: 130,
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                              child: Text(
                                '657.82',
                                style: TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(width: 1.0, color: Colors.black),
                          bottom: BorderSide(width: 1.0, color: Colors.black),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Container(
                              height: 30,
                              width: 40,
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Total MRP',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              height: 30,
                              width: 130,
                              child: Column(
                                children: [
                                  Text('800.00')
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(width: 1.0, color: Colors.black),
                          bottom: BorderSide(width: 1.0, color: Colors.black),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Container(
                              height: 30,
                              width: 40,
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Discount',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              height: 30,
                              width: 130,
                              child: Column(
                                children: [
                                  Text('172.08')
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(width: 1.0, color: Colors.black),
                          bottom: BorderSide(width: 1.0, color: Colors.black),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Container(
                              height: 30,
                              width: 40,
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Sale Price',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              height: 30,
                              width: 130,
                              child: Column(
                                children: [
                                  Text('627.92')
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(width: 1.0, color: Colors.black),
                          bottom: BorderSide(width: 1.0, color: Colors.black),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Container(
                              height: 30,
                              width: 40,
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Gst Charge',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              height: 30,
                              width: 130,
                              child: Column(
                                children: [
                                  Text('29.90')
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(width: 1.0, color: Colors.black),
                          bottom: BorderSide(width: 1.0, color: Colors.black),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Container(
                              height: 30,
                              width: 40,
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Delivery Charge',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              height: 30,
                              width: 130,
                              child: Column(
                                children: [
                                  Text('0.00')
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(width: 1.0, color: Colors.black),
                          bottom: BorderSide(width: 1.0, color: Colors.black),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Container(
                              height: 30,
                              width: 40,
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'PromoCode',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              height: 30,
                              width: 130,
                              child: Column(
                                children: [
                                  Text('00.00')
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(width: 1.0, color: Colors.black),
                          bottom: BorderSide(width: 1.0, color: Colors.black),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              height: 30,
                              width: 40,
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Payable Amount',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Container(
                              height: 30,
                              width: 130,
                              child: Column(
                                children: [
                                  Text('1257.00')
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(width: 1.0, color: Colors.black),

                        ),
                      ),

                      child: Row(
                        children: [
                          SizedBox(width: 7,),
                          SizedBox(height: 10,),
                          Expanded(

                            child: Container(
                              height: 30,
                              width: 40,

                              child: Text(
                                'Amount(In Words)Rs. One thousand Two Hundred fifty Seven Only',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                    Divider(
                      thickness: 1, // Line ki motai
                      color: Colors.black, // Line ka rang
                    ),
                    SizedBox(height: 20,),
                    Container(

                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          SizedBox(width: 10,),
                          Expanded(
                            flex: 3,
                            child: Container(
                              height: 120,
                              width: 130,

                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Thaks For shopping with us',
                                    style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Visit again for more details',
                                    style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Terms & Conditions',
                                    style: TextStyle(fontSize: 12,),
                                  ),
                                  Text(
                                    'The goods sold as are Intended for end user consumption and  not for re-sale',
                                    style: TextStyle(fontSize: 12,),
                                  ),
                                  Text(
                                    'goods once sold will not be taken back or exchange',
                                    style: TextStyle(fontSize: 12,),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 120,
                              width: 130,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Authorized signature',
                                    style: TextStyle(fontSize: 9,fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      child: TextButton(
                        onPressed: () async {
                          // Create PDF content
                          final pdf = pw.Document();
                          pdf.addPage(pw.Page(
                            build: (pw.Context context) {
                              return pw.Center(
                                child: pw.Text('Hello World!'),
                              );
                            },
                          ));

                          try {
                            // Get temporary directory
                            final directory = await getTemporaryDirectory();
                            final path = directory.path;

                            // Save the PDF to disk
                            final file = File('D:/pdfdownload/example.pdf');
                            await file.writeAsBytes(await pdf.save());

                            // Show a snackbar with a message
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('PDF downloaded successfully'),
                              ),
                            );
                          } catch (e) {
                            print('Error while saving PDF: $e');
                            // Show a snackbar with an error message
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error downloading PDF'),
                              ),
                            );
                          }
                        },
                        child: Text('Download PDF'),
                      ),
                    )


                  ],
                ),
              ),


            ),
          ],
        ),
      ),
    );
  }
}
