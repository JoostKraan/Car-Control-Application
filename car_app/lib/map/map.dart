import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:car_app/map/map_screen.dart';

class MapButton extends StatelessWidget {
  const MapButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MapScreen()),
        );
      },
      icon: SvgPicture.asset(
        color: const Color(0xFF8A8C8B),
        'assets/map-pin-line.svg',
      ),
    );
  }
}