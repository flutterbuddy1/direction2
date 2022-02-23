import 'dart:convert';
import 'package:direction2/src/model/Directions.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class DirectionService {
  Future<Directions> getDirections({
    required LatLng origin,
    required LatLng destination,
    required String googleMapApiKey,
  }) async {
    String _baseUrl =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=${googleMapApiKey}";
    var request = http.Request('GET', Uri.parse(_baseUrl));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final res = await response.stream.bytesToString();
      return Directions.fromMap(jsonDecode(res));
    }
    return null as Directions;
  }
}
