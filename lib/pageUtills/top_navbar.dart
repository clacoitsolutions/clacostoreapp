import 'package:flutter/material.dart';

import '../Page/home/Grocery_vegitable_home_page.dart';
import '../Page/home_page.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Function()? onPersonIconPressed;

  const HomeAppBar({
    this.onPersonIconPressed,
  });

  @override
  Size get preferredSize => Size.fromHeight(130); // Increased the height of the app bar

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: Colors.pink, // Set background color to pink
          elevation: 0, // Removed the elevation to make it flat
          pinned: true, // Ensure the app bar remains visible at the top
          automaticallyImplyLeading: false, // Disable leading icon

          flexibleSpace: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 4), // Adjust padding as needed
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.white), // Address icon
                        SizedBox(width: 5),
                        Text(
                          '123 Main St, City',
                          style: TextStyle(color: Colors.white),
                        ), // Replace with actual address
                      ],
                    ),

                    // Spacer between address and user icon
                    Spacer(),

                    GestureDetector(
                      onTap: () {
                        // Handle user icon tap
                      },

                        child: Icon(Icons.person, color: Colors.white,size: 26,), // User icon

                    ),
                  ],
                ),
              ),


              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [


                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()), // Replace with the correct page
                      );
                    },
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()), // Replace with the correct page
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
                      // child: Image.asset(
                      //   '/images/ClacoLogo.png', // Replace with your image path
                      //   width: 60, // Adjust the width according to your needs
                      //   height: 30, // Adjust the height according to your needs
                      // ),
                        child: const Text(
                          'Claco',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        )

                  ),
                  ),
                ),

                SizedBox(width: 10),

                Expanded(
                  child: GestureDetector(

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => GroceryHome()), // Replace with the correct page
                      );
                    },
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => GroceryHome()), // Replace with the correct page
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
        )
            ],
          ),

          bottom: PreferredSize(
            preferredSize: Size.fromHeight(70),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 8),
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
                            padding: EdgeInsets.all(8.0), // Increased padding for the search icon
                            child: Icon(Icons.search, color: Colors.grey.withOpacity(0.5)),
                          ),
                          Expanded(
                            child: Center(
                              // Wrap TextField with Center widget
                              child: TextField(
                                style: TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                  hintText: 'Search any products..',
                                  hintStyle: TextStyle(color: Colors.grey.withOpacity(0.5)),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(bottom: 8.0), // Adding padding to the bottom of the text
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
      ],
    );
  }
}
