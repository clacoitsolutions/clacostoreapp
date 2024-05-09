import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddAddressFormPage extends StatelessWidget {
  const AddAddressFormPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Shopping',
          style: TextStyle(
            color: Colors.white, // Text color white
          ),
        ),
        backgroundColor: Colors.pink, // Background color blue
        iconTheme: IconThemeData(color: Colors.white), // Set back arrow color to white
        actions: [
          IconButton(
            onPressed: () {
              // Implement search functionality
            },
            icon: Icon(Icons.search),
            color: Colors.white,
          ),
          IconButton(
            onPressed: () {
              // Implement add-to-cart functionality
            },
            icon: Icon(Icons.shopping_cart),
            color: Colors.white,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Name Field
              TextField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Enter Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12), // Adding some spacing between fields
              // Mobile Number Field
              TextField(
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Enter Mobile Number',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12), // Adding some spacing between fields
              // Pincode and Use My Location
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Pincode',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: 12), // Adding some spacing between fields
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Implement action to use current location
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink[500], // Set button background color to pink
                    ),
                    child: Text(
                      'Use My Location',
                      style: TextStyle(color: Colors.white), // Set text color to white
                    ),
                  ),





                ],
              ),
              SizedBox(height: 12), // Adding some spacing between fields
              // State Dropdown and City Field
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Select State',
                        border: OutlineInputBorder(),
                      ),
                      items: <String>[
                        'Bihar',
                        'Utter Pardesh',
                        'State 3',
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        // Handle state selection
                      },
                    ),
                  ),
                  SizedBox(width: 12), // Adding some spacing between fields
                  const Expanded(
                    child: TextField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'City',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12), // Adding some spacing between fields
              // House Number Field
              const TextField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'House No.',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12), // Adding some spacing between fields
              // Road Name Field
              const TextField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Road Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12), // Adding some spacing between fields


              // Alternative Phone Number Field
              const TextField(
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Alternative Phone Number',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12), // Adding some spacing between fields

              const TextField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Add Nearby Famous Shop/Mall/Landmark',
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 12), // Row for buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Home button with home icon and text
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 10.0),
                        child: IconButton(
                          onPressed: () {
                          },
                          icon: Icon(Icons.home),
                        ),
                      ),
                      Text('Home'),
                    ],
                  ),

                  // Work button with work icon and text
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 10.0),
                        child: IconButton(
                          onPressed: () {
                            // TODO: Implement functionality for work icon button
                          },
                          icon: Icon(Icons.work),
                        ),
                      ),
                      Text('Work'),
                    ],
                  ),

                  // Another icon button
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 10.0),
                        child: IconButton(
                          onPressed: () {
                            // TODO: Implement functionality for another icon button
                          },
                          icon: Icon(Icons.ac_unit), // Corrected the icon name to demonstrate
                        ),
                      ),
                      Text('Another'),
                    ],
                  ),
                ],
              ),


              SizedBox(height: 12), // Adding some spacing between fields
              // Save Address Button
              ElevatedButton(
                onPressed: () {
                  // TODO: Implement save address functionality
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange, // Set button color to orange
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2), // Set border radius to 2 pixels
                  ),
                ),
                child: Text('submit'),
              ),
              // Adding some spacing between fields

              // Add other form fields below if needed
            ],
          ),
        ),
      ),
    );
  }
}