import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class CarData extends ChangeNotifier {
  final _channel = WebSocketChannel.connect(
    Uri.parse('ws://192.168.1.69:8765'),
  );

  String interiorTemp = "N/A";
  String exteriorTemp = "N/A";
  double? lat;
  double? lon;

  CarData() {
    _channel.stream.listen((message) {
      try {
        final parts = message.toString().split(',');
//2025-07-15,18:47:26,52.68692780,6.60498619,21.06,21.19
        if (parts.length >= 6) {
          final exterior = parts[4];
          final interior = parts[5];
          final latitude = parts[2];
          final longitude = parts[3];

          interiorTemp = "${double.tryParse(interior)?.toStringAsFixed(1) ?? "N/A"}°C";
          exteriorTemp = "${double.tryParse(exterior)?.toStringAsFixed(1) ?? "N/A"}°C";
          lat = double.tryParse(latitude)!;
          lon =  double.tryParse(longitude)!;
          print(message);

          notifyListeners();
        } else {
          print('Unexpected format: $message');
        }
      } catch (e) {
        print('Error parsing message: $message');
      }
    });
  }

  Stream get stream => _channel.stream;
}
