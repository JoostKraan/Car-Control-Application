// import 'package:latlong2/latlong.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:car_app/location_service.dart';
// import '../Depreciated/navigation.dart'; // Contains NavigationService with reverseGeocode
//
// class NavigationStep {
//   final String type;
//   final String modifier;
//   final double distance;
//   final LatLng location;
//   final String streetName;
//   final int? roundaboutExit;
//
//   NavigationStep({
//     required this.type,
//     required this.modifier,
//     required this.distance,
//     required this.location,
//     required this.streetName,
//     this.roundaboutExit,
//   });
// }
//
// class TurnByTurnService {
//   /// Returns a list of navigation steps parsed from the cached route data.
//   static List<NavigationStep> getTurnInstructions() {
//     if (NavigationService.cachedRouteData == null) {
//       throw Exception("No route data available. Call getRoute() first.");
//     }
//     List<NavigationStep> stepsList = [];
//     final List<dynamic> legs = NavigationService.cachedRouteData!['routes'][0]['legs'];
//
//     for (var leg in legs) {
//       final List<dynamic> steps = leg['steps'];
//
//       for (var step in steps) {
//         stepsList.add(NavigationStep(
//           type: step['maneuver']['type'] ?? 'unknown',
//           modifier: step['maneuver']['modifier'] ?? 'straight',
//           distance: (step['distance'] as num).toDouble(),
//           location: LatLng(
//               step['maneuver']['location'][1],
//               step['maneuver']['location'][0]
//           ),
//           streetName: step['name'].isNotEmpty ? step['name'] : 'Unnamed road',
//           roundaboutExit: step['maneuver']['exit'],
//         ));
//       }
//     }
//     return stepsList;
//   }
//
//   /// Returns a Map containing the current street, the next turn's street name,
//   /// the distance to the next turn, and the type of turn.
//   static Future<Map<String, dynamic>?> getNavigationDetails() async {
//     // Get current location using LocationService
//     LocationService locationService = LocationService();
//     try {
//       await locationService.determinePosition();
//     } catch (e) {
//       print('Error determining position: $e');
//       return null;
//     }
//
//     LatLng currentLatLng;
//     if (locationService.currentLocation != null) {
//       currentLatLng = locationService.currentLocation!;
//     } else {
//       Position pos = await locationService.getCurrentLocation();
//       currentLatLng = LatLng(pos.latitude, pos.longitude);
//     }
//
//     // Get the list of navigation steps
//     List<NavigationStep> steps = getTurnInstructions();
//     if (steps.isEmpty) return null;
//
//     // Get the next step
//     NavigationStep nextStep = steps.first;
//
//     // Calculate distance to the next turn
//     double distanceToNextTurn = Geolocator.distanceBetween(
//       currentLatLng.latitude,
//       currentLatLng.longitude,
//       nextStep.location.latitude,
//       nextStep.location.longitude,
//     );
//
//     // Use your existing reverseGeocode method from NavigationService to get current street
//     String currentStreet = await NavigationService.reverseGeocode(currentLatLng);
//
//     return {
//       'currentStreet': currentStreet,
//       'nextTurn': nextStep.streetName,
//       'distanceToNextTurn': distanceToNextTurn,
//       'turnType': nextStep.modifier,
//     };
//   }
//
//   /// Existing navigation method that uses the above helper method
//   static Future<void> startTurnByTurnNavigation() async {
//     print('Starting turn-by-turn navigation');
//
//     var navDetails = await getNavigationDetails();
//     if (navDetails == null) {
//       print('Navigation details not available.');
//       return;
//     }
//
//     print("Current Street: ${navDetails['currentStreet']}");
//     print("Next Turn (Street): ${navDetails['nextTurn']}");
//     print("Distance to Next Turn: ${navDetails['distanceToNextTurn']} meters");
//     print("Turn Type: ${navDetails['turnType']}");
//   }
// }
