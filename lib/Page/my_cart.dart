import 'package:flutter/material.dart';

import '../pageUtills/bottom_navbar.dart';
import '../pageUtills/common_appbar.dart';
import '../pageUtills/common_drawer.dart';
import '../pageUtills/top_navbar.dart';





class MycardScreen extends StatelessWidget {
  const MycardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: ' My Cart '), // Instantiate CommonAppBar directly
      body: mycart(),
      bottomNavigationBar: CustomBottomNavigationBar(context: context),
    );
  }
}


class mycart extends StatefulWidget {
  @override
  _mycart createState() => _mycart();
}

class _mycart extends State<mycart> {
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
        automaticallyImplyLeading: false,
        elevation: 0, // Remove elevation
        actions: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedText = 'Claco'; // Update the selected text
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: selectedText == 'Claco' ? Colors.red : Colors.transparent, // Change border color based on selection
                            width: 2, // Border thickness
                          ),
                        ),
                      ),
                      child: Text(
                        'Claco',
                        style: TextStyle(
                          color: selectedText == 'Claco' ? Colors.red : Colors.black, // Change text color based on selection
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedText = 'Grocery'; // Update the selected text
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: selectedText == 'Grocery' ? Colors.red : Colors.transparent, // Change border color based on selection
                            width: 2, // Border thickness
                          ),
                        ),
                      ),
                      child: Text(
                        'Grocery',
                        style: TextStyle(
                          color: selectedText == 'Grocery' ? Colors.red : Colors.black, // Change text color based on selection
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),


      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 1), // Padding goes here
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
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
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
              height: 250,
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
                                  Row(
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
                                  Row(
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
                                  Row(
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
                                  SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Text(
                                        'Applied',
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.green,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'offer',
                                        style: TextStyle(
                                          fontSize: 17,
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
                          Text(
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

                  SizedBox(height: 8),

                  Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              // Handle tap event
                            },
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click, // Change cursor to pointer on hover
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                    top: BorderSide(color: Colors.grey.withOpacity(0.2)),
                                    // left: BorderSide(color: Colors.grey.withOpacity(0.2)),
                                    // right: BorderSide(color: Colors.grey.withOpacity(0.2)),
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 6),
                                child: const Row( // Use Row to align the icon and text horizontally
                                  children: [
                                    Icon( // Add the icon before the text
                                      Icons.save_alt_sharp, // Choose the appropriate icon
                                      color: Colors.black45, // Set the icon color
                                      size: 18, // Set the icon size
                                    ),

                                    Text(
                                      ' Save for later',
                                      style: TextStyle(color: Colors.black45,fontWeight: FontWeight.bold,fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),


                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              // Handle tap event
                            },
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click, // Change cursor to pointer on hover
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                    top: BorderSide(color: Colors.grey.withOpacity(0.2)),
                                    left: BorderSide(color: Colors.grey.withOpacity(0.2)),
                                    right: BorderSide(color: Colors.grey.withOpacity(0.2)),
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                child: const Row( // Use Row to align the icon and text horizontally
                                  children: [
                                    Icon( // Add the icon before the text
                                      Icons.delete_outline_sharp, // Choose the appropriate icon
                                      color: Colors.black45, // Set the icon color
                                      size: 18, // Set the icon size
                                    ),
                                    SizedBox(width: 8), // Add some space between the icon and text
                                    Text(
                                      'Remove',
                                      style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold,fontSize: 13),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),


                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              // Handle tap event
                            },
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click, // Change cursor to pointer on hover
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                    top: BorderSide(color: Colors.grey.withOpacity(0.2)),
                                    // left: BorderSide(color: Colors.grey.withOpacity(0.2)),
                                    // right: BorderSide(color: Colors.grey.withOpacity(0.2)),
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                                child: const Row( // Use Row to align the icon and text horizontally
                                  children: [
                                    Icon( // Add the icon before the text
                                      Icons.shopping_cart_outlined, // Choose the appropriate icon
                                      color: Colors.black45, // Set the icon color
                                      size: 18, // Set the icon size
                                    ),
                                    Text(
                                        ' Buy this now',
                                        style: TextStyle(color: Colors.black45,fontWeight: FontWeight.bold,fontSize: 12)

                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),

                ],
              ),
            ),

            SizedBox(height: 8), // Add space between the white box and the text widget
            Container(
              height: 250,
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
                                  SizedBox(height: 12),
                                  const Row(
                                    children: [
                                      Text(
                                        'Applied',
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.green,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'offer',
                                        style: TextStyle(
                                          fontSize: 17,
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
                          Text(
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

                  SizedBox(height: 8),

                  Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              // Handle tap event
                            },
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click, // Change cursor to pointer on hover
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                    top: BorderSide(color: Colors.grey.withOpacity(0.2)),
                                    // left: BorderSide(color: Colors.grey.withOpacity(0.2)),
                                    // right: BorderSide(color: Colors.grey.withOpacity(0.2)),
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 6),
                                child: const Row( // Use Row to align the icon and text horizontally
                                  children: [
                                    Icon( // Add the icon before the text
                                      Icons.save_alt_sharp, // Choose the appropriate icon
                                      color: Colors.black45, // Set the icon color
                                      size: 18, // Set the icon size
                                    ),

                                    Text(
                                      ' Save for later',
                                      style: TextStyle(color: Colors.black45,fontWeight: FontWeight.bold,fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),


                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              // Handle tap event
                            },
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click, // Change cursor to pointer on hover
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                    top: BorderSide(color: Colors.grey.withOpacity(0.2)),
                                    left: BorderSide(color: Colors.grey.withOpacity(0.2)),
                                    right: BorderSide(color: Colors.grey.withOpacity(0.2)),
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                child: const Row( // Use Row to align the icon and text horizontally
                                  children: [
                                    Icon( // Add the icon before the text
                                      Icons.delete_outline_sharp, // Choose the appropriate icon
                                      color: Colors.black45, // Set the icon color
                                      size: 18, // Set the icon size
                                    ),
                                    SizedBox(width: 8), // Add some space between the icon and text
                                    Text(
                                      'Remove',
                                      style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold,fontSize: 13),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),


                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              // Handle tap event
                            },
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click, // Change cursor to pointer on hover
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                    top: BorderSide(color: Colors.grey.withOpacity(0.2)),
                                    // left: BorderSide(color: Colors.grey.withOpacity(0.2)),
                                    // right: BorderSide(color: Colors.grey.withOpacity(0.2)),
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                                child: const Row( // Use Row to align the icon and text horizontally
                                  children: [
                                    Icon( // Add the icon before the text
                                      Icons.shopping_cart_outlined, // Choose the appropriate icon
                                      color: Colors.black45, // Set the icon color
                                      size: 18, // Set the icon size
                                    ),
                                    Text(
                                        ' Buy this now',
                                        style: TextStyle(color: Colors.black45,fontWeight: FontWeight.bold,fontSize: 12)

                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),

                ],
              ),
            ),         SizedBox(height: 8), // Add space between the white box and the text widget
            Container(
              height: 300,
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
                                        color: Colors.black.withOpacity(0.6),
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Row(
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
                                  Row(
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
                                  Row(
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
                                  SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Text(
                                        'Applied',
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.green,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'offer',
                                        style: TextStyle(
                                          fontSize: 17,
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
                          Text(
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

                  SizedBox(height: 8),

                  Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              // Handle tap event
                            },
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click, // Change cursor to pointer on hover
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                    top: BorderSide(color: Colors.grey.withOpacity(0.2)),
                                    // left: BorderSide(color: Colors.grey.withOpacity(0.2)),
                                    // right: BorderSide(color: Colors.grey.withOpacity(0.2)),
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 6),
                                child: const Row( // Use Row to align the icon and text horizontally
                                  children: [
                                    Icon( // Add the icon before the text
                                      Icons.save_alt_sharp, // Choose the appropriate icon
                                      color: Colors.black45, // Set the icon color
                                      size: 18, // Set the icon size
                                    ),

                                    Text(
                                      ' Save for later',
                                      style: TextStyle(color: Colors.black45,fontWeight: FontWeight.bold,fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),


                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              // Handle tap event
                            },
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click, // Change cursor to pointer on hover
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                    top: BorderSide(color: Colors.grey.withOpacity(0.2)),
                                    left: BorderSide(color: Colors.grey.withOpacity(0.2)),
                                    right: BorderSide(color: Colors.grey.withOpacity(0.2)),
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                child: const Row( // Use Row to align the icon and text horizontally
                                  children: [
                                    Icon( // Add the icon before the text
                                      Icons.delete_outline_sharp, // Choose the appropriate icon
                                      color: Colors.black45, // Set the icon color
                                      size: 18, // Set the icon size
                                    ),
                                    SizedBox(width: 8), // Add some space between the icon and text
                                    Text(
                                      'Remove',
                                      style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold,fontSize: 13),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),


                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              // Handle tap event
                            },
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click, // Change cursor to pointer on hover
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                    top: BorderSide(color: Colors.grey.withOpacity(0.2)),
                                    // left: BorderSide(color: Colors.grey.withOpacity(0.2)),
                                    // right: BorderSide(color: Colors.grey.withOpacity(0.2)),
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                                child: const Row( // Use Row to align the icon and text horizontally
                                  children: [
                                    Icon( // Add the icon before the text
                                      Icons.shopping_cart_outlined, // Choose the appropriate icon
                                      color: Colors.black45, // Set the icon color
                                      size: 18, // Set the icon size
                                    ),
                                    Text(
                                        ' Buy this now',
                                        style: TextStyle(color: Colors.black45,fontWeight: FontWeight.bold,fontSize: 12)

                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),

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
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, top: 15.0),
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
                                "(6 items)",
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

                        Expanded(
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
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Row(
                          children: const [
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
            SizedBox(height: 1),
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
                  Padding(
                    padding: EdgeInsets.only(left: 16.0,top:8),
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
                          padding: EdgeInsets.only(top: 0), // Adjust the spacing between the texts
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
                      style: ButtonStyle( // Move the style property outside of the Text widget
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.pink), // Set background color to white
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2), // Set border radius to 2
                            // side: BorderSide(color: Colors.pink.withOpacity(0.3)), // Set border color to grey
                          ),
                        ),
                      ),
                      child: Text(
                        "Place Order",
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
            SizedBox(height: 10),
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
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Row(
                          children: const [
                            Text(
                              "Suggested for you ",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 1), // Add minimum space below the row
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 0), // Add padding horizontally
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Stack(
                          children: [
                            // Your existing code for the first item...
                            Container(
                              color: Colors.white, // Set background color to white
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      width: double.infinity,
                                      height: 200,
                                      child: Image.network(
                                        'https://cdn.pixabay.com/photo/2023/08/25/07/37/shoes-8212405_640.jpg',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Padding(
                                    padding: EdgeInsets.only(left: 10), // Adjust the left padding as needed
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Text(
                                        //   'Boys Shoes',
                                        //   style: TextStyle(
                                        //     fontSize: 16,
                                        //     fontWeight: FontWeight.bold,
                                        //   ),
                                        // ),
                                        SizedBox(height: 8),
                                        Text(
                                          'Nike Air Jordan Retro 1 Low Mystic Black',
                                          style: TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          '₹1500',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Icon(Icons.star, color: Colors.yellow, size: 15),
                                            Icon(Icons.star, color: Colors.yellow, size: 15),
                                            Icon(Icons.star, color: Colors.yellow, size: 15),
                                            Icon(Icons.star, color: Colors.yellow, size: 15),
                                            Icon(
                                              Icons.star_half,
                                              color: Colors.grey,
                                              size: 15,
                                            ),
                                            Text(
                                              "2,55,999",
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.grey,
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(height: 10), // Add spacing between the star rating and the button
                                        Padding(
                                          padding: EdgeInsets.only(right: 10), // Add padding only on the right side
                                          child: Container(
                                            width: double.infinity, // Make the button full width
                                            padding: EdgeInsets.symmetric(horizontal: 10), // Add horizontal padding
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey, // Border color
                                              ),
                                              borderRadius: BorderRadius.circular(2), // Border radius
                                            ),
                                            child: TextButton(
                                              onPressed: () {
                                                // Add your button logic here
                                              },
                                              child: Text(
                                                'Add to Cart',
                                                style: TextStyle(
                                                  color: Colors.blue, // Text color of the button
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10), // Add spacing between the star rating and the button

                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              top: 10,
                              right: 10,
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.favorite_outline,
                                    color: Colors.red, // Set the color of the icon to red
                                  ),
                                  onPressed: () {
                                    // Add your favorite button onPressed logic here
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        flex: 1,
                        child: Stack(
                          children: [
                            // Your existing code for the second item...
                            Container(
                              color: Colors.white, // Set background color to white
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      width: double.infinity,
                                      height: 200,
                                      child: Image.network(
                                        'https://cdn.pixabay.com/photo/2016/03/27/22/16/fashion-1284496_640.jpg',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Padding(
                                    padding: EdgeInsets.only(left: 10), // Adjust the left padding as needed
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 8),
                                        Text(
                                          'Nike Air Jordan Retro 1 Low Mystic Black',
                                          style: TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          '₹1500',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Icon(Icons.star, color: Colors.yellow, size: 15),
                                            Icon(Icons.star, color: Colors.yellow, size: 15),
                                            Icon(Icons.star, color: Colors.yellow, size: 15),
                                            Icon(Icons.star, color: Colors.yellow, size: 15),
                                            Icon(
                                              Icons.star_half,
                                              color: Colors.grey,
                                              size: 15,
                                            ),
                                            Text(
                                              "2,55,999",
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10), // Add spacing between the star rating and the button
                                        Padding(
                                          padding: EdgeInsets.only(right: 10), // Add padding only on the right side
                                          child: Container(
                                            width: double.infinity, // Make the button full width
                                            padding: EdgeInsets.symmetric(horizontal: 10), // Add horizontal padding
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey, // Border color
                                              ),
                                              borderRadius: BorderRadius.circular(2), // Border radius
                                            ),
                                            child: TextButton(
                                              onPressed: () {
                                                // Add your button logic here
                                              },
                                              child: Text(
                                                'Add to Cart',
                                                style: TextStyle(
                                                  color: Colors.blue, // Text color of the button
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10), // Add spacing between the star rating and the button


                                      ],
                                    ),
                                  ),

                                ],
                              ),
                            ),
                            Positioned(
                              top: 10,
                              right: 10,
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.favorite_outline,
                                    color: Colors.red, // Set the color of the icon to red
                                  ),
                                  onPressed: () {
                                    // Add your favorite button onPressed logic here
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Stack(
                          children: [
                            // Your existing code for the third item...
                            Container(
                              color: Colors.white, // Set background color to white
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      width: double.infinity,
                                      height: 200,
                                      child: Image.network(
                                        'https://cdn.pixabay.com/photo/2023/08/25/07/37/shoes-8212405_640.jpg',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Padding(
                                    padding: EdgeInsets.only(left: 10), // Adjust the left padding as needed
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Text(
                                        //   'Boys Shoes',
                                        //   style: TextStyle(
                                        //     fontSize: 16,
                                        //     fontWeight: FontWeight.bold,
                                        //   ),
                                        // ),
                                        SizedBox(height: 8),
                                        Text(
                                          'Nike Air Jordan Retro 1 Low Mystic Black',
                                          style: TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          '₹1500',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Icon(Icons.star, color: Colors.yellow, size: 15),
                                            Icon(Icons.star, color: Colors.yellow, size: 15),
                                            Icon(Icons.star, color: Colors.yellow, size: 15),
                                            Icon(Icons.star, color: Colors.yellow, size: 15),
                                            Icon(
                                              Icons.star_half,
                                              color: Colors.grey,
                                              size: 15,
                                            ),
                                            Text(
                                              "2,55,999",
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.grey,
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(height: 10), // Add spacing between the star rating and the button
                                        Padding(
                                          padding: EdgeInsets.only(right: 10), // Add padding only on the right side
                                          child: Container(
                                            width: double.infinity, // Make the button full width
                                            padding: EdgeInsets.symmetric(horizontal: 10), // Add horizontal padding
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey, // Border color
                                              ),
                                              borderRadius: BorderRadius.circular(2), // Border radius
                                            ),
                                            child: TextButton(
                                              onPressed: () {
                                                // Add your button logic here
                                              },
                                              child: Text(
                                                'Add to Cart',
                                                style: TextStyle(
                                                  color: Colors.blue, // Text color of the button
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10), // Add spacing between the star rating and the button

                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              top: 10,
                              right: 10,
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.favorite_outline,
                                    color: Colors.red, // Set the color of the icon to red
                                  ),
                                  onPressed: () {
                                    // Add your favorite button onPressed logic here
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        flex: 1,
                        child: Stack(
                          children: [
                            // Your existing code for the fourth item...
                            Container(
                              color: Colors.white, // Set background color to white
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      width: double.infinity,
                                      height: 200,
                                      child: Image.network(
                                        'https://cdn.pixabay.com/photo/2016/03/27/22/16/fashion-1284496_640.jpg',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Padding(
                                    padding: EdgeInsets.only(left: 10), // Adjust the left padding as needed
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 8),
                                        Text(
                                          'Nike Air Jordan Retro 1 Low Mystic Black',
                                          style: TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          '₹1500',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Icon(Icons.star, color: Colors.green, size: 15),
                                            Icon(Icons.star, color: Colors.green, size: 15),
                                            Icon(Icons.star, color: Colors.green, size: 15),
                                            Icon(Icons.star, color: Colors.green, size: 15),
                                            Icon(
                                              Icons.star_half,
                                              color: Colors.grey,
                                              size: 15,
                                            ),
                                            Text(
                                              "2,55,999",
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10), // Add spacing between the star rating and the button
                                        Padding(
                                          padding: EdgeInsets.only(right: 10), // Add padding only on the right side
                                          child: Container(
                                            width: double.infinity, // Make the button full width
                                            padding: EdgeInsets.symmetric(horizontal: 10), // Add horizontal padding
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey, // Border color
                                              ),
                                              borderRadius: BorderRadius.circular(2), // Border radius
                                            ),
                                            child: TextButton(
                                              onPressed: () {
                                                // Add your button logic here
                                              },
                                              child: Text(
                                                'Add to Cart',
                                                style: TextStyle(
                                                  color: Colors.blue, // Text color of the button
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10), // Add spacing between the star rating and the button


                                      ],
                                    ),
                                  ),

                                ],
                              ),
                            ),
                            Positioned(
                              top: 10,
                              right: 10,
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.favorite_outline,
                                    color: Colors.red, // Set the color of the icon to red
                                  ),
                                  onPressed: () {
                                    // Add your favorite button onPressed logic here
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),


          ],
        ),
      ),
    );

  }
}
