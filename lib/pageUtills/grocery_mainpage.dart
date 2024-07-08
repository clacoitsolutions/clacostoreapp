import 'package:claco_store/Page/short_by.dart';
import 'package:claco_store/Page/wishlist_page.dart';
import 'package:claco_store/pageUtills/common_appbar.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../pageUtills/bottom_navbar.dart';
import '../../pageUtills/common_drawer.dart';
import '../../pageUtills/top_navbar.dart';
import '../Page/filter_page.dart';

class GroceryMain extends StatelessWidget {
  const GroceryMain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          CommonAppBar(title: 'Grocery'), // Displaying the app bar with a title
      drawer: CommonDrawer(), // Using the CommonDrawer for the drawer
      body: GroceryMainPage(), // Displaying the main content
      // bottomNavigationBar: BottomNavigation(),
    );
  }
}

class GroceryMainPage extends StatelessWidget {
  const GroceryMainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.02),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 5),
              SizedBox(width: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "500+ items",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return SortingPage(); // Show the SortingPage in the modal bottom sheet
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Short',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context, // Ensure context is available
                        MaterialPageRoute(builder: (context) => Filter()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.filter_list),
                        SizedBox(width: 4),
                        Text('Filter', style: TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(
                            10), // Border radius for all sides
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: 10, top: 8), // Add top padding here
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Deal of the Day',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.access_time,
                                      color: Colors.white,
                                      size: 16, // Adjust the size as needed
                                    ),
                                    SizedBox(
                                        width:
                                            4), // Add some space between the icon and the text
                                    Text(
                                      '22h 55m 20s remaining',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 10, // Add space between text and button
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 10), // Add padding to the right
                            child: ElevatedButton(
                              onPressed: () {
                                // Add functionality for the button
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor:
                                    Colors.blueAccent.withOpacity(0.8),
                                side: const BorderSide(
                                    color: Colors.white), // Add border
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      3), // Border radius for button
                                ),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('View all'),
                                  Icon(Icons.arrow_forward), // Right arrow icon
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Add space between text and button
                ],
              ),
              const SizedBox(height: 15), // Add space between images

              Column(
                children: [
                  // Existing row
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
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
                              const Padding(
                                padding: EdgeInsets.only(
                                    left:
                                        10), // Adjust the left padding as needed
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Girls Shoes',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
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
                                        Icon(Icons.star,
                                            color: Colors.yellow, size: 15),
                                        Icon(Icons.star,
                                            color: Colors.yellow, size: 15),
                                        Icon(Icons.star,
                                            color: Colors.yellow, size: 15),
                                        Icon(Icons.star,
                                            color: Colors.yellow, size: 15),
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
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        flex: 1,
                        child: Container(
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
                              const Padding(
                                padding: EdgeInsets.only(
                                    left:
                                        10), // Adjust the left padding as needed
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Boys Shoes',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
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
                                        Icon(Icons.star,
                                            color: Colors.yellow, size: 15),
                                        Icon(Icons.star,
                                            color: Colors.yellow, size: 15),
                                        Icon(Icons.star,
                                            color: Colors.yellow, size: 15),
                                        Icon(Icons.star,
                                            color: Colors.yellow, size: 15),
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
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                      height:
                          15), // Add space between existing row and new background image
                  // Background image with button
                  Container(
                    height: 200, // Adjust the height as needed
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                            'https://cdn.pixabay.com/photo/2020/05/26/07/43/skateboard-5221914_640.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(
                            right: 10,
                            left: 195), // Adjust the padding as needed

                        child: ElevatedButton(
                          onPressed: () {
                            // Add functionality for the button
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.red,
                            side: const BorderSide(
                                color: Colors.red), // Add border
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  3), // Border radius for button
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('View all'),
                              Icon(Icons.arrow_forward), // Right arrow icon
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.pink.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(
                            10), // Border radius for all sides
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(
                                left: 10, top: 8), // Add top padding here
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Trending Products ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.access_time,
                                      color: Colors.white,
                                      size: 16, // Adjust the size as needed
                                    ),
                                    SizedBox(
                                        width:
                                            4), // Add some space between the icon and the text
                                    Text(
                                      '22h 55m 20s remaining',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 10, // Add space between text and button
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 10), // Add padding to the right
                            child: ElevatedButton(
                              onPressed: () {
                                // Add functionality for the button
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.pink,
                                side: const BorderSide(
                                    color: Colors.white), // Add border
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      3), // Border radius for button
                                ),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('View all'),
                                  Icon(Icons.arrow_forward), // Right arrow icon
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Add space between text and button
                ],
              ),
// Add Image Card Slider below the Row
              const SizedBox(
                height: 10, // Add space between text and button
              ),
              Column(
                children: [
                  const SizedBox(
                    height: 15, // Add space between text and button
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
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
                                    'https://cdn.pixabay.com/photo/2016/11/19/18/06/feet-1840619_640.jpg',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              const Padding(
                                padding: EdgeInsets.only(
                                    left:
                                        10), // Adjust the left padding as needed
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Boys Shoes',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
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
                                        Icon(Icons.star,
                                            color: Colors.yellow, size: 15),
                                        Icon(Icons.star,
                                            color: Colors.yellow, size: 15),
                                        Icon(Icons.star,
                                            color: Colors.yellow, size: 15),
                                        Icon(Icons.star,
                                            color: Colors.yellow, size: 15),
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
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        flex: 1,
                        child: Container(
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
                                    'https://cdn.pixabay.com/photo/2023/06/17/22/51/shoes-8070908_640.jpg',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              const Padding(
                                padding: EdgeInsets.only(
                                    left:
                                        10), // Adjust the left padding as needed
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'girls Shoes',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
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
                                        Icon(Icons.star,
                                            color: Colors.yellow, size: 15),
                                        Icon(Icons.star,
                                            color: Colors.yellow, size: 15),
                                        Icon(Icons.star,
                                            color: Colors.yellow, size: 15),
                                        Icon(Icons.star,
                                            color: Colors.yellow, size: 15),
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
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15, // Add space between text and button
                  ),
                  Container(
                    height: 260, // Set the height as needed
                    width: double.infinity, // Make it full width
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // Align text to the left
                      children: [
                        Container(
                          height: 200, // 80% of the container's height
                          width: double.infinity, // Make it full width
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(5), // Add border radius
                            image: const DecorationImage(
                              image: NetworkImage(
                                  'https://cdn.pixabay.com/photo/2017/09/26/17/34/ballet-2789416_640.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(
                            height:
                                10), // Add some space between the image and the text
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(
                                  left: 20), // Add left padding to the column
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'New Arrivals ', // Your additional text
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Summer’ 25 Collections', // Your additional text
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  right: 10), // Add right padding to the button
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  // Add functionality for the button
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          20), // Add padding to the button
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        5), // Border radius for button
                                  ),
                                ),
                                icon: Icon(
                                    Icons.arrow_forward), // Right arrow icon
                                label: Text('Button'), // Text of the button
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                  height: 20), // Add some space between the image and the text
              Column(children: [
                Container(
                  height: 310, // Set the height as needed
                  width: double.infinity, // Make it full width
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Align text to the left
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: 20,
                                top: 5,
                                bottom: 5), // Add left padding to the column
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Sponserd ', // Your additional text
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 230, // 80% of the container's height
                        width: double.infinity, // Make it full width
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(10), // Add border radius
                          image: const DecorationImage(
                            image: NetworkImage(
                                'https://cdn.pixabay.com/photo/2020/05/03/19/09/nike-5126389_640.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(
                          height:
                              10), // Add some space between the image and the text
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(
                                left: 20), // Add left padding to the column
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Up to 50% off ', // Your additional text
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                right: 10), // Add right padding to the button
                            child: GestureDetector(
                              onTap: () {
                                // Add functionality for the icon
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20), // Add padding to the icon
                                child: Icon(
                                  Icons.arrow_forward, // Right arrow icon
                                  color: Colors.black, // Set icon color
                                  size: 24, // Set icon size
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ])
            ],
          ),
        ),
      ),
    );
  }
}
