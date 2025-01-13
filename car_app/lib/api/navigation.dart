import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class NavigationService {
  static const String _baseUrl = 'http://81.172.187.98:5000';

  Future<List<LatLng>> getRoute(LatLng start, LatLng end) async {
    final url = '$_baseUrl/route/v1/car/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?overview=full&geometries=geojson';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> coordinates = data['routes'][0]['geometry']['coordinates'];

      // Convert coordinates to LatLng
      return coordinates.map((coord) => LatLng(coord[1], coord[0])).toList();
    } else {
      throw Exception('Failed to fetch route data: ${response.statusCode}');
    }
  }


  Future<String> getAddress(LatLng position) async {
    final url = 'https://nominatim.openstreetmap.org/reverse?format=json&lat=${position.latitude}&lon=${position.longitude}&zoom=18&addressdetails=1';
    final response = await http.get(
      Uri.parse(url),
      headers: {'User-Agent': 'NavigationApp/1.0'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['display_name'];
    } else {
      throw Exception('Failed to get address');
    }
  }
}