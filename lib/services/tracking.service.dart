import 'package:geolocator/geolocator.dart';

class TrackingService {
  final LocationSettings _locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 1000,
  );

  TrackingService();

  static init() async {

    var permission = await Geolocator.checkPermission();

    if (permission != LocationPermission.always) {
      permission = await Geolocator.requestPermission();
    }
  }

  static track(void Function(Position) handlePosition) async {
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
      var position = await Geolocator.getCurrentPosition();
      handlePosition(position);
    }
  }
}