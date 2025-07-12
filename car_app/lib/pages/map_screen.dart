import 'dart:async';
import 'package:car_app/services/location_service.dart';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../providers/constants-provider.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}
class _MapScreenState extends State<MapScreen> {

  bool _mapInitialized = false;
  StreamSubscription<Position>? _positionStreamSubscription;
  bool _isLoading = false;
  final bool _isFollowingUser = false;

  @override
  void initState() {
    super.initState();
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
    final constants = context.watch<ConstantsProvider>().constants;
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
        child: Stack(
          children: [
            FlutterMap(
              options: MapOptions(
                initialZoom: 14,
              ),
              children: [
                TileLayer(
                  retinaMode: true,
                  urlTemplate: constants.mapurl,
                  userAgentPackageName: 'com.example.app',
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
                   onPressed: null,
                    child: SvgPicture.asset(
                      color: Colors.white,
                      'assets/compass-discover-fill.svg',
                    ),
                  ),
                  const SizedBox(height: 15),
                  FloatingActionButton(
                    backgroundColor: Colors.grey[900]!,
                  onPressed: null,
                    child: SvgPicture.asset(
                        color: Colors.white,
                        'assets/roadster-fill.svg'),
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