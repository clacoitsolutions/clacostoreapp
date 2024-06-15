import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firestore Example',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final CollectionReference _homeProductSections =
  FirebaseFirestore.instance.collection('HomeProductSections');

  Future<List<HomeProductSection>> _getHomeProductSections() async {
    try {
      QuerySnapshot snapshot = await _homeProductSections.get();

      // Log fetched documents and data
      print("Number of documents: ${snapshot.docs.length}");
      for (var doc in snapshot.docs) {
        print("Document ID: ${doc.id}");
        print("Data: ${doc.data()}");
      }

      return snapshot.docs.map<HomeProductSection>((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
        return HomeProductSection(
          id: document.id, // Firestore document ID
          name: data['name'] ?? '', // Name from Firestore
        );
      }).toList();
    } catch (e) {
      // Handle errors gracefully
      print("Error fetching data: $e");
      return []; // Return an empty list in case of error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Product Sections"),
      ),
      body: FutureBuilder<List<HomeProductSection>>(
        future: _getHomeProductSections(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          List<HomeProductSection> sections = snapshot.data!;

          return ListView.builder(
            itemCount: sections.length,
            itemBuilder: (context, index) {
              HomeProductSection section = sections[index];
              return ListTile(
                title: Text('${section.name} (ID: ${section.id})'),
              );
            },
          );
        },
      ),
    );
  }
}

class HomeProductSection {
  final String id;
  final String name;

  HomeProductSection({required this.id, required this.name});

// Constructor is no longer needed as we're accessing data directly
}