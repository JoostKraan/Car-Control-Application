import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class NavigationService {
  static const String _baseUrl = 'http://81.172.187.98:5000';

  Future<List<LatLng>> getRoute(LatLng start, LatLng end) async {
    final url = '$_baseUrl/route/v1/car/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?overview=full&steps=true&geometries=geojson';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Extract the geometry coordinates
      final List<dynamic> coordinates = data['routes'][0]['geometry']['coordinates'];

      // Extract and construct turn-by-turn instructions
      final List<dynamic> legs = data['routes'][0]['legs'];
      for (var leg in legs) {
        final List<dynamic> steps = leg['steps'];
        for (var step in steps) {
          final String maneuverType = step['maneuver']['type'] ?? 'unknown maneuver';
          final String modifier = step['maneuver']['modifier'] ?? 'straight';
          final String streetName = step['name'] ?? 'unknown road';

          final instruction = _generateInstruction(maneuverType, modifier, streetName);
          print(instruction);
        }
      }

      // Convert coordinates to LatLng
      return coordinates.map((coord) => LatLng(coord[1], coord[0])).toList();
    } else {
      throw Exception('Failed to fetch route data: ${response.statusCode}');
    }
  }

  String _generateInstruction(String type, String modifier, String streetName) {
    switch (type) {
      case 'turn':
        return 'Turn $modifier onto $streetName';
      case 'depart':
        return 'Start on $streetName';
      case 'arrive':
        return 'You have arrived at $streetName';
      case 'roundabout':
        return 'Take the roundabout exit towards $streetName';
      case 'merge':
        return 'Merge $modifier onto $streetName';
      case 'continue':
        return 'Continue $modifier onto $streetName';
      default:
        return 'Proceed $modifier on $streetName';
    }
  }

  Future<LatLng> geocodeAddress(String address) async {
    final url =
        'https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent(address)}&format=json&addressdetails=1&limit=1';
    final response = await http.get(
      Uri.parse(url),
      headers: {'User-Agent': 'NavigationApp/1.0'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      if (data.isNotEmpty) {
        final double lat = double.parse(data[0]['lat']);
        final double lon = double.parse(data[0]['lon']);
        return LatLng(lat, lon);
      } else {
        throw Exception('Address not found');
      }
    } else {
      throw Exception('Failed to fetch address');
    }
  }
  Future<void> simulateMovement(List<Map<String, double>> route, {Duration interval = const Duration(seconds: 1)}) async {
    int index = 0;
    Timer.periodic(interval, (timer) {
      if (index < route.length) {
        double lat = route[index]['lat']!;
        double lon = route[index]['lon']!;
        print('User at: Lat: $lat, Lon: $lon');
        index++;
      } else {
        timer.cancel();
        print('Simulation finished.');
      }
    });
  }


}
