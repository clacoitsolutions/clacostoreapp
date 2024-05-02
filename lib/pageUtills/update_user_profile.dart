import 'package:flutter/material.dart';

class UpdateUserProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  // Add your cart functionality here
                },
              ),
              Positioned(
                right: 1,
                top: 5,
                child: Container(
                  margin: EdgeInsets.only(left: 10.0),
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.white,
                      width: 1,
                    ),
                  ),
                  constraints: BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    '10',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Add your search functionality here
            },
          ),
        ],
      ),
      body: Container( // Wrap the body with a Container
        color: Colors.white, // Set the background color to white
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 200.0,
                color: Colors.pink,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 100.0,
                      height: 100.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 2.0,
                        ),
                      ),
                      child: ClipOval(

                        child: Image.asset('assets/images/updateprofilemen.png'),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(25.0),
                      child: Text(
                        'Or',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      width: 100.0,
                      height: 100.0,

                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 2.0,
                        ),
                      ),
                      child: ClipOval(
                        child: Image.asset('assets/images/updateprofileimg2.png'),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 320.0,
                color: Colors.white,
                padding: EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'First Name',
                        labelText: 'First Name',
                        labelStyle: TextStyle(color: Colors.pink),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.pink),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Last Name',
                        labelText: 'Last Name',
                        labelStyle: TextStyle(color: Colors.pink),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.pink),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Add your submit button functionality here
                      },
                      child: Text('Submit', style: TextStyle(
                        color: Colors.white,
                      ),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:  Colors.pink, // Set button color to pink
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  height: 180.0,
                  color: Colors.white,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey), // Add bottom border
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.only(left: 10.0),
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Mobile Number',
                                    labelText: 'Mobile Number',
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            TextButton(
                              onPressed: () {
                                // Add your button functionality here
                              },
                              child: Text(
                                'Update',
                                style: TextStyle(color: Colors.indigoAccent),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.only(left: 10.0),
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Email ID',
                                    labelText: 'Email ID',
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            TextButton(
                              onPressed: () {
                                // Add your button functionality here
                              },
                              child: Text(
                                'Verify',
                                style: TextStyle(color: Colors.indigoAccent),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0), // Adjust the horizontal padding as needed
                child: Container(
                  height: 200.0,
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 1, // Height of the line under the heading
                        color: Colors.grey,
                        // Line stretches across the container
                      ),
                      SizedBox(height: 8), // Add spacing between the line and the text
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0), // Adjust left padding as needed
                        child: Text(
                          'Deactivate Account',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
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
