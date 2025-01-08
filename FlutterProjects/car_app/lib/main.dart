import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  // Hide the status bar

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(MaterialApp(
    home: CarApp(),

    debugShowCheckedModeBanner: false,
  ));
}

class CarApp extends StatefulWidget {
  const CarApp({super.key});

  @override
  State<CarApp> createState() => _CarAppState();
}

class _CarAppState extends State<CarApp> {
  int fuelLevel = 0;

  String carTitle = 'Escort';
  String lockedImg = 'assets/lock-fill.svg';
  String unlockedImg = 'assets/lock-unlock-fill.svg';
  bool isLocked = true;
  bool isEditing = false;
  TextEditingController carTitleController = TextEditingController();

  void lockCar() {
    setState(() {
      isLocked = !isLocked;
      if (isLocked) {
        lockedImg = 'assets/lock-fill.svg';
      } else {
        lockedImg = 'assets/lock-unlock-fill.svg';
      }
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
                      style: TextStyle(color: Colors.white),
                      autofocus: true,
                      decoration: InputDecoration(
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
                    style: TextStyle(
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
                SizedBox(width: 10),
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
            Container(
              margin: EdgeInsets.only(top: 8),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                  SizedBox(width: 8),
                  Text(
                    '$fuelLevel',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 220,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.6),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
              Image.asset('assets/FordEscort.png'),
            ],
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset(
                    color: Color(0xFF8A8C8B),
                    'assets/roadster-fill.svg',
                  ),
                ),
                IconButton(
                  onPressed: lockCar,
                  icon: SvgPicture.asset(
                    color: Color(0xFF8A8C8B),
                    lockedImg,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // Navigate to the Map Screen when pressed
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MapScreen()),
                    );
                  },
                  icon: SvgPicture.asset(
                    color: Color(0xFF8A8C8B),
                    'assets/map-pin-line.svg',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Separate MapScreen Widget
class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? currentLocation;

  @override
  void initState() {
    super.initState();
    _determinePosition().then((position) {
      setState(() {
        currentLocation = LatLng(position.latitude, position.longitude);
      });
    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Map')),
      body: currentLocation == null
          ? Center(child: CircularProgressIndicator())
          : FlutterMap(
        options: MapOptions(
          initialCenter: currentLocation!,
          initialZoom: 14,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'dev.fleaflet.flutter_map.example',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: currentLocation!,
                width: 40,
                height: 40,
                builder: (ctx) => Container(
                  child: Icon(
                    Icons.location_pin,
                    color: Colors.red,
                    size: 40,
                  ),
                ), child: Container(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

