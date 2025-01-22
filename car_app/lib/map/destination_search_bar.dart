import 'package:car_app/map/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:car_app/api/navigation.dart';
import 'package:car_app/location_service.dart';
import 'package:provider/provider.dart';

class DestinationSearchBar extends StatefulWidget {
  static MapController? _mapController;
  final VoidCallback onClose;

  static void setMapController(MapController controller) {
    _mapController = controller;
  }
  static MapController? getMapController() {
    return _mapController;
  }

  const DestinationSearchBar({
    super.key,
    required this.onClose,
  });


  @override
  State<DestinationSearchBar> createState() => _DestinationSearchBarState();
}

class _DestinationSearchBarState extends State<DestinationSearchBar> {

  final TextEditingController _textController = TextEditingController();
  final NavigationService _navigationService = NavigationService();
  final LocationService _locationService = LocationService();
  final MapScreen mapScreen = MapScreen();

  void _handleDestinationInput(String input) async {
    try {
      final LatLng destinationCoordinates = await _navigationService.geocodeAddress(input);
      setState(() {
        LocationService.destination = destinationCoordinates;
      });

      final address = await _navigationService.reverseGeocode(destinationCoordinates);
      _textController.text = address;
      Provider.of<MapControllerNotifier>(context, listen: false)
          .mapController
          .move(destinationCoordinates, 15);
      LocationService.destination = destinationCoordinates;
    } catch (e) {
      print('Error resolving destination: $e');
    }
    //here location print

  }

  void _goToHome() {
    if (_locationService.homeLocation != null) {
      final home = _locationService.homeLocation!;
      Provider.of<MapControllerNotifier>(context, listen: false)
          .mapController
          .move(home, 15);

      setState(() {
        LocationService.destination = home;
      });
    } else {
      _showSetHomeDialog();
    }
  }

  Future<void> _showSetHomeDialog() async {
    // Example dialog for setting home location
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set Home Location'),
        content: const Text('Please set your home location first.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _showEditHomeDialog() async {
    if (_locationService.homeLocation == null) {
      return _showSetHomeDialog();
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Home Location'),
        content: const Text('Would you like to change your home location?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showSetHomeDialog();
            },
            child: const Text('Change'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 10,
      left: 40,
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
                        contentPadding: EdgeInsets.fromLTRB(15, 0, 0, 10),
                        border: InputBorder.none,
                        hintText: 'Destination',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins',
                      ),
                      controller: _textController,
                      onSubmitted: _handleDestinationInput,
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
                        onPressed: _goToHome,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}