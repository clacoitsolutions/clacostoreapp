import 'package:flutter/material.dart';

class SortingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //
      //   automaticallyImplyLeading: false, // Set this property to false to remove the default back arrow button
      //   elevation: 0,
      // ),

      body: Container(
        color: Colors.white,
        child: Container(
          height: 240,
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  // Add functionality for Option 1 radio button
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey.withOpacity(0.5), // Set the bottom border color to grey
                        width: 1, // Set the border width
                      ),
                    ),
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Short by',
                        style: TextStyle(
                          color: Colors.grey, // Change text color to grey
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 8), // Adding space between rows
              InkWell(
                onTap: () {
                  // Add functionality for Option 2 radio button
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 1),
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Relevance'),
                      Container(
                        height: 16,
                        width: 16,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.black,
                          ),
                        ),
                        // Fill or unfill indicator based on selection,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 8), // Adding space between rows
              InkWell(
                onTap: () {
                  // Add functionality for Option 3 radio button
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 1),
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Price--Low to High'),
                      Container(
                        height: 16,
                        width: 16,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.black,
                          ),
                        ),
                        // Fill or unfill indicator based on selection,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 8), // Adding space between rows
              InkWell(
                onTap: () {
                  // Add functionality for Option 4 radio button
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 1),
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Price--High to Low'),
                      Container(
                        height: 16,
                        width: 16,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.black,
                          ),
                        ),
                        // Fill or unfill indicator based on selection,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 8), // Adding space between rows
              InkWell(
                onTap: () {
                  // Add functionality for Option 5 radio button
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 1),
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Popularity'),
                      Container(
                        height: 16,
                        width: 16,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.black,
                          ),
                        ),
                        // Fill or unfill indicator based on selection,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
