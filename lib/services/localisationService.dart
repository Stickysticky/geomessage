
import 'package:geolocator/geolocator.dart';
import 'package:geomessage/model/message.dart';
import 'package:latlong2/latlong.dart';

class LocalisationService {

  Future<LatLng> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    LatLng paris = LatLng(48.866667, 2.333333);
    if (!serviceEnabled) {
       print("Le service de localisation est désactivé.");
      return paris;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("Permission de localisation refusée");
        return paris;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Si la permission est définitivement refusée, vous pouvez envoyer l'utilisateur aux paramètres pour modifier les permissions
      print("Permission de localisation refusée définitivement");
      return paris;
    }

    // Récupère la position actuelle
    Position position = await Geolocator.getCurrentPosition();

    return LatLng(position.latitude, position.longitude);
  }

  Future<bool> checkGps() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  Future<bool> checkCurrentLocationInRadius(Message message) async {
    bool isGpsEnabled = await checkGps();
    if (!isGpsEnabled) {
      print("GPS désactivé");
      return false;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    double distance = Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      message.latitude,
      message.longitude,
    );

    print("Distance actuelle : $distance mètres, Rayon autorisé : ${message.radius} mètres");

    return distance <= message.radius;
  }


}