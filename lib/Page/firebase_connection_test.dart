// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
//
// final CollectionReference _homeProductSections =
// FirebaseFirestore.instance.collection('HomeProductSections');
//
// class Firebased extends StatefulWidget {
//   @override
//   _FirebasedState createState() => _FirebasedState();
// }
//
// class _FirebasedState extends State<Firebased> {
//   Map<String, dynamic>? userData;
//   String? userId;
//
//   @override
//   void initState() {
//     getuserByid();
//     super.initState();
//
//   }
//
//   Future<void> getuserByid() async {
//     final String id = "QpT5aA5TllDsfyncvtnM";
//     try {
//       final DocumentSnapshot doc = await _homeProductSections.doc(id).get();
//       setState(() {
//         userData = doc.data() as Map<String, dynamic>?;
//         userId = doc.id;
//       });
//       print(doc.data);
//       print(doc.id);
//       print(doc.exists);
//     } catch (e) {
//       print("Error fetching document: $e");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Home Product Sections"),
//       ),
//       body: userData == null
//           ? Center(child: CircularProgressIndicator())
//           : Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Document ID: $userId'),
//             Text('Data: $userData'),
//           ],
//         ),
//       ),
//     );
//   }
// }
//

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Firebased extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Firebase Connection Test'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              // Example of checking Firebase connection by fetching data
              try {
                // Replace with your Firebase service usage (e.g., Firestore query)
                var snapshot = await FirebaseFirestore.instance.collection('test').doc('documentId').get();
                print('Firebase connection successful!');
                print('Document data: ${snapshot.data()}');
              } catch (e) {
                print('Error connecting to Firebase: $e');
              }
            },
            child: Text('Check Firebase Connection'),
          ),
        ),
      ),
    );
  }
}




//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
//
// class Firebased extends StatefulWidget {
//   @override
//   _FirebasedState createState() => _FirebasedState();
// }
//
// class _FirebasedState extends State<Firebased> {
//   final CollectionReference _homeProductSections =
//   FirebaseFirestore.instance.collection('HomeProductSections');
//
//   List<Map<String, dynamic>> sections = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _getHomeProductSections();
//   }
//
//   Future<void> _getHomeProductSections() async {
//     try {
//       QuerySnapshot querySnapshot = await _homeProductSections.get();
//       List<Map<String, dynamic>> fetchedSections = [];
//       querySnapshot.docs.forEach((doc) {
//         fetchedSections.add({
//           'id': doc['id'],
//           'name': doc['name'],
//         });
//       });
//       setState(() {
//         sections = fetchedSections;
//       });
//     } catch (e) {
//       print("Error fetching data: $e");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Home Product Sections"),
//       ),
//       body: sections.isEmpty
//           ? Center(child: CircularProgressIndicator())
//           : ListView.builder(
//         itemCount: sections.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Text('Name: ${sections[index]['name']}'),
//             subtitle: Text('ID: ${sections[index]['id']}'),
//           );
//         },
//       ),
//     );
//   }
// }
//
