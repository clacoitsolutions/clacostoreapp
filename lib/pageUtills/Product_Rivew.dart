import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

class Review {
  final String userName;
  final String userImage; // Assuming this is an asset path or URL
  final double rating;
  final String reviewText;

  Review({
    required this.userName,
    required this.userImage,
    required this.rating,
    required this.reviewText,
  });
}

class ReviewSection extends StatelessWidget {
  final List<Review> reviews;

  ReviewSection({required this.reviews});

  double calculateAverageRating(List<Review> reviews) {
    if (reviews.isEmpty) return 0.0;
    double sum = reviews.fold(0, (previousValue, review) => previousValue + review.rating);
    return sum / reviews.length;
  }

  Map<int, int> calculateRatingDistribution(List<Review> reviews) {
    Map<int, int> distribution = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    for (var review in reviews) {
      int rating = review.rating.round();
      if (distribution.containsKey(rating)) {
        distribution[rating] = distribution[rating]! + 1;
      }
    }
    return distribution;
  }

  @override
  Widget build(BuildContext context) {
    double averageRating = calculateAverageRating(reviews);
    Map<int, int> ratingDistribution = calculateRatingDistribution(reviews);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Customer Reviews',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  _showReviewModal(context); // Call the function to show the modal
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink, // Set the background color to pink
                ),
                child: Text(
                  'Write Review',
                  style: TextStyle(
                    color: Colors.white, // Set the text color to white
                  ),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "",
                    // Avg.toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: 48.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  RatingBarIndicator(
                    rating: averageRating,
                    itemBuilder: (context, index) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    itemCount: 5,
                    itemSize: 20.0,
                    direction: Axis.horizontal,
                  ),
                  SizedBox(height: 8.0),
                ],
              ),
              SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  children: List.generate(5, (index) {
                    int star = 5 - index;
                    int count = ratingDistribution[star] ?? 0;
                    double percentage = reviews.isEmpty ? 0.0 : (count / reviews.length);
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        children: [
                          // Text('$totalReview '),
                          Icon(Icons.star, color: Colors.amber),
                          SizedBox(width: 8.0),
                          Expanded(
                            child: LinearProgressIndicator(
                              value: percentage,
                              backgroundColor: Colors.grey[300],
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                            ),
                          ),
                          SizedBox(width: 8.0),
                          // Text('${(totRew ).toStringAsFixed}'),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: reviews.length,
          itemBuilder: (context, index) {
            return ReviewCard(review: reviews[index]);
          },
        ),
      ],
    );
  }
}

class ReviewCard extends StatelessWidget {
  final Review review;

  ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(review.userImage), // Assuming userImage is an asset path
              radius: 24.0,
            ),
            SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    review.userName,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.0),
                  RatingBarIndicator(
                    rating: review.rating,
                    itemBuilder: (context, index) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    itemCount: 5,
                    itemSize: 20.0,
                    direction: Axis.horizontal,
                  ),
                  SizedBox(height: 8.0),
                  Text(review.reviewText),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _showReviewModal(BuildContext context) async {
  double rating = 0.0;
  TextEditingController reviewController = TextEditingController();
  List<String> images = []; // Use List<String> for storing image URLs or asset paths
  String? productId;
  String? customerId;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      images.add(pickedFile.path); // Store the image path as String
    }
  }

  void _removeImage(int index) {
    images.removeAt(index);
  }

  void _submitReview(BuildContext context) async {
    // Check if customerId is null
    if (customerId == null) {
      // Navigate to LoginPage if customerId is null
      Navigator.pushReplacementNamed(context, '/LoginPage1');
      return; // Exit function
    }

    // Your existing submission logic
    const String apiUrl = 'https://clacostoreapi.onrender.com/getreview';
    const String reviewStatus = ''; // Add relevant review status if needed

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'CustomerId': customerId,
        'ProductCode': productId,
        'reviewstatus': reviewStatus,
        'Description': reviewController.text,
        'Images': images, // Send images as a list of paths or URLs
      }),
    );

    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['message'] == 'datan Inserted Successfully') {
        // Handle success, e.g., show a success message or refresh the review list
        Navigator.of(context).pop(); // Close the modal
        Navigator.pushReplacementNamed(context, '/ProductDetails'); // Navigate to ProductDetails page
      } else {
        // Handle other responses
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(' ${responseData['message']}')),
        );
      }
    } else {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit review. Please try again later.')),
      );
    }
  }


  SharedPreferences prefs = await SharedPreferences.getInstance();
  customerId = prefs.getString('customerId');
  productId = prefs.getString('ProductCode');

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom, // Adjust bottom padding based on keyboard height
            ),
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Write a Review',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    RatingBar.builder(
                      initialRating: 0,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (ratingValue) {
                        setState(() {
                          rating = ratingValue;
                        });
                      },
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: reviewController,
                      decoration: InputDecoration(
                        hintText: 'Enter your review',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 4,
                    ),
                    SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      children: [
                        ...List.generate(images.length, (index) {
                          return Stack(
                            children: [
                              Image.network(
                                images[index],
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                              Positioned(
                                right: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _removeImage(index);
                                    });
                                  },
                                  child: Container(
                                    color: Colors.black54,
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                        GestureDetector(
                          onTap: () async {
                            await _pickImage();
                            setState(() {});
                          },
                          child: Container(
                            width: 50,
                            height: 50,
                            color: Colors.white,
                            child: Icon(Icons.add_a_photo),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {
                          _submitReview(context); // Call function to submit the review
                        },
                        child: Text('Submit',style: TextStyle(color: Colors.pink),),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}