import 'package:flutter/material.dart';

class WishlistPage extends StatefulWidget {
  @override
  _WishlistPageState createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.withOpacity(0.05), // Set the background color to light blue with opacity

      appBar: AppBar(
        backgroundColor: Colors.blue, // Set the app bar background color to blue
        // shape: Border.all(width: 0), // Set border radius to none
        title: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white, // Set the color of the icon to white
              ),
              onPressed: () {
                // Handle back button click event
                Navigator.of(context).pop();
              },
            ),
            // SizedBox(width: 10), // Add space between the icon and logo
            // Image.asset(
            //   'assets/logo.png', // Replace 'assets/logo.png' with your logo image path
            //   width: 32, // Adjust the width of the logo as needed
            //   height: 32, // Adjust the height of the logo as needed
            // ),
            // SizedBox(width: 10), // Add space between the logo and text
            Text(
              'Logo', // Replace 'Your Text' with your desired text
              style: TextStyle(
                color: Colors.white, // Set the color of the text to white
                fontSize: 16, // Adjust the font size of the text as needed
              ),
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.shopping_cart_outlined,
              color: Colors.white, // Set the color of the icon to white
            ),
            onPressed: () {
              // Handle cart icon click event
              // Add your cart logic here
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20), // Adjust the padding value
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10), // Add left padding
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'My Wishlist:', // Adjust the text as needed
                            style: TextStyle(
                              color: Colors.black, // Set text color
                              fontWeight: FontWeight.bold, // Make text bold
                              fontSize: 20, // Set font size to 20
                            ),
                          ),
                          SizedBox(height: 5), // Add space between text and icon
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center, // Align children vertically at the center
                            children: <Widget>[
                              Icon(
                                Icons.lock,
                                color: Colors.grey,
                                size: 15, // Set icon size to 15
                              ),
                              SizedBox(width: 5), // Add space between icon and text
                              Text(
                                "Private - ",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                "5 items",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20), // Add minimum space below the row
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Stack(
                          children: [
                            Container(
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
                                  Padding(
                                    padding: EdgeInsets.only(left: 10), // Adjust the left padding as needed
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
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
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10), // Add spacing between the star rating and the button
                                        Padding(
                                          padding: EdgeInsets.only(right: 10), // Add padding only on the right side
                                          child: Container(
                                            width: double.infinity, // Make the button full width
                                            padding: EdgeInsets.symmetric(horizontal: 10), // Add horizontal padding
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey, // Border color
                                              ),
                                              borderRadius: BorderRadius.circular(2), // Border radius
                                            ),
                                            child: TextButton(
                                              onPressed: () {
                                                // Add your button logic here
                                              },
                                              child: Text(
                                                'Add to Cart',
                                                style: TextStyle(
                                                  color: Colors.blue, // Text color of the button
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10), // Add spacing between the star rating and the button


                                      ],
                                    ),
                                  ),

                                ],
                              ),
                            ),
                            Positioned(
                              top: 10,
                              right: 10,
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.delete_outline,
                                    color: Colors.red, // Set the color of the icon to red
                                  ),
                                  onPressed: () {
                                    // Add your favorite button onPressed logic here
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        flex: 1,
                        child: Stack(
                          children: [
                            Container(
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
                                  Padding(
                                    padding: EdgeInsets.only(left: 10), // Adjust the left padding as needed
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Text(
                                        //   'Boys Shoes',
                                        //   style: TextStyle(
                                        //     fontSize: 16,
                                        //     fontWeight: FontWeight.bold,
                                        //   ),
                                        // ),
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
                                        SizedBox(height: 10), // Add spacing between the star rating and the button
                                        Padding(
                                          padding: EdgeInsets.only(right: 10), // Add padding only on the right side
                                          child: Container(
                                            width: double.infinity, // Make the button full width
                                            padding: EdgeInsets.symmetric(horizontal: 10), // Add horizontal padding
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey, // Border color
                                              ),
                                              borderRadius: BorderRadius.circular(2), // Border radius
                                            ),
                                            child: TextButton(
                                              onPressed: () {
                                                // Add your button logic here
                                              },
                                              child: Text(
                                                'Add to Cart',
                                                style: TextStyle(
                                                  color: Colors.blue, // Text color of the button
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10), // Add spacing between the star rating and the button

                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              top: 10,
                              right: 10,
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.delete_outline,
                                    color: Colors.red, // Set the color of the icon to red
                                  ),
                                  onPressed: () {
                                    // Add your favorite button onPressed logic here
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Stack(
                          children: [
                            Container(
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
                                  Padding(
                                    padding: EdgeInsets.only(left: 10), // Adjust the left padding as needed
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Text(
                                        //   'Girls Shoes',
                                        //   style: TextStyle(
                                        //     fontSize: 16,
                                        //     fontWeight: FontWeight.bold,
                                        //   ),
                                        // ),
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
                                        SizedBox(height: 10), // Add spacing between the star rating and the button
                                        Padding(
                                          padding: EdgeInsets.only(right: 10), // Add padding only on the right side
                                          child: Container(
                                            width: double.infinity, // Make the button full width
                                            padding: EdgeInsets.symmetric(horizontal: 10), // Add horizontal padding
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey, // Border color
                                              ),
                                              borderRadius: BorderRadius.circular(2), // Border radius
                                            ),
                                            child: TextButton(
                                              onPressed: () {
                                                // Add your button logic here
                                              },
                                              child: Text(
                                                'Add to Cart',
                                                style: TextStyle(
                                                  color: Colors.blue, // Text color of the button
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10), // Add spacing between the star rating and the button

                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              top: 10,
                              right: 10,
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.delete_outline,
                                    color: Colors.red, // Set the color of the icon to red
                                  ),
                                  onPressed: () {
                                    // Add your favorite button onPressed logic here
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        flex: 1,
                        child: Stack(
                          children: [
                            Container(
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
                                  Padding(
                                    padding: EdgeInsets.only(left: 10), // Adjust the left padding as needed
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Text(
                                        //   'Boys Shoes',
                                        //   style: TextStyle(
                                        //     fontSize: 16,
                                        //     fontWeight: FontWeight.bold,
                                        //   ),
                                        // ),
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
                                        SizedBox(height: 10), // Add spacing between the star rating and the button
                                        Padding(
                                          padding: EdgeInsets.only(right: 10), // Add padding only on the right side
                                          child: Container(
                                            width: double.infinity, // Make the button full width
                                            padding: EdgeInsets.symmetric(horizontal: 10), // Add horizontal padding
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey, // Border color
                                              ),
                                              borderRadius: BorderRadius.circular(2), // Border radius
                                            ),
                                            child: TextButton(
                                              onPressed: () {
                                                // Add your button logic here
                                              },
                                              child: Text(
                                                'Add to Cart',
                                                style: TextStyle(
                                                  color: Colors.blue, // Text color of the button
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10), // Add spacing between the star rating and the button

                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              top: 10,
                              right: 10,
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.delete_outline,
                                    color: Colors.red, // Set the color of the icon to red
                                  ),
                                  onPressed: () {
                                    // Add your favorite button onPressed logic here
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20), // Add minimum space below the row

              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Stack(
                      children: [
                        Container(
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
                              Padding(
                                padding: EdgeInsets.only(left: 10), // Adjust the left padding as needed
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Text(
                                    //   'Girls Shoes',
                                    //   style: TextStyle(
                                    //     fontSize: 16,
                                    //     fontWeight: FontWeight.bold,
                                    //   ),
                                    // ),
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
                                    SizedBox(height: 10), // Add spacing between the star rating and the button
                                    Padding(
                                      padding: EdgeInsets.only(right: 10), // Add padding only on the right side
                                      child: Container(
                                        width: double.infinity, // Make the button full width
                                        padding: EdgeInsets.symmetric(horizontal: 10), // Add horizontal padding
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey, // Border color
                                          ),
                                          borderRadius: BorderRadius.circular(2), // Border radius
                                        ),
                                        child: TextButton(
                                          onPressed: () {
                                            // Add your button logic here
                                          },
                                          child: Text(
                                            'Add to Cart',
                                            style: TextStyle(
                                              color: Colors.blue, // Text color of the button
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10), // Add spacing between the star rating and the button

                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.delete_outline,
                                color: Colors.red, // Set the color of the icon to red
                              ),
                              onPressed: () {
                                // Add your favorite button onPressed logic here
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    flex: 1,
                    child: Stack(
                      children: [
                        Container(
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
                              Padding(
                                padding: EdgeInsets.only(left: 10), // Adjust the left padding as needed
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Text(
                                    //   'Boys Shoes',
                                    //   style: TextStyle(
                                    //     fontSize: 16,
                                    //     fontWeight: FontWeight.bold,
                                    //   ),
                                    // ),
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
                                    SizedBox(height: 10), // Add spacing between the star rating and the button
                                    Padding(
                                      padding: EdgeInsets.only(right: 10), // Add padding only on the right side
                                      child: Container(
                                        width: double.infinity, // Make the button full width
                                        padding: EdgeInsets.symmetric(horizontal: 10), // Add horizontal padding
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey, // Border color
                                          ),
                                          borderRadius: BorderRadius.circular(2), // Border radius
                                        ),
                                        child: TextButton(
                                          onPressed: () {
                                            // Add your button logic here
                                          },
                                          child: Text(
                                            'Add to Cart',
                                            style: TextStyle(
                                              color: Colors.blue, // Text color of the button
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10), // Add spacing between the star rating and the button

                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.delete_outline,
                                color: Colors.red, // Set the color of the icon to red
                              ),
                              onPressed: () {
                                // Add your favorite button onPressed logic here
                              },
                            ),
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
    );
  }
}
