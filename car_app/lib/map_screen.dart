import 'dart:async';
import 'package:car_app/location_service.dart';
import 'package:car_app/turn-by-turn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:car_app/api/navigation.dart';
import 'package:geolocator/geolocator.dart';
import 'destination_search_bar.dart';
import 'package:provider/provider.dart';


class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  bool _showTurnByTurn = false;
  bool _showDestinationBar = true;
  late MapController _mapController;
  final LocationService _locationService = LocationService();
  final NavigationService _navigationService = NavigationService();
  List<LatLng> _routePolyline = [];
  bool _mapInitialized = false;
  StreamSubscription<Position>? _positionStreamSubscription;
  bool _isLoading = false;
  final bool _isFollowingUser = true;

  @override
  void initState() {
    super.initState();
    _initializeLocationUpdates();
    _mapController = MapController();
  }


  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    _mapController.dispose();
    super.dispose();
  }


  Future<void> _initializeLocationUpdates() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _locationService..currentLocation = LatLng(position.latitude, position.longitude);
      });

      _positionStreamSubscription = Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 10,
          ))
          .listen((Position position) {
        setState(() {
          _locationService.currentLocation = LatLng(position.latitude, position.longitude);
        });
        if (_isFollowingUser && _mapInitialized) {
          _mapController.move(_locationService.currentLocation!, _mapController.camera.zoom);
        }
        if (LocationService.destination != null && _routePolyline.isNotEmpty) {
          _fetchRoute();
        }
      });
    } catch (e) {
      _showErrorDialog(e.toString());
    }
  }
  void _moveMapToCurrentLocation() {
    if (_locationService.currentLocation != null) {
      _mapController.move(_locationService.currentLocation!, 14);
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

  Future<void> _saveHomeLocation(LatLng location) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setDouble('home_lat', location.latitude);
    await preferences.setDouble('home_lng', location.longitude);
    setState(() {
      _locationService.homeLocation = location;
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
              if (_locationService.currentLocation != null) {
                await _saveHomeLocation(_locationService.currentLocation!);
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
    if (_locationService.homeLocation == null) {
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
    if (_locationService.currentLocation == null || LocationService.destination == null) return;
    setState(() {
      _isLoading = true;
    });
    try {
      // Fetch route data
      final routePolyline = await  _navigationService.getRoute(_locationService.currentLocation!, LocationService.destination!);
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
    return ChangeNotifierProvider<MapControllerNotifier>.value(
      value: MapControllerNotifier(_mapController),
      child: Scaffold(
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
          child: _locationService.currentLocation == null
              ? const Center(child: CircularProgressIndicator())
              : Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: _locationService.currentLocation!,
                  initialZoom: 14,
                  onMapReady: () {
                    setState(() {
                      _mapInitialized = true;
                    });
                    _moveMapToCurrentLocation();
                  },
                  onTap: (tapPosition, point) {
                    setState(() {
                      LocationService.destination = point;
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
                        point: _locationService.currentLocation!,
                        width: 40,
                        height: 40,
                        child: SvgPicture.asset(
                          color: Colors.blueAccent,
                          'assets/map-pin-user-fill.svg',
                        ),
                      ),
                      if (LocationService.destination != null)
                        Marker(
                          point: LocationService.destination!,
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
                        if (_locationService.currentLocation != null) {
                          _mapController.move(_locationService.currentLocation!, 18);
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
                      onPressed: _isLoading ? null : () async {
                        await _fetchRoute();
                        setState(() {
                          _showTurnByTurn = true;
                        });
                      },
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : SvgPicture.asset(
                          color: Colors.white,
                          'assets/roadster-fill.svg'),
                    ),
                  ],
                ),
              ),
              if (_showTurnByTurn)
                TurnByTurn(
                  onClose: () {
                    setState(() {
                      _showTurnByTurn = false;
                    });
                  },
                ),
              if (_showDestinationBar)
                DestinationSearchBar(
                  onClose: () {
                    setState(() {
                      _showTurnByTurn = true;
                      _showDestinationBar = false;
                    });
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
class MapControllerNotifier extends ChangeNotifier {
  MapController _mapController;

  MapControllerNotifier(this._mapController);

  MapController get mapController => _mapController;

  void move(LatLng center, double zoom) {
    _mapController.move(center, zoom);
    notifyListeners();
  }

}