import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 200,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: 10),
              Row(
                children:  [
                  SizedBox(width: 10),
                  Image.asset(
                      width: 45,
                      'assets/gears/Neutral_Gear.png'
                  ),
                ]
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  SizedBox(width: 10),
                  SvgPicture.asset(
                      width: 45,
                      color: Colors.white,
                      'assets/Ford_Escort_Rim.svg'),
                  SizedBox(width: 10),
                  Text(
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.white
                      ),
                      '20 km/h')
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  SizedBox(width: 10),
                  Text(
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      'RPM stuff here')
                ],
                
              )
            ],

          ),
          Positioned(
            top: 10,
            right: 30,
            child: SvgPicture.asset(
              'assets/escort_sillouette2.svg',
              width: 75,
              color: const Color(0xFF8A8C8B),
            ),
          ),
          Positioned(
            right: 20,
            top: 20,
            child: SizedBox(
              width: 10,
              height: 30,
              child: SvgPicture.asset(
                'assets/tire.svg',
                width: 10,
                color: const Color(0xFF8A8C8B),
              ),
            ),
          ),
          Positioned(
            left: 283,
            top: 20,
            child: SizedBox(
              width: 10,
              height: 30,
              child: SvgPicture.asset(
                'assets/tire.svg',
                color: const Color(0xFF8A8C8B),
              ),
            ),
          ),
          Positioned(
            left: 280,
            top: 135,
            child: SizedBox(
              width: 10,
              height: 30,
              child: SvgPicture.asset(
                'assets/tire.svg',
                color: const Color(0xFF8A8C8B),
              ),
            ),
          ),
          Positioned(
            right: 17,
            top: 135,
            child: SizedBox(
              width: 10,
              height: 30,
              child: SvgPicture.asset(
                'assets/tire.svg',
                color: const Color(0xFF8A8C8B),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
