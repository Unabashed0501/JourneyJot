import 'package:latlong2/latlong.dart';

class CalculateDistance {
  static double calculateDistance(
      LatLng currentPosition, LatLng stationPosition) {
    // ignore: unused_local_variable
    const double Radius = 6371;

    double distance = const Distance()
        .as(LengthUnit.Kilometer, currentPosition, stationPosition);
        
    return distance;
  }
}
