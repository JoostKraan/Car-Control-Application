import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:car_app/car_image.dart';
import 'package:car_app/fuel_display.dart';
import 'package:car_app/lock.dart';
import 'package:car_app/map.dart';
import 'package:http/http.dart' as http;

class CarApp extends StatefulWidget {
  const CarApp({super.key});

  @override
  State<CarApp> createState() => _CarAppState();
}

class _CarAppState extends State<CarApp> {
  int fuelLevel = 0;
  String carTitle = 'Escort';
  bool isLocked = true;
  bool isEditing = false;
  TextEditingController carTitleController = TextEditingController();

  void lockCar() {
    setState(() {
      isLocked = !isLocked;
    });
  }

  void toggleEdit() {
    setState(() {
      isEditing = !isEditing;
      if (!isEditing) {
        carTitle = carTitleController.text;
      }
    });
  }

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
                if (isEditing)
                  Expanded(
                    child: TextField(
                      controller: carTitleController,
                      style: const TextStyle(color: Colors.white),
                      autofocus: true,
                      decoration: const InputDecoration(
                        hintText: 'Enter car name',
                        hintStyle: TextStyle(color: Colors.white),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                  )
                else
                  Text(
                    carTitle,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          offset: Offset(2.0, 2.0),
                          blurRadius: 10.0,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                const SizedBox(width: 10),
                IconButton(
                  icon: SvgPicture.asset(
                    'assets/edit-line.svg',
                    height: 15,
                    width: 15,
                    color: Colors.white,
                  ),
                  onPressed: toggleEdit,
                ),
              ],
            ),
            FuelDisplay(fuelLevel: fuelLevel),
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
                LockButton(
                  isLocked: isLocked,
                  onLock: lockCar,
                ),
                MapButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}