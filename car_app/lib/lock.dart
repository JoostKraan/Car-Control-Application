import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LockButton extends StatelessWidget {
  
  const LockButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
        color: const Color(0xFF8A8C8B),
        'assets/lock-fill.svg');
  }
}