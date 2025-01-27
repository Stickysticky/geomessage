import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

String capitalizeFirstLetter(String input) {
  if (input.isEmpty) return input;
  return input[0].toUpperCase() + input.substring(1);
}

Future<LatLng> getCurrentLocation() async {
  // Vérifie si le service de localisation est activé
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  LatLng paris = LatLng(48.866667, 2.333333);
  if (!serviceEnabled) {
    // Si le service de localisation n'est pas activé, affiche un message ou demande à l'utilisateur de l'activer
    print("Le service de localisation est désactivé.");
    return paris;
  }

  // Vérifie les permissions d'accès à la localisation
  LocationPermission permission = await Geolocator.checkPermission();

  // Si la permission n'est pas accordée, demande à l'utilisateur d'accorder la permission
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
