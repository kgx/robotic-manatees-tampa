import 'dart:async';
import 'dart:js_interop';
import 'dart:math';
import 'package:web/web.dart' as web;

class UserLocation {
  final double lat;
  final double lng;
  final String areaName;
  const UserLocation({required this.lat, required this.lng, required this.areaName});
}

// Known areas in the Tampa Bay region for reverse geocoding
const _knownAreas = [
  _Area('Downtown Tampa', 27.950, -82.458),
  _Area('Ybor City', 27.960, -82.438),
  _Area('South Tampa', 27.920, -82.490),
  _Area('Davis Islands', 27.930, -82.460),
  _Area('Westshore', 27.950, -82.520),
  _Area('Channelside', 27.940, -82.450),
  _Area('Seminole Heights', 27.990, -82.460),
  _Area('Hyde Park', 27.935, -82.475),
  _Area('Riverside Heights', 27.960, -82.470),
  _Area('Downtown St. Petersburg', 27.771, -82.640),
  _Area('St. Pete Pier District', 27.774, -82.631),
  _Area('Old Northeast St. Pete', 27.785, -82.625),
  _Area('Kenwood, St. Pete', 27.775, -82.665),
  _Area('Grand Central District, St. Pete', 27.765, -82.660),
  _Area('The Dali Museum Area', 27.766, -82.631),
  _Area('Gulfport', 27.748, -82.694),
  _Area('St. Pete Beach', 27.726, -82.737),
  _Area('Pass-a-Grille', 27.692, -82.738),
  _Area('Treasure Island', 27.770, -82.770),
  _Area('Madeira Beach', 27.792, -82.778),
  _Area('Redington Beach', 27.810, -82.778),
  _Area('Indian Rocks Beach', 27.850, -82.845),
  _Area('Clearwater Beach', 27.975, -82.827),
  _Area('Clearwater', 27.966, -82.800),
  _Area('Dunedin', 28.020, -82.772),
  _Area('Palm Harbor', 28.080, -82.764),
  _Area('Tarpon Springs', 28.146, -82.757),
  _Area('Safety Harbor', 27.990, -82.692),
  _Area('Oldsmar', 28.035, -82.665),
  _Area('Largo', 27.909, -82.787),
  _Area('Pinellas Park', 27.843, -82.699),
  _Area('Kenneth City', 27.815, -82.720),
  _Area('Bradenton', 27.499, -82.574),
  _Area('Bradenton Beach', 27.466, -82.695),
  _Area('Anna Maria Island', 27.531, -82.733),
  _Area('Palmetto', 27.521, -82.572),
  _Area('Sarasota', 27.336, -82.543),
  _Area('St. Armands Circle', 27.316, -82.579),
  _Area('Siesta Key', 27.268, -82.546),
  _Area('Lakewood Ranch', 27.402, -82.410),
  _Area('New Port Richey', 28.244, -82.719),
  _Area('Hudson', 28.365, -82.693),
  _Area('Wesley Chapel', 28.240, -82.327),
  _Area('Land O\' Lakes', 28.219, -82.457),
  _Area('Temple Terrace', 28.035, -82.389),
  _Area('Brandon', 27.938, -82.286),
  _Area('Riverview', 27.876, -82.327),
  _Area('Ruskin', 27.721, -82.432),
  _Area('Apollo Beach', 27.771, -82.408),
  _Area('Sun City Center', 27.718, -82.352),
  _Area('Fort De Soto', 27.622, -82.728),
  _Area('Honeymoon Island', 28.069, -82.830),
  _Area('Plant City', 28.014, -82.120),
];

class _Area {
  final String name;
  final double lat;
  final double lng;
  const _Area(this.name, this.lat, this.lng);
}

String _findNearestArea(double lat, double lng) {
  String nearest = 'Your Area';
  double minDist = double.infinity;

  for (final area in _knownAreas) {
    final dist = _haversine(lat, lng, area.lat, area.lng);
    if (dist < minDist) {
      minDist = dist;
      nearest = area.name;
    }
  }

  // If more than 50km away from any known area, use generic name
  if (minDist > 50) return 'Your Area';
  return nearest;
}

double _haversine(double lat1, double lng1, double lat2, double lng2) {
  const R = 6371.0; // Earth radius km
  final dLat = _toRad(lat2 - lat1);
  final dLng = _toRad(lng2 - lng1);
  final a = sin(dLat / 2) * sin(dLat / 2) +
      cos(_toRad(lat1)) * cos(_toRad(lat2)) * sin(dLng / 2) * sin(dLng / 2);
  return R * 2 * atan2(sqrt(a), sqrt(1 - a));
}

double _toRad(double deg) => deg * pi / 180;

Future<UserLocation?> getUserLocation() async {
  final completer = Completer<UserLocation?>();

  try {
    final geolocation = web.window.navigator.geolocation;

    geolocation.getCurrentPosition(
      ((web.GeolocationPosition position) {
        final coords = position.coords;
        final lat = coords.latitude;
        final lng = coords.longitude;
        final areaName = _findNearestArea(lat, lng);
        completer.complete(UserLocation(
          lat: lat,
          lng: lng,
          areaName: areaName,
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
