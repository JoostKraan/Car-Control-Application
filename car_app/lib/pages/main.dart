import 'package:car_app/pages/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../providers/constants-provider.dart';
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final constants = context.watch<ConstantsProvider>().constants;

    return MaterialApp(
        routes: {
          '/settings': (BuildContext context) => Settings(),
          '/map' : (BuildContext context) => MapScreen(),
          // add another route here
          // '/register': (BuildContext context) => Register(),
        },
        debugShowCheckedModeBanner: false,
        home: SafeArea(
          child: Scaffold(
            backgroundColor: constants.primaryColor,
            body: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10, left: 10),
                      child: SvgPicture.asset('assets/icons/gas-station.svg',
                          color: constants.iconColor,
                          width: constants.iconSize,
                          height: constants.iconSize),
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                          style: TextStyle(fontSize: constants.fontSize),
                          'Parked'),
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, right: 10),
                      child: Builder(
                        builder: (context) {
                          return IconButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed('/settings');
                            },
                            icon: SvgPicture.asset('assets/icons/settings.svg',
                                color: constants.iconColor,
                                width: constants.iconSize,
                                height: constants.iconSize),
                          );
                        }
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset('assets/img/wireframe.png',
                          width: 450, height: 450, color: constants.iconColor),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            onPressed: null,
                            icon: SvgPicture.asset(
                                'assets/icons/lock-closed.svg',
                                color: constants.iconColor,
                                width: constants.iconSize,
                                height: constants.iconSize),
                          ),
                          Builder(
                            builder: (context) {
                              return IconButton(
                                onPressed: () {
                                  Navigator.of(context).pushNamed('/map');
                                },
                                icon: SvgPicture.asset(
                                    'assets/icons/location-on.svg',
                                    color: constants.iconColor,
                                    width: constants.iconSize,
                                    height: constants.iconSize),
                              );
                            }
                          ),

                          IconButton(
                            onPressed: null,
                            icon: SvgPicture.asset('assets/icons/car-gear.svg',
                                color: constants.iconColor,
                                width: constants.iconSize,
                                height: constants.iconSize),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Container(
                          height: 300,
                          width: 450,
                          child: FlutterMap(
                            children: [
                              TileLayer(
                                retinaMode: true,
                                urlTemplate: constants.mapurl,
                                userAgentPackageName: 'com.example.app',
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
        ));
  }
}
