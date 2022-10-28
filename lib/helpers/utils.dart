import 'package:latlong2/latlong.dart';

class MyUtils {
  static LatLng generateLatLng(String? lat, String? lng) {
    final latitude = double.tryParse(lat ?? '') ?? 0;
    final longitude = double.tryParse(lng ?? '') ?? 0;
    return LatLng(latitude, longitude);
  }
}
