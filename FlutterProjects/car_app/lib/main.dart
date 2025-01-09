import 'package:flutter/material.dart';
import 'package:car_app/car_app.dart'; // Import your CarApp widget
import 'package:car_app/base-app.dart'; // Import the BaseApp widget

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Required for SystemChrome
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaseApp(
      title: 'Car App',
      child: CarApp(),
    );
  }
}