import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:car_app/location_service.dart';
import 'package:car_app/services/car_navigation_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geocoding/geocoding.dart';

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
  List<LatLng> _routePoints = [];
  LatLng? _destination;
  bool _isNavigating = false;
  final TextEditingController _addressController = TextEditingController();
  final CarNavigationService _carNavigationService = CarNavigationService();

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

  Future<void> _fetchRoute() async {
    if (currentLocation == null || _destination == null) return;

    final startCoords = "${currentLocation!.longitude},${currentLocation!.latitude}";
    final endCoords = "${_destination!.longitude},${_destination!.latitude}";

    final url = Uri.parse(
        'http://router.project-osrm.org/route/v1/driving/$startCoords;$endCoords?overview=full&geometries=geojson');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> coordinates =
        data['routes'][0]['geometry']['coordinates'];
        setState(() {
          _routePoints = coordinates
              .map((coord) => LatLng(coord[1], coord[0]))
              .toList();
        });
      } else {
        print('Error fetching route: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching route: $e');
    }
  }

  Future<void> _geocodeAddress(String address) async {
    address = address.trim(); // Trim whitespace
    print('Geocoding address: "$address"'); // Print the address
    if (address.isEmpty) {
      _showErrorDialog('Please enter an address.');
      return;
    }
    try {
      List<Location> locations = await GeocodingPlatform.instance.locationFromAddress(address);
      if (locations.isNotEmpty) {
        setState(() {
          _destination = LatLng(locations.first.latitude, locations.first.longitude);
          _routePoints = []; // Clear previous route
        });
        _fetchRoute();
      } else {
        _showErrorDialog('Address not found');
      }
    } catch (e) {
      _showErrorDialog('Error geocoding address: $e');
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

  void _toggleNavigation() {
    setState(() {
      _isNavigating = !_isNavigating;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.grey[900],
        title: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _addressController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Enter address',
                  hintStyle: TextStyle(color: Colors.white),
                  border: InputBorder.none,
                ),
                onSubmitted: (address) {
                  _geocodeAddress(address);
                },
              ),
            ),
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () {
                _geocodeAddress(_addressController.text);
              },
            ),
          ],
        ),
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
                  _routePoints = []; // Clear previous route
                });
                _fetchRoute();
              },
            ),
            children: [
              TileLayer(
                urlTemplate:
                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'dev.fleaflet.flutter_map.example',
              ),
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: _routePoints,
                    color: Colors.blue,
                    strokeWidth: 3,
                  ),
                ],
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
                  onPressed: _toggleNavigation,
                  child: SvgPicture.asset(
                      color: Colors.black, 'assets/navigation-fill.svg'),
                ),
              ],
            ),
          ),
          if (_isNavigating)
            NavigationOverlay(
              onClose: _toggleNavigation,
              destination: _destination,
            ),
        ],
      ),
    );
  }
}