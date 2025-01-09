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

  void _openNewScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Navigation()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.grey[900],
        title: const Text(
            'Map', style: TextStyle(color: Colors.white,fontFamily: 'Poppins')),
      ),
      body: currentLocation == null
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
            right: 25,
            bottom: 10,
            child: Column(
              spacing: 20,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FloatingActionButton(
                  backgroundColor: Colors.blueAccent,
                  onPressed: () {
                    if (currentLocation != null) {
                      _mapController.move(currentLocation!, 15);
                    }
                  },
                  child: SvgPicture.asset(
                      color: Colors.black,
                      'assets/compass-discover-fill.svg'),
                ),
                FloatingActionButton(
                  backgroundColor: Colors.blueAccent,
                  onPressed: null,
                  child: SvgPicture.asset(
                      color: Colors.black, 'assets/roadster-fill.svg'),
                ),
                FloatingActionButton(
                  backgroundColor: Colors.blueAccent,
                  onPressed: _openNewScreen, // Corrected line
                  child: SvgPicture.asset(
                      color: Colors.black, 'assets/navigation-fill.svg'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}