import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';



  class FuelDisplay extends StatelessWidget {
  final int fuelLevel;
  const FuelDisplay({super.key, required this.fuelLevel});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          'assets/gas-station-fill.svg',
          height: 25,
          color: Colors.white,
        ),
        const SizedBox(width: 8),
        Text(
          '$fuelLevel L',
          style: const TextStyle(
            fontFamily: 'Poppins',
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ],
    );
  }
}