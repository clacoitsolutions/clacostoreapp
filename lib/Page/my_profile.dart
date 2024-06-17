import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../pageUtills/add_address_form.dart';
import '../pageUtills/bottom_navbar.dart';
import '../pageUtills/common_appbar.dart';
import '../pageUtills/coupons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../pageUtills/help_center.dart';
import '../pageUtills/recent_view_product.dart';
import '../pageUtills/top_navbar.dart';
import '../pageUtills/update_user_profile.dart';
import '../pageUtills/user_profile_review.dart';
import 'addressscreen.dart';
import 'my_order.dart';
import 'package:claco_store/pageUtills/coupons.dart';

import 'order_details.dart';
import 'order_summary_page.dart';


class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: ' Claco '), // Instantiate CommonAppBar directly
      body: MyProfilePage(title: 'Claco',),
      bottomNavigationBar: CustomBottomNavigationBar(context: context),
    );
  }
}



class MyProfilePage extends StatefulWidget {
  const MyProfilePage({Key? key, required this.title}) : super(key: key);

  final String title;

  Future<List<dynamic>> getRecentProducts() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> recentProducts = prefs.getStringList('recentProducts') ?? [];

    // Reverse the list so that most recent products come first
    recentProducts = recentProducts.reversed.toList();

    return recentProducts.map((productJson) => jsonDecode(productJson)).toList();
  }

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class ImageInfo {
  final String imagePath;
  final String imageName;

  ImageInfo(this.imagePath, this.imageName);
}

class _MyProfilePageState extends State<MyProfilePage> {
  String? _mobileNo;



  @override
  void initState() {
    super.initState();
    _loadMobileNo();
  }

  Future<void> _loadMobileNo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _mobileNo = prefs.getString('mobileNo') ?? '+91 2034567890'; // Fallback number
    });
  }

  // Define a list of ImageInfo objects with image paths and names
  List<ImageInfo> imageList = [
    ImageInfo('assets/images/sliderimg1.jpg', 'Suit'),
    ImageInfo('assets/images/sliderimg2.jpg', 'Top'),
    // Add more ImageInfo objects as needed
    ImageInfo('assets/images/sliderimg3.jpg', 'Jeans'),
    ImageInfo('assets/images/sliderimg4.jpg', 'Shirt'),
    ImageInfo('assets/images/sliderimg5.jpg', 'T-shirt'),
    ImageInfo('assets/images/sliderimg6.jpg', 'top'),
    ImageInfo('assets/images/sliderimg7.jpg', 'Top'),
  ];

  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 230.0,
              color: Colors.white,
              margin: EdgeInsets.only(bottom: 10.0),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0), // Add margin from left and right
                    child: Container(
                      height: 60.0,
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _mobileNo ?? 'Loading...',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  // Add your button onPressed logic here
                                },
                                style: ElevatedButton.styleFrom(
                                  side: BorderSide(color: Colors.black, width: 1.0), // Add border
                                ),
                                child: const Row(
                                  children: [
                                    Icon(
                                      Icons.monetization_on,
                                      color: Colors.yellow,
                                      size: 20, // Adjust the size of the icon
                                    ),
                                    SizedBox(width: 4), // Add some space between the icon and the text
                                    Text(
                                      '0',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20.0, // Adjust the font size of the text
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
                  ),

                  Container(
                    height: 40.0,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0), // Add margin horizontally
                      child: Row(
                        children: [
                          const Text(
                            'Explore',
                            style: TextStyle(
                              color: Colors.black, // Set text color to blue
                              fontSize: 18.0,
                            ),
                          ),
                          SizedBox(width: 4.0), // Add space between "Explore" and "Plus"
                          const Text(
                            'Plus',
                            style: TextStyle(
                              color: Colors.pink, // Set text color to blue
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 10.0), // Add space between "Explore Plus" text and additional text
                          GestureDetector(
                            onTap: () {
                              // Add your onTap functionality here
                            },
                            child: Container(
                              width: 25.0, // Set the width of the button
                              height: 25.0, // Set the height of the button
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey.withOpacity(0.3), // Adjust the color and opacity as needed
                              ),
                              child: RichText(
                                text: const TextSpan(
                                  children: [
                                    WidgetSpan(
                                      alignment: PlaceholderAlignment.middle,
                                      baseline: TextBaseline.alphabetic,
                                      child: Icon(
                                        Icons.arrow_forward_ios_outlined,
                                        color: Colors.black,
                                        size: 11.0,
                                      ),
                                    ),
                                  ],
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800, // Apply bold style to the icon
                                  ),
                                ),
                              ),
                            ),
                          )



                        ],
                      ),
                    ),
                  ),


                  Container(
                    height: 120.0,

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: 150, // Set a fixed width for the button
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>MyOrderScreen()));
                                  // Add your onPressed logic here
                                },
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: Colors.grey), // Set grey border
                                  padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0), // Adjust button padding
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero, // Remove border radius
                                  ),
                                ),
                                icon: Icon(Icons.shopping_bag, color: Colors.pink), // Add icon for 'Order' button
                                label: const Text(
                                  'Order',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 150, // Set a fixed width for the button
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  // Add your onPressed logic here
                                },
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: Colors.grey), // Set grey border
                                  padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0), // Adjust button padding
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero, // Remove border radius
                                  ),
                                ),
                                icon: Icon(Icons.favorite_border, color: Colors.pink), // Add icon for 'Wishlist' button
                                label: const Text(
                                  'Wishlist',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20), // Add a gap between the rows
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: 150, // Set a fixed width for the button
                              child: OutlinedButton.icon(
                                onPressed: () {
                             Navigator.push(context, MaterialPageRoute(builder: (context)=>coupons()));
                                },
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: Colors.grey), // Set grey border
                                  padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0), // Adjust button padding
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero, // Remove border radius
                                  ),
                                ),
                                icon: Icon(Icons.card_giftcard, color: Colors.pink), // Add icon for 'Coupons' button
                                label: const Text(
                                  'Coupons',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 150, // Set a fixed width for the button
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => HelpCenter()),
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: Colors.grey), // Set grey border
                                  padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0), // Adjust button padding
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero, // Remove border radius
                                  ),
                                ),
                                icon: Icon(Icons.help, color: Colors.pink), // Add icon for 'Help Center' button
                                label: const Text(
                                  'Help',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
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
            Container(
              height: 100.0,
              color: Colors.white,
              margin: EdgeInsets.only(bottom: 10.0),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0), // Add margin horizontally
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          height: 50.0,
                          width: 50.0, // Set the width for the image
                          child: Image.asset(
                            'assets/images/sliderimg1.jpg', // Replace 'your_image.png' with your image asset path
                            width: 70.0, // Set the height and width of the image
                          ),
                        ),
                        SizedBox(width: 10.0), // Add some space between the image and the text
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Add/Verify your Email',
                                style: TextStyle(
                                  fontSize: 15.0, // Set larger font size for "Verify Email"
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5.0), // Add some space between the texts
                              Text(
                                'Get Latest Update Your Order',
                                style: TextStyle(
                                  fontSize: 14.0, // Set font size for "Get Latest Update Your Order"
                                  color: Colors.black, // Set text color to black
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(width: 10.0), // Add some space between the text and the button
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => UpdateUserProfile()),
                            );
                          },

                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink, // Set button color to pink
                          ),
                          child: Text(
                            'Update',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Add space between the row and the text
                  ],
                ),
              ),
            ),


            Container(
              height: 170.0,
              color: Colors.white,
              margin: EdgeInsets.only(bottom: 10.0),
              child:Column(
                children: <Widget>[
                  // Existing widgets...
                  // Heading for recently viewed images
                  Container(
                    color: Colors.pink,
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'Recently Viewed',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  // Recently viewed images
                  Container(
                    height: 120.0,
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    color: Colors.white70,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          // Display images dynamically from imageList
                          for (var imageInfo in imageList)
                            SizedBox(
                              width: 100.0,
                              child: Card(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0), // Add border radius
                                  side: BorderSide(
                                    color: Colors.grey.withOpacity(0.5), // Set border color and opacity
                                    width: 1.0, // Set border width
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      imageInfo.imagePath,
                                      height: 60.0,
                                    ),
                                    SizedBox(height: 8.0),
                                    Text(
                                      imageInfo.imageName,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),


                  // Additional widgets...
                ],
              ),),
            Container(
              margin: EdgeInsets.only(bottom: 10.0),
              height: 250.0,
              color: Colors.white,
              child: Column(
                children: [
                  // First Row (Heading)
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 15.0),
                        child: Text(
                          'Account Setting',
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Second Row
                  Row(
                    children: [
                      // First Part
                      const Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 2.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.person,
                                color: Colors.pink,
                                size: 24.0,
                              ),
                              SizedBox(width: 8.0),
                              Text(
                                'Edit Profile',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Second Part (Arrow Icon)
                      Padding(
                        padding: EdgeInsets.only(right: 10.0), // Add margin to the right side of the button
                        child: InkWell(
                          onTap: () {
                            Navigator.push((context), MaterialPageRoute(builder: (context)=>UpdateUserProfile(),));
                            // Add your onTap functionality here
                          },
                          child: Container(
                            width: 30.0,
                            height: 30.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.withOpacity(0.3), // Adjust the color and opacity as needed
                            ),
                            child: Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: Colors.black,
                              size: 12.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0), // Add margin between rows
                  Row(
                    children: [
                      // First Part
                      const Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 2.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.credit_card,
                                color: Colors.pink,
                                size: 24.0,
                              ),
                              SizedBox(width: 8.0),
                              Text(
                                'Saved Cards & Wallet',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Second Part (Arrow Icon)
                      Padding(
                        padding: EdgeInsets.only(right: 10.0), // Add margin to the right side of the button
                        child: InkWell(
                          onTap: () {
                            // Add your onTap functionality here

                          },
                          child: Container(
                            width: 30.0,
                            height: 30.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.withOpacity(0.3), // Adjust the color and opacity as needed
                            ),
                            child: Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: Colors.black,
                              size: 12.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0), // Add margin between rows
                  Row(
                    children: [
                      // First Part
                      const Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 2.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Colors.pink,
                                size: 24.0,
                              ),
                              SizedBox(width: 8.0),
                              Text(
                                'Saved Address',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Second Part (Arrow Icon)
                      Padding(
                        padding: EdgeInsets.only(right: 10.0), // Add margin to the right side of the button
                        child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddAddressPage(),
                            ),
                          );
                           },


                          child: Container(
                            width: 30.0,
                            height: 30.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.withOpacity(0.3), // Adjust the color and opacity as needed
                            ),
                            child: const Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: Colors.black,
                              size: 12.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10.0), // Add margin between rows
                  Row(
                    children: [
                      // First Part
                      const Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 2.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.notifications,
                                color: Colors.pink,
                                size: 24.0,
                              ),
                              SizedBox(width: 8.0),
                              Text(
                                'Notification Setting',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Second Part (Arrow Icon)
                      Padding(
                        padding: EdgeInsets.only(right: 10.0), // Add margin to the right side of the button
                        child: InkWell(
                          onTap: () {
                            // Add your onTap functionality here
                          },
                          child: Container(
                            width: 30.0,
                            height: 30.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.withOpacity(0.3), // Adjust the color and opacity as needed
                            ),
                            child: const Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: Colors.black,
                              size: 12.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Container(
              margin: EdgeInsets.only(bottom: 10.0),
              height: 150.0,
              color: Colors.white,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 15.0),
                        child: Text(
                          'My Activity',
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      // First Part
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.reviews_outlined,
                                color: Colors.pink,
                                size: 24.0,
                              ),
                              SizedBox(width: 8.0),
                              Text(
                                'Reviews',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Second Part (Arrow Icon)
                      Padding(
                        padding: EdgeInsets.only(right: 10.0), // Add margin to the right side of the button
                        child: InkWell(
                          onTap: () {

                            Navigator.push(
                              context,MaterialPageRoute(builder: (context)=> review()),);
                          },
                          child: Container(
                            width: 30.0,
                            height: 30.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.withOpacity(0.3), // Adjust the color and opacity as needed
                            ),
                            child: Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: Colors.black,
                              size: 12.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      // First Part
                      const Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.question_mark_rounded,
                                color: Colors.pink,
                                size: 24.0,
                              ),
                              SizedBox(width: 8.0),
                              Text(
                                'Question & Answer',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Second Part (Arrow Icon)
                      Padding(
                        padding: EdgeInsets.only(right: 10.0), // Add margin to the right side of the button
                        child: InkWell(
                          // onTap: () {
                          //   Navigator.push(context,MaterialPageRoute(builder: (context)=>User_QuestionAnswer()));
                          //   // Add your onTap functionality here
                          // },
                          child: Container(
                            width: 30.0,
                            height: 30.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.withOpacity(0.3), // Adjust the color and opacity as needed
                            ),
                            child: Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: Colors.black,
                              size: 12.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

            ),
            Container(
              margin: EdgeInsets.only(bottom: 10.0),
              height: 120.0,
              color: Colors.white,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 15.0),
                        child: Text(
                          'Earn with claco',
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      // First Part
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.card_giftcard_outlined,
                                color: Colors.pink,
                                size: 24.0,
                              ),
                              SizedBox(width: 8.0),
                              Text(
                                'Sell on Claco',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Second Part (Arrow Icon)
                      Padding(
                        padding: EdgeInsets.only(right: 10.0), // Add margin to the right side of the button
                        child: InkWell(
                          onTap: () {

                            _launchURL(); // Call the _launchURL function using parentheses
                            Text('Open Website');
                            // Add your onTap functionality here
                          },
                          child: Container(
                            width: 30.0,
                            height: 30.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.withOpacity(0.3), // Adjust the color and opacity as needed
                            ),
                            child: Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: Colors.black,
                              size: 12.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

            ),


            Container(
              margin: EdgeInsets.only(bottom: 10.0),
              height: 150.0,
              color: Colors.white,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 15.0),
                        child: Text(
                          'Feedback & information',
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      // First Part
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.description,
                                color: Colors.pink,
                                size: 24.0,
                              ),
                              SizedBox(width: 8.0),
                              Text(
                                'Term,Policies and Licenses',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Second Part (Arrow Icon)
                      Padding(
                        padding: EdgeInsets.only(right: 10.0), // Add margin to the right side of the button
                        child: InkWell(
                          onTap: () {
                            // Add your onTap functionality here
                          },
                          child: Container(
                            width: 30.0,
                            height: 30.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.withOpacity(0.3), // Adjust the color and opacity as needed
                            ),
                            child: Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: Colors.black,
                              size: 12.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      // First Part
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.question_answer,
                                color: Colors.pink,
                                size: 24.0,
                              ),
                              SizedBox(width: 8.0),
                              Text(
                                'Browser FAQ',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Second Part (Arrow Icon)
                      Padding(
                        padding: EdgeInsets.only(right: 10.0), // Add margin to the right side of the button
                        child: InkWell(
                          onTap: () {
                            // Add your onTap functionality here
                          },
                          child: Container(
                            width: 30.0,
                            height: 30.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.withOpacity(0.3), // Adjust the color and opacity as needed
                            ),
                            child: Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: Colors.black,
                              size: 12.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

            ),

            Container(
              margin: EdgeInsets.only(bottom: 10.0),
              color: Colors.white,
              child: TextButton(
                onPressed: () {
                  // Action to perform when the button is pressed
                  print('Button pressed');
                },
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(Size(350, 40)), // Set the width and height of the button
                ),
                child: Text(
                  'logout',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.pink,
                  ),
                ),
              ),
            ),

          ],
        ),




      ),
    );
  }



  _launchURL() async {
    const String url = 'https://www.claco.in/vendor/';
    final Uri uri = Uri.parse(url); // Create a Uri object from the URL string
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri); // Pass the Uri object to launchUrl
    } else {
      throw 'Could not launch $url';
    }
  }

}
