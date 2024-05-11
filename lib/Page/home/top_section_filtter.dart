import 'package:flutter/material.dart';
import '../filter_page.dart';
import '../short_by.dart';

Widget topSectionFilter(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      const Text(
        "500+ items",
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(width: 20),
      ElevatedButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return SortingPage(); // Show the SortingPage in the modal bottom sheet
            },
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        child: Row(
          children: [
            Text(
              'Short',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            Icon(
              Icons.arrow_drop_down,
              color: Colors.black,
            ),
          ],
        ),
      ),

      ElevatedButton(
        onPressed: () {
          Navigator.push(
            context, // Ensure context is available
            MaterialPageRoute(builder: (context) => Filter()),
          );
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        child: const Row(
          children: [
            Icon(Icons.filter_list),
            SizedBox(width: 4),
            Text('Filter', style: TextStyle(fontSize: 14)),
          ],
        ),
      ),
    ],
  );
}