import 'package:car_app/dashboard.dart';
import 'package:car_app/notifications/notificationbutton.dart';
import 'package:car_app/trip_history.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:car_app/car_image.dart';
import 'package:car_app/fuel_display.dart';
import 'package:car_app/lock.dart';
import 'package:car_app/map/map.dart';


class CarApp extends StatefulWidget {
  const CarApp({super.key});

  @override
  State<CarApp> createState() => _CarAppState();
}

class _CarAppState extends State<CarApp> {
  bool isLocked = true;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        toolbarHeight: 100,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                FuelDisplay(fuelLevel: 0),
                SizedBox(width: 100),
                Text(
                  '200 km',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
               Spacer(),
                NotificationButton(),
                SizedBox(width: 10),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TripHistory())
                    );
                  },
                  icon: SvgPicture.asset(
                      'assets/map-2-line.svg',
                    color: Colors.white,
                    width: 25,
                    height: 25,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CarImage(),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                onPressed: null,
                  icon: SvgPicture.asset(
                    color: const Color(0xFF8A8C8B),
                    'assets/roadster-fill.svg',
                  ),
                ),
                LockButton(),
                MapButton(),
              ],
            ),
          ),
          Column(
            children: [
              Dashboard()
            ],
          ),
        ],
      ),
    );
  }
}
