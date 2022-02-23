import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class Directions {
  final LatLngBounds? bounds;
  final List<PointLatLng>? polylinePoints;
  final String? totalDistance;
  final String? totalDuration;
  final LatLng? startPosition;
  final LatLng? endPosition;
  final LatLng? someDistancePosition;
  final bool? error;
  final String? errorMsg;
  final double? distanceVal;
  final String? startAddress;
  final String? endAddress;

  const Directions(
      {this.bounds,
      this.polylinePoints,
      this.totalDistance,
      this.totalDuration,
      this.startPosition,
      this.endPosition,
      this.someDistancePosition,
      this.error,
      this.errorMsg,
      this.startAddress,
      this.endAddress,
      this.distanceVal});
  factory Directions.fromMap(Map<String, dynamic> map) {
    var data;
    if ((map['routes'] as List).isEmpty) {
      print("Error Empty List");
      return Directions(error: true, errorMsg: "No Route Found");
    } else {
      data = Map<String, dynamic>.from(map['routes'][0]);

      final northeast = data['bounds']['northeast'];
      final southwest = data['bounds']['southwest'];

      final bounds = LatLngBounds(
          southwest: LatLng(southwest['lat'], southwest['lng']),
          northeast: LatLng(northeast['lat'], northeast['lng']));

      String distance = "";
      String duration = "";
      LatLng starts = LatLng(0, 0);
      LatLng ends = LatLng(0, 0);
      LatLng somePos = LatLng(0, 0);
      double disVal = 0.0;
      String startAdd = "";
      String endAdd = "";
      if ((data['legs'] as List).isNotEmpty) {
        final legs = data['legs'][0];
        distance = legs['distance']['text'];
        duration = legs['duration']['text'];
        startAdd = legs['start_address'];
        endAdd = legs['end_address'];
        disVal = legs['distance']['value'] / 1000;
        ends = LatLng(legs['end_location']['lat'], legs['end_location']['lng']);
        starts = LatLng(
            legs['start_location']['lat'], legs['start_location']['lng']);

        final steps = legs['steps'][0];
        somePos =
            LatLng(steps['end_location']['lat'], steps['end_location']['lng']);
      }

      return Directions(
          error: false,
          errorMsg: "",
          bounds: bounds,
          startAddress: startAdd,
          endAddress: endAdd,
          polylinePoints: PolylinePoints()
              .decodePolyline(data['overview_polyline']['points']),
          totalDistance: distance,
          totalDuration: duration,
          startPosition: starts,
          endPosition: ends,
          distanceVal: disVal,
          someDistancePosition: somePos);
    }
  }
}
