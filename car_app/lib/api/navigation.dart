import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:car_app/trip_history.dart';
class NavigationService {

  static const String _baseUrl = 'http://81.172.187.98:5000';
  TripHistory triphistory = TripHistory();
  Future<List<LatLng>> getRoute(LatLng start, LatLng end) async {
    final url = '$_baseUrl/route/v1/car/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?overview=full&steps=true&geometries=geojson&annotations=true';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final double distance = data['routes'][0]['distance'];
      final double timeTillArrival = data['routes'][0]['duration'];
      final List<dynamic> coordinates = data['routes'][0]['geometry']['coordinates'];
      final List<dynamic> legs = data['routes'][0]['legs'];
      for (var leg in legs) {
        final List<dynamic> steps = leg['steps'];
        String previousRoad = '';

        for (var i = 0; i < steps.length; i++) {
          final step = steps[i];
          final String maneuverType = step['maneuver']['type'] ?? 'unknown maneuver';
          final String modifier = step['maneuver']['modifier'] ?? 'straight';
          String streetName = step['name'] ?? '';
          final int? roundaboutExit = step['maneuver']['exit'];
          if (streetName.isEmpty && maneuverType != 'arrive' && maneuverType != 'depart') {
            streetName = 'the road';
          }
          final instruction = _generateInstruction(maneuverType, modifier, streetName, roundaboutExit?.toString() ?? '', previousRoad);
          print(instruction);

          if (streetName.isNotEmpty && streetName != 'the road') {
            previousRoad = streetName;
          }
        }
      }

      print('Total Distance : ${(distance / 1000).toDouble().toStringAsFixed(1)} km ');
      distance.toDouble();
      final Duration duration = Duration(seconds: timeTillArrival.toInt());

      String formattedDuration;
      if (duration.inHours > 0) {
        formattedDuration = '${duration.inHours.toDouble()} hours ${(duration.inMinutes.remainder(60)).toDouble()} minutes';
      } else {
        formattedDuration = '${duration.inMinutes.toDouble()} minutes';
      }

      print('Duration: ${(formattedDuration)}');
      final String destination = await reverseGeocode(end);
      print(destination);
      return coordinates.map((coord) => LatLng(coord[1], coord[0])).toList();
    } else {
      throw Exception('Failed to fetch route data: ${response.statusCode}');
    }
  }

  String _generateInstruction(String type, String modifier, String streetName, String roundaboutExit, String previousRoad) {
    final String direction = _getDirectionPhrase(modifier);

    switch (type) {
      case 'turn':
        return 'Turn $direction onto $streetName';
      case 'depart':
        return 'Start your journey on ${streetName.isEmpty ? 'the current road' : streetName}';
      case 'arrive':
        return 'You have arrived at your destination on $streetName';
      case 'roundabout':
        if (roundaboutExit.isNotEmpty) {
          final int? exitNumber = int.tryParse(roundaboutExit);
          if (exitNumber != null) {
            final String ordinalExit = _convertToOrdinal(exitNumber);
            return 'At the roundabout, take the $ordinalExit exit onto $streetName';
          }
        }
        return 'Exit the roundabout onto $streetName';
      case 'merge':
        if (previousRoad.isNotEmpty) {
          return 'Merge $direction from $previousRoad onto the highway';
        }
        return 'Merge $direction onto the highway';
      case 'continue':
        if (streetName == 'the road') {
          return 'Continue $direction';
        }
        return 'Continue $direction onto $streetName';
      default:
        if (modifier == 'straight') {
          return 'Continue straight ahead';
        } else if (streetName == 'the road') {
          return 'Keep $direction';
        }
        return 'Keep $direction onto $streetName';
    }
  }

  String _getDirectionPhrase(String modifier) {
    switch (modifier) {
      case 'slight right':
        return 'slightly right';
      case 'slight left':
        return 'slightly left';
      case 'sharp right':
        return 'sharply right';
      case 'sharp left':
        return 'sharply left';
      default:
        return modifier;
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
  String _convertToOrdinal(int number) {
    if (number >= 11 && number <= 13) {
      return '${number}th';
    }
    switch (number % 10) {
      case 1:
        return '${number}st';
      case 2:
        return '${number}nd';
      case 3:
        return '${number}rd';
      default:
        return '${number}th';
    }
  }
}