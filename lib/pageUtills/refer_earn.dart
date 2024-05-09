import 'package:flutter/material.dart';


class ReferPage extends StatelessWidget {
  const ReferPage({key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 20.0),
                const Text(
                  'Refer and earn',
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                const SizedBox(height: 20.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/gift_design.png',
                      height: 400.0,
                      width: 400.0,
                    ),
                    const SizedBox(height: 20.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Your Refer Code',
                          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        const SizedBox(height: 15.0),
                        SizedBox(
                          width: 200.0,
                          height: 60.0,
                          child: Container(
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                                width: 2.0,

                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                const Text(
                                  'ABC123',
                                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black),
                                ),
                                const SizedBox(width: 10.0),
                                IconButton(
                                  onPressed: () {
                                    // Implement copy functionality
                                  },
                                  icon: const Icon(Icons.content_copy),
                                  color: Colors.black,
                                  tooltip: 'Copy Referral Code',
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        const Text(
                          'Share your referral code with your\nfriends and get benefits.',
                          style: TextStyle(fontSize: 16.0, color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20.0),
                        SizedBox(
                          width: 300.0,
                          child: ElevatedButton(
                            onPressed: () {
                              // Implement referral logic
                            },
                            child: const Text('Refer Now'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
