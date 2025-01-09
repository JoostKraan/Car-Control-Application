import 'package:car_app/Services/car_navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:car_app/location_service.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  LatLng? currentLocation;
  bool _mapInitialized = false;
  final LocationService _locationService = LocationService();
  LatLng? _destination;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      final position = await _locationService.determinePosition();
      setState(() {
        currentLocation = LatLng(position.latitude, position.longitude);
      });
      if (_mapInitialized) {
        _moveMapToCurrentLocation();
      }
    } catch (e) {
      _showErrorDialog(e.toString());
    }
  }

  void _moveMapToCurrentLocation() {
    if (currentLocation != null) {
      _mapController.move(currentLocation!, 14);
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.grey[900],
        title: const Text(
            'Map',
            style: TextStyle(color: Colors.white, fontFamily: 'Poppins')),
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              'assets/settings-5-fill.svg',
              color: Colors.white,
              fit: BoxFit.contain,
            ),
            onPressed: () {
              // Handle settings button press
            },
          ),
        ],
      ),
      backgroundColor: Colors.grey[900],
      body: Container(
        child: currentLocation == null
            ? const Center(child: CircularProgressIndicator())
            : Stack(
          children: [
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: currentLocation!,
                initialZoom: 14,
                onMapReady: () {
                  setState(() {
                    _mapInitialized = true;
                  });
                  _moveMapToCurrentLocation();
                },
                onTap: (tapPosition, point) {
                  setState(() {
                    _destination = point;
                  });
                },
              ),
              children: [
                TileLayer(
                  urlTemplate:
                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: currentLocation!,
                      width: 40,
                      height: 40,
                      child: SvgPicture.asset(
                        color: Colors.blueAccent,
                        'assets/map-pin-user-fill.svg',
                      ),
                    ),
                    if (_destination != null)
                      Marker(
                        point: _destination!,
                        width: 40,
                        height: 40,
                        child: SvgPicture.asset(
                          color: Colors.redAccent,
                          'assets/map-pin-line.svg',
                        ),
                      ),
                  ],
                ),
              ],
            ),
            Positioned(
              top: 10,
              left: 10,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: SizedBox(
                      width: 160,
                      height: 25,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Start Location',
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: SvgPicture.asset(
                                'assets/user-6-fill.svg',
                                color: Colors.blueAccent,
                                fit: BoxFit.contain,
                              ),
                              onPressed: () {
                                // Handle the button press
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: SizedBox(
                      width: 160,
                      height: 25,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Destination',
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 25,
                            height: 25,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: SvgPicture.asset(
                                'assets/home-4-fill.svg',
                                color: Colors.blueAccent,
                              ),
                              onPressed: () {

                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 25,
              bottom: 10,
              child: Column(
                spacing: 15,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    backgroundColor: Colors.grey[900]!,
                    elevation: 3,
                    onPressed: () {
                      if (currentLocation != null) {
                        _mapController.move(currentLocation!, 15);
                      }
                    },
                    child: SvgPicture.asset(
                      color: Colors.white,
                      'assets/compass-discover-fill.svg',
                    ),
                  ),
                  FloatingActionButton(
                    backgroundColor: Colors.grey[900]!,
                    onPressed: null,
                    child: SvgPicture.asset(
                        color: Colors.white,
                        'assets/roadster-fill.svg'),
                  ),
                  FloatingActionButton(
                    backgroundColor: Colors.grey[900]!,
                    onPressed: null,
                    child: SvgPicture.asset(
                        color: Colors.white,
                        'assets/navigation-fill.svg'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}