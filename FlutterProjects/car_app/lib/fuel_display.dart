import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FuelDisplay extends StatelessWidget {
  final int fuelLevel;

  const FuelDisplay({super.key, required this.fuelLevel});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            'assets/gas-station-fill.svg',
            height: 20,
            color: Colors.white,
          ),
          const SizedBox(width: 8),
          Text(
            '$fuelLevel',
            style: const TextStyle(
              fontFamily: 'Poppins',
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}