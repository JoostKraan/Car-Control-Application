// import 'package:car_app/constants.dart';
// import 'package:flutter/material.dart';
//
// class Navigation extends StatelessWidget {
//   const Navigation({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[900],
//       appBar: AppBar(
//           iconTheme: const IconThemeData(color: Colors.white),
//           backgroundColor: Colors.grey[900],
//           title: const Text(
//             'Navigate',
//             style: TextStyle(
//               color: Colors.white,
//               fontFamily: 'Poppins',
//             ),
//           )),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const SizedBox(height: 15),
//           Container(
//             padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
//             decoration: BoxDecoration(
//               color: Colors.grey[900],
//               borderRadius: BorderRadius.circular(5),
//               border: Border.all(
//                 color: Colors.grey,
//               ),
//             ),
//             child: const Row(
//               children: [
//                 Text(
//                   'Start Location',
//                   style: TextStyle(
//                     color: Colors.grey,
//                     fontSize: 15,
//                     fontFamily: 'Poppins',
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.fromLTRB(10, 0, 10, 55),
//             height: 30,
//             width: 150,
//             child: const TextField(
//               cursorHeight: 20,
//               style: TextStyle(
//                 color: Colors.white,
//                 height: 3,
//                 fontFamily: 'Poppins',
//               ),
//             ),
//           ),
//           const SizedBox(height: 25),
//           Container(
//             padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
//             decoration: BoxDecoration(
//               color: Colors.grey[900],
//               borderRadius: BorderRadius.circular(5),
//               border: Border.all(
//                 color: Colors.grey,
//               ),
//             ),
//             child: const Row(
//               children: [
//                 Text(
//                   'Destination',
//                   style: TextStyle(
//                     color: Colors.grey,
//                     fontSize: 15,
//                     fontFamily: 'Poppins',
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.fromLTRB(10, 0, 10, 55),
//             height: 30,
//             width: 150,
//             child: const TextField(
//               cursorHeight: 20,
//               style: TextStyle(
//                 color: Colors.grey,
//                 height: 3,
//                 fontFamily: 'Poppins',
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }