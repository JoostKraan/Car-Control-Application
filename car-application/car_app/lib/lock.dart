import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LockButton extends StatelessWidget {
  final bool isLocked;
  final VoidCallback onLock;

  const LockButton({super.key, required this.isLocked, required this.onLock});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onLock,
      icon: SvgPicture.asset(
        color: const Color(0xFF8A8C8B),
        isLocked ? 'assets/lock-fill.svg' : 'assets/lock-unlock-fill.svg',
      ),
    );
  }
}