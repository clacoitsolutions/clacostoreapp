
import 'package:flutter/material.dart';

import 'common_appbar.dart';

class FAQPage extends StatefulWidget {
  @override
  _FAQPageState createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  List<FAQItem> faqItems = [
    FAQItem(
      question: 'What is claco.in?',
      answer: [
        'claco.in is a premier online marketplace offering a wide range of products, from electronics to fashion, home essentials, and more. Our goal is to provide our customers with high-quality products at competitive prices.'
      ],
    ),
    FAQItem(
      question: 'How do I create an account on claco.in?',
      answer: [
        '1. Click on the "Sign Up" button on the top right corner of our homepage.',
        '2. Fill in your details, including your name, email, and password.',
        '3. Click "Submit" and verify your email to complete the registration process.'
      ],
    ),
    FAQItem(
      question: 'How can I place an order?',
      answer: [
        '1. Browse our categories or use the search bar to find your desired product.',
        '2. Click on the product to view its details and select the quantity.',
        '3. Click "Add to Cart."',
        '4. When you are ready to checkout, click on the cart icon and follow the checkout process.'
      ],
    ),
    FAQItem(
      question: 'What payment methods do you accept?',
      answer: [
        'We accept various payment methods including:',
        '1. Credit/Debit Cards (Visa, MasterCard, American Express)',
        '2. Net Banking',
        '3. UPI',
        '4. Wallets (Paytm, Google Pay, etc.)',
        '5. Cash on Delivery (selected locations)'
      ],
    ),
    FAQItem(
      question: 'How can I track my order?',
      answer: [
        'Once your order is shipped, you will receive a tracking number via email. You can use this number to track your order on our website under "Track Order" or directly on the courier'
      ],
    ),
    FAQItem(
      question: 'What is your return policy?',
      answer: [
        'We offer a 7-day return policy on Electronic item, cloths and footwears.'
      ],
    ),
    FAQItem(
      question: 'How can I contact customer service?',
      answer: [
        'You can reach our customer service team through:',
        'Email: support@claco.in',
        'Phone: +91-123-456-7890',
        'Live Chat: Available on our website during business hours.'
      ],
    ),
    FAQItem(
      question: 'Do you offer international shipping?',
      answer: [
        'Currently, we only ship within India. We are working on expanding our services to international locations soon. Stay tuned for updates!'
      ],
    ),
    FAQItem(
      question: 'Are my personal details secure on claco.in?',
      answer: [
        'Yes, we take your privacy and security seriously. We use advanced encryption technologies to protect your personal information. For more details, please read our Privacy Policy.'
      ],
    ),
    FAQItem(
      question: 'Can I change or cancel my order after it has been placed?',
      answer: [
        'Orders can be modified or canceled within one hour of placing them. After this window, we begin processing your order. Please contact our customer service team immediately if you need to make changes.'
      ],
    ),
    FAQItem(
      question: 'What if I receive a damaged or incorrect product?',
      answer: [
        'If you receive a damaged or incorrect product, please contact our customer service team within 48 hours of delivery. We will arrange for a replacement or refund as per our policy.'
      ],
    ),
    FAQItem(
      question: 'How can I stay updated with the latest offers and products?',
      answer: [
        'Subscribe to our newsletter by entering your email at the bottom of our homepage. Follow us on our social media channels to get the latest updates on new arrivals, exclusive offers, and promotions.'
      ],
    ),
    // Add more FAQ items here
  ];

  // Search functionality
  List<FAQItem> displayedItems = []; // List to hold items for display
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    displayedItems = faqItems; // Initialize displayedItems with all items
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: 'Question & Answer'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            TextField(
              controller: searchController,
              decoration: const InputDecoration(
                hintText: 'Search FAQs',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                _onSearchChanged(value); // Update displayedItems on search change
              },
            ),
            SizedBox(height: 20),

            // FAQ Categories
            Expanded(
              child: ListView.builder(
                itemCount: displayedItems.length, // Use displayedItems length
                itemBuilder: (context, index) {
                  return FAQItemWidget(item: displayedItems[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to filter items based on search input
  void _onSearchChanged(String searchText) {
    setState(() {
      displayedItems = faqItems.where((item) {
        // Search in the question or answer
        return item.question.toLowerCase().contains(searchText.toLowerCase()) ||
            item.answer.any((answer) =>
                answer.toLowerCase().contains(searchText.toLowerCase()));
      }).toList();
    });
  }
}

// FAQ Item Data Model
class FAQItem {
  String question;
  List<String> answer;

  FAQItem({required this.question, required this.answer});
}

// FAQ Item Widget
class FAQItemWidget extends StatefulWidget {
  final FAQItem item;

  FAQItemWidget({required this.item});

  @override
  _FAQItemWidgetState createState() => _FAQItemWidgetState();
}

class _FAQItemWidgetState extends State<FAQItemWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      // color: Colors.pink[50], // Background color for the entire card
      child: ExpansionTile(
        title: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            // color: Colors.pink[100], // Background color for the question
          ),
          child: Text(
            widget.item.question,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        initiallyExpanded: false,
        onExpansionChanged: (expanded) {
          setState(() {
            _isExpanded = expanded;
          });
        },
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
              widget.item.answer.map((answer) => Text(answer)).toList(),
            ),
          ),
        ],
      ),
    );
  }
}