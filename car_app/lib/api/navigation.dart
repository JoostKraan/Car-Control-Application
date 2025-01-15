import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';

class NavigationService {
  static const String _baseUrl = 'http://81.172.187.98:5000';

  Future<List<LatLng>> getRoute(LatLng start, LatLng end) async {
    final url = '$_baseUrl/route/v1/car/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?overview=full&steps=true&geometries=geojson';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> coordinates = data['routes'][0]['geometry']['coordinates'];

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

  // Added navigation-related functions from MapScreen
  Stream<Position> getPositionStream() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // Update every 10 meters
      ),
    );
  }
  Future<Position> getCurrentLocation() async {
    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      rethrow;
    }
  }
  Future<String> reverseGeocode(LatLng location) async {
    final url =
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=${location.latitude}&lon=${location.longitude}&addressdetails=1';
    final response = await http.get(
      Uri.parse(url),
      headers: {'User-Agent': 'NavigationApp/1.0'},
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      if (data.containsKey('address')) {
        final address = data['address'];
        final String street = address['road'] ?? '';
        final String city = address['city'] ?? address['town'] ?? address['village'] ?? '';
        final String state = address['state'] ?? '';
        final String country = address['country'] ?? '';
        return '$street, $city, $state';
      } else {
        throw Exception('Address not found');
      }
    } else {
      throw Exception('Failed to fetch address');
    }
  }
}