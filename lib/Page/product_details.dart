import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ProductDetails extends StatefulWidget {
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int _currentIndex = 0;
  List<String> _images = [
    'https://cdn.pixabay.com/photo/2024/02/15/15/29/crocus-8575610_640.jpg',
    'https://cdn.pixabay.com/photo/2023/09/17/22/25/witch-8259351_640.jpg',
    'https://cdn.pixabay.com/photo/2023/05/23/07/05/royal-gramma-basslet-8012082_640.jpg',
    // Add more image URLs as needed
  ];

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  CarouselController _carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              // Handle cart icon tap
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text(
                'Drawer Header',
                style: TextStyle(color: Colors.white),
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Item 1'),
              onTap: () {
                // Update the UI based on the item selected
                // Close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                // Update the UI based on the item selected
                // Close the drawer
                Navigator.pop(context);
              },
            ),
            // Add more items if needed
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                CarouselSlider(
                  carouselController: _carouselController,
                  options: CarouselOptions(
                    height: 200, // Adjust the height as needed
                    viewportFraction: 1.0, // Full width
                    onPageChanged: (index, _) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    autoPlay: true, // Enable automatic sliding
                    autoPlayInterval: Duration(seconds: 3), // Set interval duration
                    autoPlayAnimationDuration: Duration(milliseconds: 800), // Animation duration
                    autoPlayCurve: Curves.fastOutSlowIn, // Animation curve
                  ),
                  items: _images.map((image) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                            color: Colors.grey,
                          ),
                          child: Image.network(
                            image,
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      _carouselController.previousPage();
                    },
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: IconButton(
                    icon: Icon(Icons.arrow_forward),
                    onPressed: () {
                      _carouselController.nextPage();
                    },
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _images.map((url) {
                int index = _images.indexOf(url);
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentIndex == index ? Colors.blueAccent : Colors.grey,
                  ),
                );
              }).toList(),
            ),
            Padding(
              padding: EdgeInsets.all(16.0), // Adjust the padding as needed
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Size: m",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16), // Add space between the text and buttons
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Handle button tap
                        },
                        style: ElevatedButton.styleFrom(
                          side: BorderSide(color: Colors.red, width: 1), // Border color and width
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        child: Text('s'),
                      ),
                      SizedBox(width: 16), // Add space between buttons
                      ElevatedButton(
                        onPressed: () {
                          // Handle button tap
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.red,
                          side: BorderSide(color: Colors.red, width: 1), // Border color and width
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        child: Text('m'),
                      ),
                      SizedBox(width: 16), // Add space between buttons
                      ElevatedButton(
                        onPressed: () {
                          // Handle button tap
                        },
                        style: ElevatedButton.styleFrom(
                          side: BorderSide(color: Colors.red, width: 1), // Border color and width
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        child: Text('xl'),
                      ),
                      SizedBox(width: 16), // Add space between buttons
                      ElevatedButton(
                        onPressed: () {
                          // Handle button tap
                        },
                        style: ElevatedButton.styleFrom(
                          side: BorderSide(color: Colors.red, width: 1), // Border color and width
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        child: Text('xxl'),
                      ),
                    ],
                  ),
                  SizedBox(height: 16), // Add space between the text and buttons
                  Text(
                    "Best Image",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10), // Add space between the text and buttons
                  Text(
                    "Vision Alta Men’s Shoes Size (All Colours)",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 10), // Add space between the text and buttons
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.yellow),
                      Icon(Icons.star, color: Colors.yellow),
                      Icon(Icons.star, color: Colors.yellow),
                      Icon(Icons.star, color: Colors.yellow),
                      Icon(Icons.star_half,
                        color: Colors.grey,),
                      Text("80,699",
                        style: TextStyle(
                          fontSize: 15, // Adjust the font size as needed
                          color: Colors.grey, // Adjust the color as needed
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10), // Add space between the text and buttons
                  Row(
                    children: [
                      Text(
                        '₹2999',
                        style: TextStyle(
                          decoration: TextDecoration.lineThrough,
                          fontSize: 15, // Adjust the font size as needed
                          color: Colors.black, // Adjust the color as needed
                        ),
                      ),
                      SizedBox(width: 12), // Add space between buttons
                      Text(
                        '₹1500',
                        style: TextStyle(
                          fontSize: 15, // Adjust the font size as needed
                          color: Colors.black, // Adjust the color as needed
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        '50% off',
                        style: TextStyle(
                          fontSize: 15, // Adjust the font size as needed
                          color: Colors.red, // Adjust the color as needed
                        ),
                      ),
                      SizedBox(width: 12), // Add space between buttons
                    ],
                  ),
                  SizedBox(height: 10), // Add space between the text and buttons
                  Text(
                    " Image Details",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10), // Add space between the text and buttons
                  Text(
                    " Perhaps the most iconic sneaker of all-time, this origina Chicago? colorway is the cornerstone to any sneaker collection. Made famous in 1985 by Michael Jordan, the famous colorway of the Air Jordan 1. This 2015 release saw",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "  the.",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        TextSpan(
                          text: " More..",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.red.withOpacity(0.6),
                          ),
                        ),

                      ],
                    ),
                  ),

                  SizedBox(height: 10), // Add space between the text and buttons
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Handle button tap
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0), // Set border radius here
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min, // Align children to center
                          children: [
                            Icon(Icons.shopping_cart), // Add cart icon
                            SizedBox(width: 8), // Add space between icon and text
                            Text('Go to cart'), // Add button text
                          ],
                        ),
                      ),
                      SizedBox(width: 12), // Add space between buttons
                      ElevatedButton(
                        onPressed: () {
                          // Handle button tap
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0), // Set border radius here
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min, // Align children to center
                          children: [
                            Icon(Icons.touch_app), // Add cart icon
                            SizedBox(width: 8), // Add space between icon and text
                            Text('Buy Now'), // Add button text
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.pink.withOpacity(0.2), // Set pink background with opacity 0.7
                      borderRadius: BorderRadius.circular(5), // Set border radius to 5
                    ),
                    constraints: BoxConstraints(
                      minHeight: 60,
                      minWidth: double.infinity, // Set minimum width to infinity for 100% width
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 50, top: 10), // Adjust the left and top padding as needed
                          child: Text(
                            "Delivery in ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: AutofillHints.addressCity,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 50, bottom: 10), // Adjust the left and bottom padding as needed
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "1 within Hour",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Handle button tap
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black54,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0), // Set border radius here
                            ),
                            fixedSize: Size(MediaQuery.of(context).size.width * 0.5, 50), // Set width to 50% of screen width and height to 50
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min, // Align children to center
                            children: [
                              Icon(Icons.visibility), // Add cart icon
                              Text('View Similar'), // Add button text
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 8), // Add space between buttons
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Handle button tap
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black45,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0), // Set border radius here
                            ),
                            fixedSize: Size(MediaQuery.of(context).size.width * 0.5, 50), // Set width to 50% of screen width and height to 50
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min, // Align children to center
                            children: [
                              Icon(Icons.compare_arrows), // Add cart icon
                              Text('Add to Compare'), // Add button text
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16), // Add space between the text and buttons
                  Text(
                    "Similer To",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5), // Add space between the text and buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "500+ items",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 80), // Add space between text and buttons
                      ElevatedButton(
                        onPressed: () {
                          // Handle button tap
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 6, horizontal: 7), // Adjust padding as needed
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0), // Set border radius here
                          ),
                        ),
                        child: Row(
                          children: [
                            Text('Short'),
                            Icon(Icons.arrow_drop_down), // Downward arrow icon
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Handle button tap
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 6, horizontal: 7), // Adjust padding as needed
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0), // Set border radius here
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.filter_list), // Filter icon
                            SizedBox(width: 4), // Add space between icon and text
                            Text('Filter', style: TextStyle(fontSize: 14)), // Adjust text size as needed
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15), // Add space between the text and buttons
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                width: double.infinity,
                                height: 200, // Set the desired height
                                child: Image.network(
                                  'https://cdn.pixabay.com/photo/2016/03/27/22/16/fashion-1284496_640.jpg',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),

                            SizedBox(height: 8), // Add space between image and text
                            const Text(
                              'Girls Shoes',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8), // Add space between text and description
                            const Text(
                              'Mid Peach Mocha Shoes For Man White Black Pink S...',
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(height: 10), // Add space between description and price
                            Text(
                              '₹1500',
                              style: TextStyle(
                                fontSize: 15, // Adjust the font size as needed
                                color: Colors.black, // Adjust the color as needed
                              ),
                            ),
                            Row(
                              children: [
                                Icon(Icons.star, color: Colors.yellow, size: 15), // Adjust the size as needed
                                Icon(Icons.star, color: Colors.yellow, size: 15), // Adjust the size as needed
                                Icon(Icons.star, color: Colors.yellow, size: 15), // Adjust the size as needed
                                Icon(Icons.star, color: Colors.yellow, size: 15), // Adjust the size as needed
                                Icon(
                                  Icons.star_half,
                                  color: Colors.grey,
                                  size: 15,
                                ),
                                Text("44,399",
                                  style: TextStyle(
                                    fontSize: 15, // Adjust the font size as needed
                                    color: Colors.grey, // Adjust the color as needed
                                  ),
                                ),
                              ],
                            ),

                          ],
                        ),
                      ),
                      SizedBox(width: 8), // Add space between images
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                width: double.infinity,
                                height: 200, // Set the desired height
                                child: Image.network(
                                  'https://cdn.pixabay.com/photo/2023/08/25/07/37/shoes-8212405_640.jpg',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),

                            SizedBox(height: 8), // Add space between image and text
                            Text(
                              'Boys Shoes',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8), // Add space between text and description
                            Text(
                              'Nike Air Jordan Retro 1 Low Mystic Black',
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(height: 10), // Add space between description and price
                            Text(
                              '₹1500',
                              style: TextStyle(
                                fontSize: 15, // Adjust the font size as needed
                                color: Colors.black, // Adjust the color as needed
                              ),
                            ),
                            Row(
                              children: [
                                Icon(Icons.star, color: Colors.yellow, size: 15), // Adjust the size as needed
                                Icon(Icons.star, color: Colors.yellow, size: 15), // Adjust the size as needed
                                Icon(Icons.star, color: Colors.yellow, size: 15), // Adjust the size as needed
                                Icon(Icons.star, color: Colors.yellow, size: 15), // Adjust the size as needed
                                Icon(
                                  Icons.star_half,
                                  color: Colors.grey,
                                  size: 15,
                                ),
                                Text("2,55,999",
                                  style: TextStyle(
                                    fontSize: 15, // Adjust the font size as needed
                                    color: Colors.grey, // Adjust the color as needed
                                  ),
                                )
                              ],
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
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        height:   60,// Set the background color to yellow
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.home_outlined),
              onPressed: () {
                // Handle home icon tap
              },
            ),
            IconButton(
              icon: Icon(  Icons.favorite_outline,),
              onPressed: () {
                // Handle wishlist icon tap
              },
            ),
            IconButton(
              icon: Icon(Icons.shopping_cart_outlined),
              onPressed: () {
                // Handle add to cart icon tap
              },
              style: IconButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0), // Set border radius here
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                // Handle search icon tap
              },
            ),
            IconButton(
              icon: Icon(Icons.settings_outlined),
              onPressed: () {
                // Handle settings icon tap
              },
            ),
          ],
        ),
      ),

    );
  }
}
