import 'package:flutter/material.dart';

class Order_Summary  extends StatefulWidget {
  @override
  _Order_Summary createState() => _Order_Summary();
}

class _Order_Summary extends State<Order_Summary> {
  int _counter = 0;
  String selectedText = ''; // Track the selected text

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.withOpacity(0.08), // Set the background color to light blue with opacity
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            const Text(
              'Order Summary',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ],
        ),

      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 1), // Padding goes here
        child: Column(
          children: <Widget>[
            Container(
              height: 70,
              width: double.infinity, // Make the box take full width
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2), // Shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 4, // Blur radius
                    offset: Offset(0, 3), // Offset
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 16.0),
                        child: Text(
                          'Deliver to :',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Text(
                        ' Varanasi - 221005', // Add your additional text here
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black,
                        ),
                      ),
                      // Add more Text widgets as needed
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle button press
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.white), // Set background color to white
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2), // Set border radius to 2
                            side: BorderSide(color: Colors.grey.withOpacity(0.3)), // Set border color to grey
                          ),
                        ),
                      ),
                      child: Text('Change'),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 8), // Add space between the white box and the text widget
            Container(
              height: 210,
              width: double.infinity,
              decoration: BoxDecoration(
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    flex: 8,
                    child: Row(
                      children: [
                        // Image Container (20% width)
                        Expanded(
                          flex: 3,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 20, top: 18, right: 20),
                                child: Container(
                                  height: 100,
                                  width: double.infinity,
                                  child: Center(
                                    child: Image.network(
                                      'https://cdn.pixabay.com/photo/2024/02/24/15/01/ai-generated-8594209_640.jpg',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              Column(
                                children: [
                                  DropdownButton<int>(
                                    value: 1,
                                    onChanged: (int? value) {
                                      if (value != null) {
                                        print('Selected quantity: $value');
                                      }
                                    },
                                    items: const [
                                      DropdownMenuItem<int>(
                                        value: 1,
                                        child: Text('Qty: 1'),
                                      ),
                                      DropdownMenuItem<int>(
                                        value: 2,
                                        child: Text('2'),
                                      ),
                                      DropdownMenuItem<int>(
                                        value: 3,
                                        child: Text('3'),
                                      ),
                                      DropdownMenuItem<int>(
                                        value: 4,
                                        child: Text('4'),
                                      ),
                                      DropdownMenuItem<int>(
                                        value: 5,
                                        child: Text('5'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Text Container (80% width)
                        Expanded(
                          flex: 7,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10, top: 18),
                            child: Container(
                              height: double.infinity,
                              width: double.infinity,
                              color: Colors.white,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Nike Air Jordan Retro 1 Low Mystic Black',
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black.withOpacity(0.6)
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  const Row(
                                    children: [
                                      Text(
                                        'Size : 8,',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        'White',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 6),
                                  const Row(
                                    children: [
                                      Icon(Icons.star, color: Colors.green, size: 18),
                                      Icon(Icons.star, color: Colors.green, size: 18),
                                      Icon(Icons.star, color: Colors.green, size: 18),
                                      Icon(Icons.star, color: Colors.green, size: 18),
                                      Icon(
                                        Icons.star_half,
                                        color: Colors.grey,
                                        size: 18,
                                      ),
                                      Text(
                                        " (55,999)",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 6),
                                  const Row(
                                    children: [
                                      Text(
                                        '50% off',
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Text(
                                        '₹2999',
                                        style: TextStyle(
                                          decoration: TextDecoration.lineThrough,
                                          fontSize: 18,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Text(
                                        '₹1500',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  const Row(
                                    children: [
                                      Text(
                                        'Applied',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.green,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'offer .',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.green,
                                        ),
                                      ),
                                      SizedBox(width: 3),
                                      Text(
                                        '1 offer available',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0), // Add left padding
                      child: Row(
                        children: [
                          Text(
                            "Delivery by",
                            style: TextStyle(
                              color: Colors.black87.withOpacity(0.7), // Set text color to grey
                              fontSize: 13, // Set font size to 15
                            ),
                          ),
                          Text(
                            " Today",
                            style: TextStyle(
                              color: Colors.black87.withOpacity(0.7), // Set text color to grey
                              fontSize: 13, // Set font size to 15
                            ),
                          ),
                          const Text(
                            "  Free",
                            style: TextStyle(
                              color: Colors.green, // Set text color to grey
                              fontSize: 13, // Set font size to 15
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                ],
              ),
            ),
            SizedBox(height: 8),

            Container(
              height: 230,
              width: double.infinity,
              decoration: BoxDecoration(
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
                  const Padding(
                    padding: EdgeInsets.only(left: 16.0, top: 15.0),
                    child: Text(
                      'Price Details',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, top: 20.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Row(
                            children: [
                              Text(
                                "Price",
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.9),
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(width: 5), // Adding some space between texts
                              Text(
                                "(1 items)",
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.9),
                                  fontSize: 14,
                                ),
                              ),
                              // SizedBox(width: 5), // Adding some space between texts
                              // Text(
                              //   "Additional Info",
                              //   style: TextStyle(
                              //     color: Colors.black.withOpacity(0.9),
                              //     fontSize: 14,
                              //   ),
                              // ),
                            ],
                          ),
                        ),

                        Expanded(
                          flex: 1,
                          child: Row(
                            children: [
                              // Text(
                              //   "₹",
                              //   style: TextStyle(
                              //     color: Colors.black.withOpacity(0.9),
                              //     fontSize: 14,
                              //   ),
                              // ),
                              SizedBox(width: 84), // Adding some space between texts
                              Text(
                                "₹ 2999",
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.9),
                                  fontSize: 14,
                                ),
                              ),

                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, top: 10.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Row(
                            children: [
                              Text(
                                "Discount",
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.9),
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(width: 5), // Adding some space between texts

                            ],
                          ),
                        ),

                        const Expanded(
                          flex: 1,
                          child: Row(
                            children: [

                              SizedBox(width: 80), // Adding some space between texts
                              Text(
                                "- ₹2199",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 14,
                                ),
                              ),

                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, top: 10.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Row(
                            children: [
                              Text(
                                "Coupons for you",
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.9),
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(width: 5), // Adding some space between texts

                            ],
                          ),
                        ),

                        const Expanded(
                          flex: 1,
                          child: Row(
                            children: [

                              SizedBox(width: 80), // Adding some space between texts
                              Text(
                                "    ₹0",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),

                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, top: 10.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Row(
                            children: [
                              Text(
                                "Delivery Charges ",
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.9),
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(width: 5), // Adding some space between texts

                            ],
                          ),
                        ),

                        const Expanded(
                          flex: 1,
                          child: Row(
                            children: [

                              SizedBox(width: 82), // Adding some space between texts
                              Text(
                                '₹80',
                                style: TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                '  Free',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, top: 20.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Row(
                            children: [
                              Text(
                                "Total Amount",
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.9),
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(width: 5), // Adding some space between texts

                            ],
                          ),
                        ),

                        const Expanded(
                          flex: 1,
                          child: Row(
                            children: [

                              SizedBox(width: 82), // Adding some space between texts
                              Text(
                                " ₹800",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                              // Text(
                              //   " Free",
                              //   style: TextStyle(
                              //     color: Colors.green,
                              //     fontSize: 14,
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            ),
            SizedBox(height: 1),
            Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 16.0, top: 0),
                child: Container(
                  child: const Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Row(
                          children: [
                            Text(
                              "You will save ",
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              " ₹2199 on this order",
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(width: 5), // Adding some space between texts
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: 70,
              width: double.infinity,
              decoration: BoxDecoration(
                // color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 16.0, top: 0),
                child: Center(
                  child: Container(
                    child: const Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 30.0,top: 5), // Add left padding
                                child: Icon(
                                  Icons.verified_user,
                                  color: Colors.grey,
                                  size: 33,
                                ),
                              ),
                            ],
                          ),
                        ),


                        Expanded(
                          flex: 4,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 15.0), // Add space at the top
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "100% Authentic products.",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    SizedBox(width: 5), // Adding space between icon and text
                                    Text(
                                      "Safe and secure payments. Easy returns.",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            ),



            SizedBox(height: 1),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 60,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 16.0, top: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "4,000",
                              style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 0),
                              child: Text(
                                "2,000",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 16.0),
                        child: ElevatedButton(
                          onPressed: () {
                            // Add your button functionality here
                          },
                          style: ButtonStyle(
                            backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.pink),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                          child: const Text(
                            "Continue",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 1), // Add minimum space below the row


          ],
        ),
      ),
    );

  }
}
