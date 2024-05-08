import 'package:flutter/material.dart';

import 'coupon_dilog_box.dart';
class coupons extends StatelessWidget {
  const coupons({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(
        title: Text('Coupons',style: TextStyle(color: Colors.white),),
          backgroundColor: Colors.pink,
          iconTheme: IconThemeData(color: Colors.white), // Set icon color to white
          actions: <Widget>[
    IconButton(
    icon: Icon(Icons.search),
    onPressed: () {
    // Implement search functionality
    },
    ),
    IconButton(
    icon: Icon(Icons.mic),
    onPressed: () {
    // Implement voice functionality
    },
    ),
    IconButton(
    icon: Icon(Icons.camera_alt),
    onPressed: () {
    // Implement camera functionality
    },
    ),
    Stack(
    children: <Widget>[
    IconButton(
    icon: Icon(Icons.shopping_cart),
    onPressed: () {
    // Navigate to cart screen
    },
    ),
    Positioned(
    right: 6,
    top: 6,
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
    '10', // Replace '10' with your actual item count
    style: TextStyle(
    color: Colors.white,
    fontSize: 10,
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

           // Adding margin around the container
            child: Container(
              color: Colors.grey.shade200, // Setting background color
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10.0), // Adding margin around the container
                    child: Material(
                      elevation: 4, // Elevation for the shadow
                      borderRadius: BorderRadius.circular(10), // Adding rounded corners to the container
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.pink.shade50,
                          borderRadius: BorderRadius.circular(10), // Adding rounded corners to the container
                        ),
                        child: Container(
                          margin: EdgeInsets.only(right: 10.0), // Adding margin on the right side of the row
                          height: 120.0, // Define the height of the row
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: 100.0, // Width of the container
                                height: 100.0, // Height of the container
                                padding: EdgeInsets.all(10.0), // Adding margin around the image
                                child: Center(
                                  child: Image.network(
                                    "https://png.pngtree.com/png-clipart/20221010/original/pngtree-diwali-sale-offer-mandala-design-png-image_8671236.png", // Replace this with your image URL
                                    fit: BoxFit.cover, // Adjust this according to your image requirement
                                  ),
                                ),
                              ),
                              SizedBox(width: 5), // Adding space between the two containers
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(16.0), // Adding padding inside the container
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10), // Adding rounded corners to the top right of the container
                                      bottomRight: Radius.circular(10), // Adding rounded corners to the bottom right of the container
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        'Get 20% off',
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'Coupons Name',
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'Sep 14 - Sep 20',
                                        style: TextStyle(
                                          fontSize: 10.0,
                                          color: Colors.red.shade900,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  // When the text is tapped, show the modal
                                  CouponDialog.show(context);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300], // Changing button color to light grey
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    'Apply Coupons',
                                    style: TextStyle(
                                      fontSize: 10.0,
                                      color: Colors.black, // Changing button text color to black
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),



                  SizedBox(height: 10.0), // Adding space between the two containers
                  Padding(
                    padding: EdgeInsets.all(10.0), // Adding margin around the container
                    child: Material(
                      elevation: 4, // Elevation for the shadow
                      borderRadius: BorderRadius.circular(10), // Adding rounded corners to the container
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(10), // Adding rounded corners to the container
                        ),
                        child: Container(
                          margin: EdgeInsets.only(right: 10.0), // Adding margin on the right side of the row
                          height: 120.0, // Define the height of the row
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: 100.0, // Width of the container
                                height: 100.0, // Height of the container
                                padding: EdgeInsets.all(10.0), // Adding margin around the image
                                child: Center(
                                  child: Image.network(
                                    'https://static.vecteezy.com/system/resources/previews/038/466/529/non_2x/happy-holi-sale-50-percent-off-for-discount-promotion-vector.jpg',
                                    fit: BoxFit.cover, // Adjust this according to your image requirement
                                  ),
                                ),
                              ),
                              SizedBox(width: 5), // Adding space between the two containers
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(16.0), // Adding padding inside the container
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10), // Adding rounded corners to the top right of the container
                                      bottomRight: Radius.circular(10), // Adding rounded corners to the bottom right of the container
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        'Get 20% off',
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'Coupons Name',
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'Sep 14 - Sep 20',
                                        style: TextStyle(
                                          fontSize: 10.0,
                                          color: Colors.red.shade900,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  // When the text is tapped, show the modal
                                  CouponDialog.show(context);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300], // Changing button color to light grey
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    'Apply Coupons',
                                    style: TextStyle(
                                      fontSize: 10.0,
                                      color: Colors.black, // Changing button text color to black
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),






                  SizedBox(height: 10.0), // Adding space between the two containers


                  Padding(
                    padding: EdgeInsets.all(10.0), // Adding margin around the container
                    child: Material(
                      elevation: 4, // Elevation for the shadow
                      borderRadius: BorderRadius.circular(10), // Adding rounded corners to the container
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(10), // Adding rounded corners to the container
                        ),
                        child: Container(
                          margin: EdgeInsets.only(right: 10.0), // Adding margin on the right side of the row
                          height: 120.0, // Define the height of the row
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: 100.0, // Width of the container
                                height: 100.0, // Height of the container
                                padding: EdgeInsets.all(10.0), // Adding margin around the image
                                child: Center(
                                  child: Image.network(
                                    'https://as1.ftcdn.net/v2/jpg/02/93/37/20/1000_F_293372088_13lABAVB5spxSOqSGFuJfIG9cdZAnctf.jpg', // Replace this with your image URL
                                    fit: BoxFit.cover, // Adjust this according to your image requirement
                                  ),
                                ),
                              ),
                              SizedBox(width: 5), // Adding space between the two containers
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(16.0), // Adding padding inside the container
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10), // Adding rounded corners to the top right of the container
                                      bottomRight: Radius.circular(10), // Adding rounded corners to the bottom right of the container
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        'Get 20% off',
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'Coupons Name',
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'Sep 14 - Sep 20',
                                        style: TextStyle(
                                          fontSize: 10.0,
                                          color: Colors.red.shade900,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  // When the text is tapped, show the modal
                                  CouponDialog.show(context);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300], // Changing button color to light grey
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    'Apply Coupons',
                                    style: TextStyle(
                                      fontSize: 10.0,
                                      color: Colors.black, // Changing button text color to black
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 10.0), // Adding space between the two containers
                  Padding(
                    padding: EdgeInsets.all(10.0), // Adding margin around the container
                    child: Material(
                      elevation: 4, // Elevation for the shadow
                      borderRadius: BorderRadius.circular(10), // Adding rounded corners to the container
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.yellow.shade50,
                          borderRadius: BorderRadius.circular(10), // Adding rounded corners to the container
                        ),
                        child: Container(
                          margin: EdgeInsets.only(right: 10.0), // Adding margin on the right side of the row
                          height: 120.0, // Define the height of the row
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: 100.0, // Width of the container
                                height: 100.0, // Height of the container
                                padding: EdgeInsets.all(10.0), // Adding margin around the image
                                child: Center(
                                  child: Image.network(
                                    'https://static.vecteezy.com/system/resources/previews/020/950/892/non_2x/eid-offer-label-seal-sticker-stamp-tag-icon-for-shopping-discount-promotion-vector.jpg', // Replace this with your image URL
                                    fit: BoxFit.cover, // Adjust this according to your image requirement
                                  ),
                                ),
                              ),
                              SizedBox(width: 5), // Adding space between the two containers
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(16.0), // Adding padding inside the container
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10), // Adding rounded corners to the top right of the container
                                      bottomRight: Radius.circular(10), // Adding rounded corners to the bottom right of the container
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        'Get 20% off',
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'Coupons Name',
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'Sep 14 - Sep 20',
                                        style: TextStyle(
                                          fontSize: 10.0,
                                          color: Colors.red.shade900,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  // When the text is tapped, show the modal
                                  CouponDialog.show(context);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300], // Changing button color to light grey
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    'Apply Coupons',
                                    style: TextStyle(
                                      fontSize: 10.0,
                                      color: Colors.black, // Changing button text color to black
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
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


          )




    );

  }




}
