// import 'dart:async';
// import 'package:car_app/api/turn_api.dart';
//
// import 'package:flutter/material.dart';
//
// import '../map/constants.dart';
//
// class TurnByTurn extends StatefulWidget {
//   final VoidCallback onClose;
//
//   const TurnByTurn({
//     Key? key,
//     required this.onClose,
//   }) : super(key: key);
//
//   @override
//   State<TurnByTurn> createState() => _TurnByTurnState();
// }
//
// class _TurnByTurnState extends State<TurnByTurn> {
//   // Variables to store the navigation details
//   String distanceText = 'Loading...';
//   String nextTurnStreet = 'Loading...';
//   String currentStreet = 'Loading...';
//   String turnType = 'Loading...';
//
//   Timer? _timer;
//   InstructionImages images = InstructionImages();
//
//   @override
//   void initState() {
//     super.initState();
//     // Update navigation details immediately and then periodically every 3 seconds.
//     _updateNavigationDetails();
//     _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
//       _updateNavigationDetails();
//     });
//   }
//
//   Future<void> _updateNavigationDetails() async {
//     var details = await TurnByTurnService.getNavigationDetails();
//     if (details != null) {
//       setState(() {
//         // Format the distance (in meters) to a rounded string
//         double distance = details['distanceToNextTurn'];
//         distanceText = "in ${distance.toStringAsFixed(0)} Meters";
//         nextTurnStreet = details['nextTurn'] ?? 'Unknown';
//         currentStreet = details['currentStreet'] ?? 'Unknown';
//         turnType = details['turnType'] ?? 'straight';
//       });
//     }
//   }
//
//   @override
//   void dispose() {
//     _timer?.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Positioned(
//       top: 10,
//       right: 10,
//       left: 10,
//       bottom: 500,
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.grey[900]!.withOpacity(0.9),
//           borderRadius: BorderRadius.circular(10),
//           boxShadow: const [
//             BoxShadow(
//               color: Colors.black26,
//               offset: Offset(2, 2),
//               blurRadius: 4,
//             ),
//           ],
//         ),
//         child: Column(
//           children: [
//             const SizedBox(height: 10),
//             Row(
//               children: [
//                 const SizedBox(width: 20),
//                 Text(
//                   distanceText,
//                   style: const TextStyle(
//                     fontSize: 18,
//                     color: Colors.white,
//                     fontFamily: 'Poppin',
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 10),
//             Row(
//               children: [
//                 const SizedBox(width: 25),
//                 Image.asset(
//                   images.instructionImages[1],
//                   height: 75,
//                   width: 75,
//                 ),
//                 const SizedBox(width: 50),
//                 Text(
//                   nextTurnStreet,
//                   style: const TextStyle(
//                     fontSize: 25,
//                     color: Colors.white,
//                     fontFamily: 'Poppin',
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 10),
//             Column(
//               children: [
//                 Row(
//                   children: const [
//                     SizedBox(width: 110),
//                     Text(
//                       'Current Street',
//                       style: TextStyle(
//                         fontFamily: 'Poppins',
//                         color: Colors.white,
//                         fontSize: 18,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 5),
//                 Text(
//                   currentStreet,
//                   style: const TextStyle(
//                     fontFamily: 'Poppins',
//                     color: Colors.white,
//                     fontSize: 16,
//                   ),
//                 ),
//                 const SizedBox(height: 5),
//                 Text(
//                   "Turn: $turnType",
//                   style: const TextStyle(
//                     fontFamily: 'Poppins',
//                     color: Colors.white,
//                     fontSize: 16,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 10),
//             Row(
//               children: [
//                 const SizedBox(width: 35),
//                 Column(
//                   children: [
//                     Container(
//                       decoration: BoxDecoration(
//                         color: Colors.grey[900]!.withOpacity(0.9),
//                         borderRadius: BorderRadius.circular(8),
//                         boxShadow: const [
//                           BoxShadow(
//                             color: Colors.black26,
//                             offset: Offset(2, 2),
//                             blurRadius: 4,
//                           ),
//                         ],
//                       ),
//                       width: 50,
//                       height: 50,
//                       child: Image.asset('assets/navigationicons/Roundabout2nd.png'),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
