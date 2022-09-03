
import 'package:geocoding/geocoding.dart';

class LeaPosition {
  final double longitude;
  final double latitude;
  final DateTime at;

  const LeaPosition({
    required this.longitude,
    required this.latitude,
    required this.at
  });

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map.putIfAbsent("longitude", () => longitude);
    map.putIfAbsent("latitude", () => latitude);
    map.putIfAbsent("at", () => at.toIso8601String());
    return map;
  }

  factory LeaPosition.fromJson(Map<String, dynamic> json) {
    return LeaPosition(
        longitude: json["longitude"] as double,
        latitude: json["latitude"] as double,
        at: DateTime.parse(json["at"] as String)
    );
  }

  Future<String> address() async {
    List<Placemark> places = await placemarkFromCoordinates(latitude, longitude);
    var place = places.first;
    return "${place.street} ${place.postalCode} ${place.locality} ${place.country}";
  }

  String date() {
    return "${format(at.day)}/${format(at.month)}/${at.year} à ${format(at.hour)}:${format(at.minute)}:${format(at.second)}";
  }

  String format(int text) {
    if (text.toString().length == 1) {
      return "0$text";
    } else {
      return text.toString();
    }
  }
}