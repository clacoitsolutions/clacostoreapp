
import 'package:flutter/material.dart';
import '../Page/contact_us.dart';
import 'contact.dart';

class HelpCenter extends StatefulWidget {
  @override
  _HelpCenterState createState() => _HelpCenterState();
}

class _HelpCenterState extends State{






  bool showFirstContainer = false;
  bool showSecondContainer = false;
  bool showThirdContainer = false;
  bool showFourthContainer = false;
  void toggleFirstContainer() {
    setState(() {
      showFirstContainer = !showFirstContainer;
    });
  }

  void toggleSecondContainer() {
    setState(() {
      showSecondContainer = !showSecondContainer;
    });
  }

  void toggleThirdContainer() {
    setState(() {
      showThirdContainer = !showThirdContainer;
    });
  }
  void toggleFourthContainer() {
    setState(() {
      showFourthContainer = !showFourthContainer;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Add your search functionality here
            },
          ),
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  // Add your cart functionality here
                },
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    '3', // Replace this with your actual count
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 140.0,
              margin: EdgeInsets.only(top: 10.0),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ContactFormPage();
                            },
                          ).then((_) {
                            // This code will be executed when the dialog is dismissed
                            // You can add any necessary logic here
                          });
                        },


                      child: Container(
                        padding: EdgeInsets.only(left: 10.0, top: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Get quick customer support by selecting your items',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Contact Us',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 16.0,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 120, // Adjust width for image part
                    child: Image.asset(
                      'assets/images/helpimg.png', // Provide the path to your image asset
                    ),
                  ),
                ],
              ),
            ),

            Container(
              height: 470.0,
              margin: EdgeInsets.only(top: 10.0),
              color: Colors.white,
              child: Column(
                children: [
                  Container(
                    height: 100.0,
                    margin: EdgeInsets.symmetric(vertical: 5.0,horizontal: 10),
                    // Adjust color as needed
                    child: Center(
                      child: Text(
                        'Select the order to track and manage it conveniently',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5.0,horizontal: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Colors.black12,
                            width: 1.0,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 90.0,
                            height: 80.0,
                            margin: EdgeInsets.only(top: 10.0), // Add margin to the top
                            color: Colors.white,
                            child: Image.asset(
                              'assets/images/sliderimg3.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),


                          Expanded(
                            child: Container(
                              color: Colors.white,
                              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Top',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.circle,
                                        color: Colors.green,
                                        size: 15.0,
                                      ),
                                      SizedBox(width: 10.0),
                                      Text(
                                        'Delivery On 10 May 2024',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(

                            color: Colors.white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    // Add button functionality here
                                  },
                                  child: Icon(
                                    Icons.arrow_forward_ios_outlined,
                                    color: Colors.black,
                                    size: 15.0,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    shape: CircleBorder(),
                                    padding: EdgeInsets.all(5.0), // Adjust padding as needed
                                    minimumSize: Size(30.0, 30.0), // Adjust minimum size as needed
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5.0,horizontal: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Colors.black12,
                            width: 1.0,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 90.0,
                            height: 80.0,
                            margin: EdgeInsets.only(top: 10.0), // Add margin to the top
                            color: Colors.white,
                            child: Image.asset(
                              'assets/images/sliderimg3.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),


                          Expanded(
                            child: Container(
                              color: Colors.white,
                              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Top',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.circle,
                                        color: Colors.green,
                                        size: 15.0,
                                      ),
                                      SizedBox(width: 10.0),
                                      Text(
                                        'Delivery On 10 May 2024',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            color: Colors.white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    // Add button functionality here
                                  },
                                  child: Icon(
                                    Icons.arrow_forward_ios_outlined,
                                    color: Colors.black,
                                    size: 15.0,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    shape: CircleBorder(),
                                    padding: EdgeInsets.all(5.0), // Adjust padding as needed
                                    minimumSize: Size(30.0, 30.0), // Adjust minimum size as needed
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5.0,horizontal: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Colors.black12,
                            width: 1.0,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 90.0,
                            height: 80.0,
                            margin: EdgeInsets.only(top: 10.0), // Add margin to the top
                            color: Colors.white,
                            child: Image.asset(
                              'assets/images/sliderimg3.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),


                          Expanded(
                            child: Container(
                              color: Colors.white,
                              padding: EdgeInsets.symmetric( vertical: 5.0,horizontal: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Top',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.circle,
                                        color: Colors.green,
                                        size: 15.0,
                                      ),
                                      SizedBox(width: 10.0),
                                      Text(
                                        'Delivery On 10 May 2024',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(

                            color: Colors.white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    // Add button functionality here
                                  },
                                  child: Icon(
                                    Icons.arrow_forward_ios_outlined,
                                    color: Colors.black,
                                    size: 15.0,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    shape: CircleBorder(),
                                    padding: EdgeInsets.all(5.0), // Adjust padding as needed
                                    minimumSize: Size(30.0, 30.0), // Adjust minimum size as needed
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Container(
                    height: 50.0,
                    margin: EdgeInsets.only(left: 15.0),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: Colors.black12, // Adjust border color as needed
                          width: 1.0, // Adjust border width as needed
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'View more',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Add button functionality here
                          },
                          child: Icon(
                            Icons.arrow_forward_ios_outlined,
                            color: Colors.black,
                            size: 15.0, // Adjust icon size as needed
                          ),

                        ),
                      ],
                    ),
                  ),


                ],
              ),
            ),
            Container(

              margin: EdgeInsets.only(top: 10.0),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 8.0, top: 8.0),
                    child: Text(
                      'What issues are you facing?', // Heading text
                      style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  SizedBox(height: 10.0), // Spacer between heading and issues list
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.black12,
                              width: 1.0,
                            ),
                          ),
                        ),
                        child: Column(

                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0,bottom: 10.0,top: 10.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'I want to manage my order',
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          'View, cancel, or return an order',
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: TextButton(
                                    onPressed: () {
                                      toggleFirstContainer(); // Toggle the state of the first container
                                    },
                                    child: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Colors.black,
                                      size: 24.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // Render the first container if showFirstContainer is true
                            if (showFirstContainer)
                              Container(
                                height: 150,

                                child: Align(
                                  alignment: Alignment.centerLeft,


                                  child: Text(
                                    "Sure! To manage your order, you can log in to your account on our website and navigate to the 'My Orders' section. From there, you'll be able to view your order history, track current orders, make changes to pending orders (if applicable), and contact our customer support team if you need further assistance. If you encounter any issues or have specific questions about your order, feel free to reach out to us directly, and we'll be happy to help!",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
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
                            bottom: BorderSide(
                              color: Colors.black12,
                              width: 1.0,
                            ),
                          ),
                        ),
                        child: Column(

                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0,top: 10.0,bottom: 10.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'I want help with return & refunds',
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          'Manage and track return',
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: TextButton(
                                    onPressed: () {
                                      toggleSecondContainer(); // Toggle the state of the second container
                                    },
                                    child: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Colors.black,
                                      size: 24.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // Render the second container if showSecondContainer is true
                            if (showSecondContainer)
                              Container(
                                height: 150,

                                child: Center(
                                  child: Text(
                                    "Absolutely! For managing returns and refunds, head to our website and access the 'Returns & Refunds' section. There, you can initiate a return or request a refund hassle-free. To track and manage your return, log in to your account and navigate to the same section to monitor its progress. Need assistance? Contact our support team anytime!",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
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
                            bottom: BorderSide(
                              color: Colors.black12,
                              width: 1.0,
                            ),
                          ),
                        ),
                        child: Column(

                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0,top: 10.0,bottom: 10.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'I want help with other issues',
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          'Other,payment& all other issues',
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: TextButton(
                                    onPressed: () {
                                      toggleThirdContainer(); // Toggle the state of the third container
                                    },
                                    child: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Colors.black,
                                      size: 24.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // Render the third container if showThirdContainer is true
                            if (showThirdContainer)
                              Container(
                                height: 150,

                                child: Center(
                                  child: Text(
                                    "1. If you need help with other issues, feel free to reach out to us! Our customer support team is here to assist you with any queries or concerns you may have.\n\n2. For inquiries about payments or any other issues, don't hesitate to contact us! We're available to help you resolve any concerns you might encounter",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
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
                            bottom: BorderSide(
                              color: Colors.black12,
                              width: 1.0,
                            ),
                          ),
                        ),
                        child: Column(

                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0,top: 10.0,bottom: 10.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'I want to contact the seller',
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: TextButton(
                                    onPressed: () {
                                      toggleFourthContainer(); // Toggle the state of the third container
                                    },
                                    child: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Colors.black,
                                      size: 24.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // Render the third container if showThirdContainer is true
                            if (showFourthContainer)
                              Container(
                                height: 150,

                                child: Center(
                                  child: Text(
                                    "To contact the seller, simply click on the 'Contact Seller' button on the product page. From there, you can send them a message directly regarding any questions or concerns you may have about the product or your order. If you need further assistance, feel free to reach out to our customer support team, and we'll be happy to help facilitate communication with the seller.",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
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

            Container(
              margin: EdgeInsets.only(top:10.0),
              height: 50.0,
              color: Colors.white,
              child: Container(
                decoration: BoxDecoration(

                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0,top: 10,bottom: 10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Browser Help Topics', // First issue
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Icon(
                        Icons.arrow_forward_ios_outlined, // Icon to represent the issue
                        color: Colors.black,
                        size: 20.0,
                      ),
                    ),
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
// Define functions to toggle the state of each container
