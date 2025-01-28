import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../model/message.dart';

class CardMessage extends StatelessWidget {
  final Message message;  // Message à afficher dans la carte

  // Constructeur
  const CardMessage({Key? key, required this.message}) : super(key: key);

  // Fonction pour recentrer la carte sur la position du message
  Future<void> recenterMap(MapController mapController) async {
    mapController.moveAndRotate(
      LatLng(message.latitude, message.longitude),  // Utilise la position du message
      13, // Zoom initial
      0.0, // Rotation pour mettre le nord en haut
    );
  }

  @override
  Widget build(BuildContext context) {
    final MapController mapController = MapController();

    List<Marker> markers = [
      Marker(
        point: LatLng(message.latitude, message.longitude),
        child: Icon(
          Icons.location_on,
          color: Colors.green,
          size: 30,
        ),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.all(8.0), // Espacement autour des cartes
      child: Card(
        elevation: 5, // Ombre sous la carte
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Coins arrondis
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16.0), // Padding interne
          title: Text(
            message.libelle ?? '', // Affiche libelle si disponible
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),
              Container(
                height: 100,
                child: Stack(
                  children: [
                    FlutterMap(
                      mapController: mapController,
                      options: MapOptions(
                        initialCenter: LatLng(message.latitude, message.longitude),
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                          subdomains: ['a', 'b', 'c'],
                        ),
                        MarkerLayer(
                          markers: markers,
                        ),
                      ],
                    ),
                    // Le bouton pour recentrer la carte
                    Positioned(
                      bottom: 3,
                      right: 3,
                      child: ElevatedButton(
                        onPressed: () => recenterMap(mapController),
                        child: const Icon(Icons.my_location),
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.green,
                          padding: EdgeInsets.all(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              Text(
                message.message,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                '${message.phoneNumber}',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
