import 'package:flutter/material.dart';

class footer extends StatefulWidget {

  final VoidCallback onClose;
  const footer({
    super.key,
    required this.onClose,
  });

  @override
  State<footer> createState() => _footerState();
}

class _footerState extends State<footer> {

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 720,
      bottom: 10,
      left: 20,
      right: 100,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[900]!.withOpacity(0.9),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: const Offset(2, 2),
              blurRadius: 4,
            ),
          ],
        ),
        child: Row(
          children: [
            SizedBox(width: 80,),
            Column(
              children: [
                SizedBox(height: 20),
                Text(
                    style: TextStyle(
                      fontSize: 25,
                      fontFamily: 'Poppins',
                      color: Colors.white,
                    ),
                    '23 minutes'),
                SizedBox(height: 20),
                Text(
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.white,
                    ),
                    '20 Billion km'),
              ],
            ),
            SizedBox(width: 40,),
            Container(
              child: Text(
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins'
                ),
                '10:30',
              ),
            )

          ],
        ),
      ),
    );
  }
}
