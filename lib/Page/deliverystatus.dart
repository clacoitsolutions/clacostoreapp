// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:another_stepper/another_stepper.dart';
//
// // void main() {
// //   runApp(const MyApp());
// // }
// //
// // class MyApp extends StatelessWidget {
// //   const MyApp({Key? key}) : super(key: key);
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'Order Tracking Example',
// //       theme: ThemeData(
// //         primarySwatch: Colors.green,
// //       ),
// //       home: const Deliverystatus(),
// //     );
// //   }
// // }
//
// enum OrderStatus {
//   placed,
//   shipped,
//   ontheway,
//   outForDelivery,
//   delivered,
//   replaced,
//   refunded,
//   cancelled,
//   cancelledProduct
// }
//
// class _MyHomePageState extends State<Deliverystatus> {
//   OrderStatus _currentStatus = OrderStatus.placed;
//
//   final Map<OrderStatus, String> _statusDescriptions = {
//     OrderStatus.placed: "Your order has been placed.",
//     OrderStatus.shipped: "Your order has been shipped.",
//     OrderStatus.ontheway: "Your order has On the Way.",
//     OrderStatus.outForDelivery: "Your order is out for delivery.",
//     OrderStatus.delivered: "Your order has been delivered.",
//     OrderStatus.replaced: "Your order has been replaced.",
//     OrderStatus.refunded: "Your order has been refunded.",
//     OrderStatus.cancelled: "Your order has been cancelled.",
//     OrderStatus.cancelledProduct: "Product has been cancelled."
//   };
//
//   final Map<OrderStatus, String?> _statusDates = {
//     OrderStatus.placed: "Fri, 25th Mar '22 - 10:47pm",
//     OrderStatus.shipped: "Sun, 27th Mar '22 - 10:19am",
//     OrderStatus.ontheway: "Tue, 29th Mar '22 - 7:00pm",
//     OrderStatus.outForDelivery: "Tue, 29th Mar '22 - 5:00pm",
//     OrderStatus.delivered: "Thu, 31th Mar '22 - 3:58pm",
//     OrderStatus.replaced: "Fri, 1st Apr '22 - 2:30pm",
//     OrderStatus.refunded: "Sat, 2nd Apr '22 - 11:15am",
//     OrderStatus.cancelled: "Mon, 3rd Apr '22 - 9:45am",
//     OrderStatus.cancelledProduct: "Tue, 4th Apr '22 - 1:00pm"
//   };
//
//   // Track the sequence of statuses that have been shown
//   List<OrderStatus> _completedStatuses = [];
//
//   int _currentStep = 0;
//
//   void _changeStatus(OrderStatus status) {
//     setState(() {
//       _currentStatus = status;
//       _currentStep = OrderStatus.values.indexOf(status);
//       if (!_completedStatuses.contains(status)) {
//         _completedStatuses.add(status); // Add the status to the completed list
//       }
//     });
//   }
//
//   void _updateOrderStatus() {
//     // Define the sequence of statuses and their delays
//     List<MapEntry<OrderStatus, Duration>> statusSequence = [
//       MapEntry(OrderStatus.placed, const Duration(seconds: 3)),
//       MapEntry(OrderStatus.shipped, const Duration(seconds: 3)),
//       MapEntry(OrderStatus.ontheway, const Duration(seconds: 3)),
//       MapEntry(OrderStatus.delivered, const Duration(seconds: 3)),
//       MapEntry(OrderStatus.replaced, const Duration(seconds: 3)),
//       MapEntry(OrderStatus.refunded, const Duration(seconds: 3)),
//
//       // MapEntry(OrderStatus.cancelled, const Duration(seconds: 9)),
//       // Add more statuses and delays if needed
//     ];
//
//     int currentIndex = 0;
//
//     // Use a timer to update the status gradually
//     Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (currentIndex < statusSequence.length) {
//         _changeStatus(statusSequence[currentIndex].key);
//         currentIndex++;
//       } else {
//         timer.cancel(); // Stop the timer when all statuses are displayed
//       }
//
//       // Check if the current status is 'cancelled' to stop further updates
//       if (_currentStatus == OrderStatus.cancelled ||
//           _currentStatus == OrderStatus.cancelledProduct) {
//         timer.cancel(); // Stop the timer for cancelled status
//       }
//     });
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _updateOrderStatus(); // Start the status update sequence
//   }
//
//   Widget _buildIconWidget(OrderStatus status) {
//     // Function to decide which icon to display based on status
//     if (_currentStatus == status) {
//       return Icon(Icons.check_circle, color: Colors.green);
//     } else if (_completedStatuses.contains(status)) {
//       return Icon(Icons.check_circle_outline, color: Colors.green);
//     } else if (status == OrderStatus.cancelled ||
//         status == OrderStatus.cancelledProduct) {
//       return Icon(Icons.cancel, color: Colors.red);
//     } else {
//       return Icon(Icons.radio_button_unchecked, color: Colors.grey);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // Define the sequence of statuses in _updateOrderStatus
//     List<OrderStatus> statusSequence = [
//       OrderStatus.placed,
//       OrderStatus.shipped,
//       OrderStatus.ontheway,
//       OrderStatus.outForDelivery,
//       // OrderStatus.cancelled,
//     ];
//
//     List<StepperData> stepData = statusSequence.map((status) {
//       return StepperData(
//         title: StepperText(
//           _statusDescriptions[status] ?? "",
//           textStyle: TextStyle(
//             color: _currentStatus == status ? Colors.green : Colors.black,
//             fontWeight:
//                 _currentStatus == status ? FontWeight.bold : FontWeight.normal,
//           ),
//         ),
//         subtitle: StepperText(
//           _statusDates[status] ?? "",
//           textStyle: TextStyle(
//             color: _currentStatus == status ? Colors.green : Colors.grey,
//           ),
//         ),
//         iconWidget: _buildIconWidget(status),
//       );
//     }).toList();
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Order Tracking"),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             children: [
//               AnimatedContainer(
//                 duration: const Duration(seconds: 1),
//                 child: AnotherStepper(
//                   stepperList: stepData,
//                   stepperDirection: Axis.vertical,
//                   activeBarColor: Colors.green,
//                   inActiveBarColor: Colors.grey[300]!,
//                   activeIndex: _currentStep,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class Deliverystatus extends StatefulWidget {
//   final String status; // Receive the status from OrderDetailsScreen
//
//   const Deliverystatus({Key? key, required this.status}) : super(key: key);
//
//   @override
//   State<Deliverystatus> createState() => _MyHomePageState();
// }
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:another_stepper/another_stepper.dart';

enum OrderStatus {
  placed,
  shipped,
  ontheway,
  outForDelivery,
  delivered,
  returned,
  refunded,
  cancelled,
  cancelledProduct
}

class Deliverystatus extends StatefulWidget {
  final String status; // Receive the status from OrderDetailsScreen

  const Deliverystatus({Key? key, required this.status}) : super(key: key);

  @override
  State<Deliverystatus> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Deliverystatus> {
  OrderStatus _currentStatus = OrderStatus.placed;

  final Map<OrderStatus, String> _statusDescriptions = {
    OrderStatus.placed: "Your order has been placed.",
    OrderStatus.shipped: "Your order has been shipped.",
    OrderStatus.ontheway: "Your order is on the way.",
    OrderStatus.outForDelivery: "Your order is out for delivery.",
    OrderStatus.delivered: "Your order has been delivered.",
    OrderStatus.returned: "Your order has been Return.",
    OrderStatus.refunded: "Your order has been refunded.",
    OrderStatus.cancelled: "Your order has been cancelled.",
    OrderStatus.cancelledProduct: "Product has been cancelled."
  };

  final Map<OrderStatus, String?> _statusDates = {
    OrderStatus.placed: "Fri, 25th Mar '22 - 10:47pm",
    OrderStatus.shipped: "Sun, 27th Mar '22 - 10:19am",
    OrderStatus.ontheway: "Tue, 29th Mar '22 - 7:00pm",
    OrderStatus.outForDelivery: "Tue, 29th Mar '22 - 5:00pm",
    OrderStatus.delivered: "Thu, 31th Mar '22 - 3:58pm",
    OrderStatus.returned: "Fri, 1st Apr '22 - 2:30pm",
    OrderStatus.refunded: "Sat, 2nd Apr '22 - 11:15am",
    OrderStatus.cancelled: "Mon, 3rd Apr '22 - 9:45am",
    OrderStatus.cancelledProduct: "Tue, 4th Apr '22 - 1:00pm"
  };

  // Track the sequence of statuses that have been shown
  List<OrderStatus> _completedStatuses = [];

  int _currentStep = 0;

  void _changeStatus(OrderStatus status) {
    setState(() {
      _currentStatus = status;
      _currentStep = OrderStatus.values.indexOf(status);
      if (!_completedStatuses.contains(status)) {
        _completedStatuses.add(status); // Add the status to the completed list
      }
    });
  }

  void _updateOrderStatus() {
    // Define the sequence of statuses and their delays
    List<MapEntry<OrderStatus, Duration>> statusSequence = [
      MapEntry(OrderStatus.placed, const Duration(seconds: 3)),
      MapEntry(OrderStatus.shipped, const Duration(seconds: 3)),
      MapEntry(OrderStatus.ontheway, const Duration(seconds: 3)),
      MapEntry(OrderStatus.delivered, const Duration(seconds: 3)),
      MapEntry(OrderStatus.returned, const Duration(seconds: 3)),
      MapEntry(OrderStatus.refunded, const Duration(seconds: 3)),

      MapEntry(OrderStatus.cancelled, const Duration(seconds: 9)),
      // Add more statuses and delays if needed
    ];

    int currentIndex = 0;

    // Use a timer to update the status gradually
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (currentIndex < statusSequence.length) {
        _changeStatus(statusSequence[currentIndex].key);
        currentIndex++;
      } else {
        timer.cancel(); // Stop the timer when all statuses are displayed
      }

      // Check if the current status is 'cancelled' to stop further updates
      if (_currentStatus == OrderStatus.cancelled ||
          _currentStatus == OrderStatus.cancelledProduct) {
        timer.cancel(); // Stop the timer for cancelled status
      }
    });
  }

  @override
  void initState() {
    super.initState();

    // Set the initial status based on the received value
    switch (widget.status) {
      case 'placed':
        _currentStatus = OrderStatus.placed;
        break;
      case 'packed': // Assuming "Packed" is a status
        _currentStatus = OrderStatus.shipped;
        break;
      case 'ontheway':
        _currentStatus = OrderStatus.ontheway;
        break;
      case 'delivered':
        _currentStatus = OrderStatus.delivered;
        break;
      case 'returned':
        _currentStatus = OrderStatus.returned;
        break;
      case 'cancelled':
        _currentStatus = OrderStatus.cancelled;
        break;
      default:
        _currentStatus = OrderStatus.placed;
    }

    _currentStep = OrderStatus.values.indexOf(_currentStatus);
    _updateOrderStatus(); // Start the status update sequence
  }

  Widget _buildIconWidget(OrderStatus status) {
    // Function to decide which icon to display based on status
    if (_currentStatus == status) {
      return Icon(Icons.check_circle, color: Colors.green);
    } else if (_completedStatuses.contains(status)) {
      return Icon(Icons.check_circle_outline, color: Colors.green);
    } else if (status == OrderStatus.cancelled ||
        status == OrderStatus.cancelledProduct) {
      return Icon(Icons.cancel, color: Colors.red);
    } else {
      return Icon(Icons.radio_button_unchecked, color: Colors.grey);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<OrderStatus> statusSequence = [
      OrderStatus.placed,
      OrderStatus.shipped,
      OrderStatus.ontheway,
      OrderStatus.delivered,
      OrderStatus.returned,
    ];

    List<StepperData> stepData = statusSequence.map((status) {
      return StepperData(
        title: StepperText(
          _statusDescriptions[status] ?? "",
          textStyle: TextStyle(
            color: _currentStatus == status ? Colors.green : Colors.black,
            fontWeight:
                _currentStatus == status ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        subtitle: StepperText(
          _statusDates[status] ?? "",
          textStyle: TextStyle(
            color: _currentStatus == status ? Colors.green : Colors.grey,
          ),
        ),
        iconWidget: _buildIconWidget(status),
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Tracking"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              AnimatedContainer(
                duration: const Duration(seconds: 1),
                child: AnotherStepper(
                  stepperList: stepData,
                  stepperDirection: Axis.vertical,
                  activeBarColor: Colors.green,
                  inActiveBarColor: Colors.grey[300]!,
                  activeIndex: _currentStep,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
