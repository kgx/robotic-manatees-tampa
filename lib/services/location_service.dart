import 'dart:async';
// ignore: avoid_web_libraries_in_flutter
import 'dart:js_interop';
import 'package:web/web.dart' as web;

class UserLocation {
  final double lat;
  final double lng;
  final String areaName;
  const UserLocation({required this.lat, required this.lng, required this.areaName});
}

Future<UserLocation?> getUserLocation() async {
  final completer = Completer<UserLocation?>();

  try {
    final geolocation = web.window.navigator.geolocation;

    geolocation.getCurrentPosition(
      ((web.GeolocationPosition position) {
        final coords = position.coords;
        completer.complete(UserLocation(
          lat: coords.latitude,
          lng: coords.longitude,
          areaName: 'Your Area',
        ));
      }).toJS,
      ((web.GeolocationPositionError error) {
        completer.complete(null);
      }).toJS,
    );
  } catch (e) {
    completer.complete(null);
  }

  return completer.future.timeout(
    const Duration(seconds: 10),
    onTimeout: () => null,
  );
}
