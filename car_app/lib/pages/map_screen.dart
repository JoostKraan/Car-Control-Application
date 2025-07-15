import 'dart:async';
import 'package:car_app/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../providers/car_data.dart';
import '../providers/constants-provider.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final LocationService locationService = LocationService();
  LatLng? userPosition;

  @override
  void initState() {
    super.initState();
    _loadCurrentLocation();
  }

  Future<void> _loadCurrentLocation() async {
    try {
      await locationService.determinePosition();
      final position = await locationService.getCurrentLocation();

      setState(() {
        userPosition = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      _showErrorDialog(e.toString());
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
    final constants = context.watch<ConstantsProvider>().constants;
    final mapController = MapController();
    if (userPosition == null) {
      return Scaffold(
        backgroundColor: Colors.grey[900],
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Stack(children: [
        Consumer<CarData>(
            builder: (context, carData, _) {
              return  FlutterMap(
                mapController: mapController,
                options: MapOptions(
                  initialCenter: userPosition!,
                  initialZoom: 14,
                ),
                children: [
                  TileLayer(
                    retinaMode: true,
                    urlTemplate: constants.mapurl,
                    userAgentPackageName: 'com.example.app',
                  ),
                  MarkerLayer(
                    markers: [
                      if (userPosition != null)
                        Marker(
                          point: LatLng(
                              userPosition!.latitude,
                              userPosition!.longitude),
                          width: 50,
                          height: 50,
                          child: SvgPicture.asset(
                            color: constants.accentColor,
                            'assets/icons/person.svg',
                          ),
                        ),
                      Marker(
                        point: LatLng(
                            carData.lat!,
                            carData.lon!),
                        width: 50,
                        height: 50,
                        child: SvgPicture.asset(
                          color: constants.accentColor,
                          'assets/icons/car.svg',
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }
        ),
        Positioned(
          right: 25,
          bottom: 10,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              FloatingActionButton(
                backgroundColor: constants.accentColor,
                onPressed: () {
                  mapController.move(userPosition!, 15);
                },
                child: SvgPicture.asset(
                  width: constants.iconSize,
                  height: constants.iconSize,
                  color: constants.iconColor,
                  'assets/icons/person.svg',
                ),
              ),
              const SizedBox(height: 15),
              Consumer<CarData>(
                  builder: (context, carData, _) {
                    return FloatingActionButton(
                      backgroundColor: constants.accentColor,
                      onPressed: () {mapController.move(LatLng(carData.lat!, carData.lon!), 18);},
                      child: SvgPicture.asset(
                        height: constants.iconSize,
                        width: constants.iconSize,
                        color: constants.iconColor,
                        'assets/icons/car.svg',
                      ),
                    );
                  }
              ),
            ],
          ),
        ),
        Positioned(
          top: 60,
          left: 10,
          child: Builder(builder: (context) {
            return IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/');
                },
                icon: SvgPicture.asset(
                  'assets/icons/arrow-back.svg',
                  width: constants.iconSize,
                  height: constants.iconSize,
                  color: constants.iconColor,
                ));
          }),
        ),
      ]),
    );
  }
}
