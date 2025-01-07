import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() => runApp(MaterialApp(
  home: CarApp(),
  debugShowCheckedModeBanner: false,
));

class CarApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Text(
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.white,
            shadows: [
              Shadow(
                offset: Offset(2.0, 2.0),
                blurRadius: 10.0,
                color: Colors.black,
              )
            ]
          ),
            'Escort'
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Add an image widget here
          Padding(
            padding: EdgeInsets.only(top: 40.0,bottom: 50), // Adjust padding as needed
            child: Image.asset(
              'assets/FordEscort.png', // Replace with your image path
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SvgPicture.asset(
                  'assets/roadster-fill.svg',
                  color: Color(0xFF8A8C8B),
                ),
                SvgPicture.asset(
                  'assets/lock-fill.svg',
                  color: Color(0xFF8A8C8B),
                ),
                SvgPicture.asset(
                  'assets/map-pin-line.svg',
                  color: Color(0xFF8A8C8B),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
