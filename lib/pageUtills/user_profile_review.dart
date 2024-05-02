import 'package:flutter/material.dart';
class StarRating extends StatefulWidget {
  @override
  _StarRatingState createState() => _StarRatingState();
}

class _StarRatingState extends State<StarRating> {
  int _rating = 0;

  void _updateRating(int index) {
    setState(() {
      if (_rating == index + 1) {
        _rating = 0; // If the tapped star is already filled, reset rating to 0
      } else {
        _rating = index + 1; // Otherwise, fill stars up to the tapped index
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 5),
      child: Column(
        children: [
          Row(
            children: [
              for (int i = 0; i < 5; i++)
                GestureDetector(
                  onTap: () => _updateRating(i),
                  child: Icon(
                    i < _rating ? Icons.star : Icons.star_border,
                    color: i < _rating ? Colors.yellow : Colors.black54,
                    size: 45,
                  ),
                ),



            ],
          ),
          if (_rating > 0)
            GestureDetector(
              onTap: () {
                _showReviewModal(context); // Call the function to show the modal
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center, // Center the content horizontally
                children: [
                  Text(
                    'Write a Review',
                    textAlign: TextAlign.center, // Center the text within the container
                    style: TextStyle(color: Colors.blue), // Set text color to blue
                  ),
                  Icon(Icons.edit, color: Colors.blue), // Add an edit icon
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _showReviewModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom, // Adjust bottom padding based on keyboard height
          ),
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                height: 300,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Write a Review',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Enter your review',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 4,
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            // Implement submission logic here
                            Navigator.pop(context);
                          },
                          child: Text('Submit'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class review extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(  appBar: AppBar(
      title: Text(' My Review'),
      actions: [
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            // Implement search functionality
          },
        ),
        Stack(
          children: [
            IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                // Implement cart functionality
              },
            ),
            Positioned(
              right: 0,
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
                  '10', // Replace '10' with the actual item count
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

      body: Container(
        padding: EdgeInsets.only(top: 5.0),

        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 5, bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5), // Shadow color
                      spreadRadius: 2, // Spread radius
                      blurRadius: 5, // Blur radius
                      offset: Offset(0, 3), // Changes position of shadow
                    ),
                  ],
                ),
                // Add margin only at the top
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left part with image
                    Container(
                      height: 60, // Adjust height as needed
                      width: 100,
                      margin: EdgeInsets.only(top: 20,bottom: 20), // Adjust width as needed
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: AssetImage('assets/images/sliderimg1.jpg'), // Provide your image path here
                          fit: BoxFit.cover, // Ensures the image covers the entire container
                        ),
                      ),
                    ),

                    SizedBox(width: 10), // Add spacing between image and title
                    // Right part with title and star rating
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Rate Product',
                            style: TextStyle(fontSize: 15, color: Colors.grey),
                          ),
                          Text(
                            'Product1 Name', // Your subtitle text here
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          StarRating(), // Assuming you've defined a StarRating widget
                          SizedBox(height: 5), // Add some space between star rating and write a review

                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 5, bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5), // Shadow color
                      spreadRadius: 2, // Spread radius
                      blurRadius: 5, // Blur radius
                      offset: Offset(0, 3), // Changes position of shadow
                    ),
                  ],
                ),
                // Add margin only at the top
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left part with image
                    Container(
                      height: 60, // Adjust height as needed
                      width: 100,
                      margin: EdgeInsets.only(top: 20,bottom: 20), // Adjust width as needed
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: AssetImage('assets/images/sliderimg1.jpg'), // Provide your image path here
                          fit: BoxFit.cover, // Ensures the image covers the entire container
                        ),
                      ),
                    ),

                    SizedBox(width: 10), // Add spacing between image and title
                    // Right part with title and star rating
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Rate Product',
                            style: TextStyle(fontSize: 15, color: Colors.grey),
                          ),
                          Text(
                            'Product1 Name', // Your subtitle text here
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          StarRating(), // Assuming you've defined a StarRating widget
                          SizedBox(height: 5), // Add some space between star rating and write a review

                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 5, bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5), // Shadow color
                      spreadRadius: 2, // Spread radius
                      blurRadius: 5, // Blur radius
                      offset: Offset(0, 3), // Changes position of shadow
                    ),
                  ],
                ),
                // Add margin only at the top
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left part with image
                    Container(
                      height: 60, // Adjust height as needed
                      width: 100,
                      margin: EdgeInsets.only(top: 20,bottom: 20), // Adjust width as needed
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: AssetImage('assets/images/sliderimg1.jpg'), // Provide your image path here
                          fit: BoxFit.cover, // Ensures the image covers the entire container
                        ),
                      ),
                    ),

                    SizedBox(width: 10), // Add spacing between image and title
                    // Right part with title and star rating
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Rate Product',
                            style: TextStyle(fontSize: 15, color: Colors.grey),
                          ),
                          Text(
                            'Product1 Name', // Your subtitle text here
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          StarRating(), // Assuming you've defined a StarRating widget
                          SizedBox(height: 5), // Add some space between star rating and write a review

                        ],
                      ),
                    ),
                  ],
                ),
              ),





              // Add more containers or widgets here as needed

            ],
          ),
        ),
      ),


    );
  }
}


