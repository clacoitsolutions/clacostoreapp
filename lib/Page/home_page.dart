
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../pageUtills/bottom_navbar.dart';
import '../pageUtills/common_drawer.dart';
import '../pageUtills/top_navbar.dart';
import 'home/Grocery_vegitable_home_page.dart';
import 'home/category.dart';
import 'home/slider.dart';
import 'home/top_section_filtter.dart';
import 'home/trandingProduct.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Top row that is not fixed
          SliverToBoxAdapter(
            child: Container(
              color: Colors.pink, // Set the background color to pink
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.white),
                      SizedBox(width: 5),
                      Text(
                        '123 Main St, City',
                        style: TextStyle(color: Colors.white,fontSize: 18),
                      ),
                    ],
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      // Handle user icon tap
                    },
                    child: Icon(Icons.person, color: Colors.white, size: 26),
                  ),
                ],
              ),
            ),
          ),
          // SliverAppBar that remains fixed at the top
          SliverAppBar(
            backgroundColor: Colors.pink,
            elevation: 0,
            automaticallyImplyLeading: false,
            pinned: true, // This ensures the SliverAppBar stays fixed
            flexibleSpace: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => HomeScreen()),
                            );
                          },
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => HomeScreen()),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.white, width: 2),
                              backgroundColor: Colors.transparent,
                              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Claco',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => GroceryHome()),
                            );
                          },
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => GroceryHome()),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.white, width: 2),
                              backgroundColor: Colors.transparent,
                              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'Grocery',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
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
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(50),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                color: Colors.black.withOpacity(0.02),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(Icons.search, color: Colors.grey.withOpacity(0.5)),
                            ),
                            Expanded(
                              child: Center(
                                child: TextField(
                                  style: TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                    hintText: 'Search any products..',
                                    hintStyle: TextStyle(color: Colors.grey.withOpacity(0.5)),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(bottom: 8.0),
                                  ),
                                ),
                              ),
                            ),
                            Icon(Icons.mic, color: Colors.grey.withOpacity(0.7)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Body content
          SliverToBoxAdapter(
            child: HomeBody(),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(context: context),
    );


  }
}

class HomeBody extends StatefulWidget {
  const HomeBody({Key? key}) : super(key: key);

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  bool _showTrending = true; // Initial state for trending products
  String? _userName; // For displaying user name in the drawer

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('name');
    });
  }

  void toggleTrending() {
    setState(() {
      _showTrending = !_showTrending;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.02),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 0),
              homeScreenSlider(),

              SizedBox(height: 10),

              HomeCategory(),
              SizedBox(height: 5),


              topSectionFilter(context),
              SizedBox(height: 0),
              // Toggle Trending Products
              TrendingProduct(),
              SizedBox(height: 20),
              // ... rest of your widgets ...

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
