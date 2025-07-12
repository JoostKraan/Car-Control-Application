import 'package:car_app/pages/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../providers/constants-provider.dart';
import '../services/location_service.dart';
import 'map_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final constantsProvider = await ConstantsProvider.create();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => constantsProvider,
        ),
      ],
      child: const MyApp(),
    ),
  );
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final LocationService locationService = LocationService();
  LatLng? currentLatLng;

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
        currentLatLng = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {

      debugPrint('Location Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final constants = context.watch<ConstantsProvider>().constants;

    return MaterialApp(
      routes: {
        '/settings': (BuildContext context) => Settings(),
        '/map': (BuildContext context) => const MapScreen(),
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        fontFamily: 'Manrope',
        dividerTheme: const DividerThemeData(color: Colors.transparent),
      ),
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          backgroundColor: constants.primaryColor,
          body:Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10, left: 10),
                    child: SvgPicture.asset(
                      'assets/icons/gas-station.svg',
                      color: constants.iconColor,
                      width: constants.iconSize,
                      height: constants.iconSize,
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      'Parked',
                      style: TextStyle(
                        color: constants.fontColor,
                        fontSize: constants.fontSize,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, right: 10),
                    child: Builder(
                      builder: (context) {
                        return IconButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed('/settings');
                          },
                          icon: SvgPicture.asset(
                            'assets/icons/settings.svg',
                            color: constants.iconColor,
                            width: constants.iconSize,
                            height: constants.iconSize,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        Image.asset(
                          'assets/img/wireframe.png',
                          width: 450,
                          height: 450,
                          color: constants.iconColor,
                        ),
                        Positioned(
                          right: 10,
                          top: 10,
                          child: Text(
                            'Interior | 20°C',
                            style: TextStyle(
                              fontSize: constants.fontSize,
                              color: constants.fontColor,
                            ),
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: null,
                          icon: SvgPicture.asset(
                            'assets/icons/lock-closed.svg',
                            color: constants.iconColor,
                            width: constants.iconSize,
                            height: constants.iconSize,
                          ),
                        ),
                        Builder(builder: (context) {
                          return IconButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed('/map');
                            },
                            icon: SvgPicture.asset(
                              'assets/icons/location-on.svg',
                              color: constants.iconColor,
                              width: constants.iconSize,
                              height: constants.iconSize,
                            ),
                          );
                        }),
                        IconButton(
                          onPressed: null,
                          icon: SvgPicture.asset(
                            'assets/icons/car-gear.svg',
                            color: constants.iconColor,
                            width: constants.iconSize,
                            height: constants.iconSize,
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: SizedBox(
                        height: 300,
                        width: 450,
                        child: currentLatLng == null
                            ? const Center(child: CircularProgressIndicator())
                            :  FlutterMap(
                          options: MapOptions(
                            initialCenter: currentLatLng!,
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
                                Marker(
                                  point: LatLng(currentLatLng!.latitude,currentLatLng!.longitude),
                                  width: 50,
                                  height: 50,
                                  child: SvgPicture.asset(
                                    'assets/icons/car.svg',
                                  ),
                                ),
                                Marker(
                                  point: LatLng(currentLatLng!.latitude,currentLatLng!.longitude),
                                  width: 50,
                                  height: 50,
                                  child: SvgPicture.asset(
                                    color: constants.accentColor,
                                    'assets/icons/person.svg',
                                  ),
                                ),
                              ],
                            ),

                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

