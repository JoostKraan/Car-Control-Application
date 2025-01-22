import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TurnByTurn extends StatefulWidget {
  final VoidCallback onClose;

  const TurnByTurn({
    super.key,
    required this.onClose,
  });

  @override
  State<TurnByTurn> createState() => _TurnByTurnState();
}

class _TurnByTurnState extends State<TurnByTurn> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 10,
      right: 10,
      left: 10,
      bottom: 650,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[900]!.withOpacity(0.9),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: const Offset(2, 2),
              blurRadius: 4,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(height: 15,),
            Row(
              children: [
                SizedBox(width: 25,),
                Image.asset(
                  'assets/navigationicons/Roundabout1st.png',
                  height: 75,
                  width: 75,
                ),
                SizedBox(width: 50),
                Text(
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontFamily: 'Poppin',
                  ),
                    'Current street'),
              ],
            ),
            Column(
              children: [
                Row(
                  children: [
                    SizedBox(width: 25,),
                    Text(
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontFamily: 'Poppin',
                        ),
                        '200 Meters'),
                    SizedBox(width: 60,),
                    const Text(
                      'Next Street',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(width: 35),
                Column(
                  children: [
                    Container(
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
                      width: 50,
                      height: 50,
                      child: Image.asset('assets/navigationicons/Roundabout2nd.png'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}