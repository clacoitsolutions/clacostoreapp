import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget trendingProduct() {
  return Column(
    children: [
      const SizedBox(height: 20),
      Row(
        children: [
          Expanded(
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(10), // Border radius for all sides
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10, top: 8), // Add top padding here
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
                            SizedBox(width: 4), // Add some space between the icon and the text
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
                    padding: const EdgeInsets.only(right: 10), // Add padding to the right
                    child: ElevatedButton(
                      onPressed: () {
                        // Add functionality for the button
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blueAccent.withOpacity(0.8),
                        side: const BorderSide(color: Colors.white), // Add border
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3), // Border radius for button
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
                        padding: EdgeInsets.only(left: 10), // Adjust the left padding as needed
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
                        padding: EdgeInsets.only(left: 10), // Adjust the left padding as needed
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
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 15), // Add space between existing row and new background image
          // Background image with button
          Container(
            height: 200, // Adjust the height as needed
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('https://cdn.pixabay.com/photo/2020/05/26/07/43/skateboard-5221914_640.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(right:10,left:195), // Adjust the padding as needed
                child: ElevatedButton(
                  onPressed: () {
                    // Add functionality for the button
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red), // Add border
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3), // Border radius for button
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
    ],
  );
}