import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:car_app/api/navigation.dart';
import 'package:geolocator/geolocator.dart';


class MapScreen extends StatefulWidget {
  const MapScreen({super.key});
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final TextEditingController _textController = TextEditingController();
  final MapController _mapController = MapController();
  final NavigationService _navigationService = NavigationService();
  List<LatLng> _routePolyline = [];
  LatLng? currentLocation;
  bool _mapInitialized = false;
  StreamSubscription<Position>? _positionStreamSubscription;
  LatLng? _destination;
  LatLng? _homeLocation;
  bool _isLoading = false;
  final bool _isFollowingUser = true;

  @override
  void initState() {
    super.initState();
    _initializeLocationUpdates();
    _loadHomeLocation();
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _initializeLocationUpdates() async {
    try {
      // Get initial location
      final position = await _navigationService.getCurrentLocation();
      setState(() {
        currentLocation = LatLng(position.latitude, position.longitude);
      });
      _positionStreamSubscription = _navigationService.getPositionStream().listen((Position position) {
        setState(() {
          currentLocation = LatLng(position.latitude, position.longitude);
        });
        if (_isFollowingUser && _mapInitialized) {
          _mapController.move(currentLocation!, _mapController.camera.zoom);
        }
        if (_destination != null && _routePolyline.isNotEmpty) {
          _fetchRoute();
        }
      });
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

  Future<void> _loadHomeLocation() async {
    final preferences = await SharedPreferences.getInstance();
    final homeLat = preferences.getDouble('home_lat');
    final homeLng = preferences.getDouble('home_lng');
    if (homeLat != null && homeLng != null) {
      setState(() {
        _homeLocation = LatLng(homeLat, homeLng);
      });
    }
  }

  Future<void> _saveHomeLocation(LatLng location) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setDouble('home_lat', location.latitude);
    await preferences.setDouble('home_lng', location.longitude);
    setState(() {
      _homeLocation = location;
    });
  }

  Future<void> _showSetHomeDialog() async {
    final TextEditingController addressController = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Set Home Location',
          style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
        ),
        content: TextField(
          controller: addressController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Enter your home address',
            hintStyle: TextStyle(color: Colors.grey),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () async {
              if (currentLocation != null) {
                await _saveHomeLocation(currentLocation!);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Home location set!')),
                );
              }
            },
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _showEditHomeDialog() async {
    if (_homeLocation == null) {
      return _showSetHomeDialog();
    }
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Edit Home Location',
          style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
        ),
        content: const Text(
          'Would you like to change your home location?',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showSetHomeDialog();
            },
            child: const Text('Change', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _fetchRoute() async {
    if (currentLocation == null || _destination == null) return;
    setState(() {
      _isLoading = true;
    });
    try {
      // Fetch route data
      final routePolyline = await _navigationService.getRoute(currentLocation!, _destination!);
      setState(() {
        _routePolyline = routePolyline;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog(e.toString());
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.grey[900],
          title: const Text(
            'Map',
            style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
          ),
          actions: [
            IconButton(
              icon: SvgPicture.asset(
                'assets/settings-5-fill.svg',
                color: Colors.white,
                fit: BoxFit.contain,
              ),
              onPressed: () {
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
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
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
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _routePolyline,
                      strokeWidth: 5.0,
                      color: Colors.blue,
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
                  const SizedBox(height: 8),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Colors.grey[900]!.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(100),
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
                      width: 380,
                      height: 35,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.only(bottom: 10),
                                border: InputBorder.none,
                                hintText: 'Destination',
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins',
                              ),
                              controller: _textController,
                              onSubmitted: (input) async {
                                try {
                                  final LatLng destinationCoordinates =
                                  await _navigationService.geocodeAddress(input);
                                  print('Resolved Destination: ${destinationCoordinates.latitude}, ${destinationCoordinates.longitude}');
                                  _destination = LatLng(destinationCoordinates.latitude, destinationCoordinates.longitude);
                                  final address = await _navigationService.reverseGeocode(_destination!);
                                  _textController.text = address; // Update the text field with the resolved address
                                  print(address);
                                } catch (e) {
                                  print('Error resolving destination: $e');
                                }
                              },
                            ),
                          ),
                          SizedBox(
                            width: 25,
                            height: 25,
                            child: GestureDetector(
                              onLongPress: _showEditHomeDialog,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: SvgPicture.asset(
                                  'assets/home-4-fill.svg',
                                  color: Colors.blueAccent,
                                ),
                                onPressed: () {
                                  if (_homeLocation != null) {
                                    setState(() {
                                      _destination = _homeLocation;
                                    });
                                    _mapController.move(_homeLocation!, 15);
                                  } else {
                                    _showSetHomeDialog();
                                  }
                                },
                              ),
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
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    backgroundColor: Colors.grey[900]!,
                    elevation: 3,
                    onPressed: () {
                      if (currentLocation != null) {
                        _mapController.move(currentLocation!, 18);
                      }
                    },
                    child: SvgPicture.asset(
                      color: Colors.white,
                      'assets/compass-discover-fill.svg',
                    ),
                  ),
                  const SizedBox(height: 15),
                  FloatingActionButton(
                    backgroundColor: Colors.grey[900]!,
                    onPressed: _isLoading ? null : _fetchRoute,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : SvgPicture.asset(
                        color: Colors.white,
                        'assets/roadster-fill.svg'),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 80,
              right: 100,
              left: 100,
              bottom: 500,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[900]!.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(2, 2),
                        blurRadius: 4, //
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(20), // Padding inside the box
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Image.asset(
                            'assets/navigationicons/Roundabout2nd.png',
                            height: 100,
                            width: 100,
                            //color: Colors.white,
                          ),
                          SizedBox(height: 10),
                          Text(
                            'current turn',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Expanded(child: Container()),
                      Column(
                        children: [
                          Icon(
                            Icons.arrow_left,
                            color: Colors.grey,
                            size: 50,
                          ),
                          SizedBox(height: 10),
                          Text(
                            'In (x) distance',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }
}