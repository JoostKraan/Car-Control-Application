import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'car_app.dart';

void main() {
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(MaterialApp(
    home: CarApp(),
    debugShowCheckedModeBanner: false,
  ));
}