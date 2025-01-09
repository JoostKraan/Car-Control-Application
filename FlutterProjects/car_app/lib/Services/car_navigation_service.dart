import 'package:flutter/material.dart';

class Navigation extends StatelessWidget {
  const Navigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.grey[900],
          title: Text(
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
          ),
          'Destination')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Text(
              style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Poppins'
              ),
              'Start Location'),
          SizedBox(
            height: 25,
          ),
          Text(
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'Poppins'
            ),
              'Destination'),

          TextField(
            style: TextStyle(
              fontFamily: 'Poppins'
            ),

          ),
        ],


      ),
    );
  }
}