import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:car_app/location_service.dart';
import 'navigation.dart';

class NavigationStep {
  final String type;
  final String modifier;
  final double distance;
  final LatLng location;
  final String streetName;
  final int? roundaboutExit;

  NavigationStep({
    required this.type,
    required this.modifier,
    required this.distance,
    required this.location,
    required this.streetName,
    this.roundaboutExit,
  });
}

class TurnByTurnService {
  static List<NavigationStep> getTurnInstructions() {
    if (NavigationService.cachedRouteData == null) {
      throw Exception("No route data available. Call getRoute() first.");
    }
    List<NavigationStep> stepsList = [];
    final List<dynamic> legs = NavigationService.cachedRouteData!['routes'][0]['legs'];

    for (var leg in legs) {
      final List<dynamic> steps = leg['steps'];

      for (var step in steps) {
        stepsList.add(NavigationStep(
          type: step['maneuver']['type'] ?? 'unknown',
          modifier: step['maneuver']['modifier'] ?? 'straight',
          distance: step['distance'].toDouble(),
          location: LatLng(step['maneuver']['location'][1], step['maneuver']['location'][0]),
          streetName: step['name'].isNotEmpty ? step['name'] : 'Unnamed road',
          roundaboutExit: step['maneuver']['exit'],

        ));
      }
    }
    return stepsList;
  }

  static Future<void> startTurnByTurnNavigation() async {

    LocationService locationService = LocationService();
    print('Starting turn-by-turn navigation');

    // Ensure location services are enabled and permissions are granted
    try {
      await locationService.determinePosition();
    } catch (e) {
      print('Error: $e');
      return;
    }

    // Get the initial location (current position) from LocationService
    LatLng currentLatLng;

    if (locationService.currentLocation != null) {
      // If current location is already loaded, use that
      currentLatLng = locationService.currentLocation!;
      print('Using stored current location: $currentLatLng');
    } else {
      // Else, fetch the current location using getCurrentLocation method
      Position currentPosition = await locationService.getCurrentLocation();
      currentLatLng = LatLng(currentPosition.latitude, currentPosition.longitude);
      print('Fetched current location: $currentLatLng');
    }

    // Get the turn-by-turn instructions
    List<NavigationStep> steps = getTurnInstructions();

    if (steps.isEmpty) {
      print('Steps are empty');
      return;
    }

    // For the first step, calculate distance to the next step
    NavigationStep nextStep = steps.first;
    double distanceToNextStep = Geolocator.distanceBetween(
      currentLatLng.latitude,
      currentLatLng.longitude,
      nextStep.location.latitude,
      nextStep.location.longitude,
    );

    // Print current position and distance to next turn
    print("Current Position: ${currentLatLng.latitude}, ${currentLatLng.longitude}");
    print("Distance to next step: $distanceToNextStep meters");

    // If the user is near the next turn, move to the next step
    if (distanceToNextStep < 20) { // If the user is near the next turn
      print("Turn ${nextStep.modifier} in ${nextStep.streetName}");
      steps.removeAt(0); // Remove the first step to move to the next one
    }
  }


}