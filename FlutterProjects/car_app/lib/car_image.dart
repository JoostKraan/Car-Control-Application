import 'package:flutter/material.dart';
import 'dart:math';

class CarImage extends StatelessWidget {
  const CarImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Shadow
        Transform.translate(
          offset: const Offset(1,30), // Adjust offset as needed
          child: CustomPaint(
            painter: EllipseShadowPainter(
              color: Colors.grey.withOpacity(0.2), // Adjust opacity as needed
            ),
            child: SizedBox(
              width: 500, // Adjust size as needed
              height: 200, // Adjust size as needed
            ),
          ),
        ),
        // Car Image
        Image.asset(
          color: Colors.white,
          'assets/FordEscort.png',
          width: 600, // Adjust size as needed
        ),
      ],
    );
  }
}

class EllipseShadowPainter extends CustomPainter {
  final Color color;

  EllipseShadowPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final rect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: size.width,
      height: size.height,
    );

    canvas.drawOval(rect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}