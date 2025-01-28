import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../model/message.dart';
import '../../services/databaseService.dart';

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

  // Fonction pour supprimer le message de la base de données
  Future<void> _deleteMessage(BuildContext context) async {
    DatabaseService db = DatabaseService();
    await db.deleteMessage(message.id!);  // Supposons que deleteMessage() supprime le message de la DB
    Navigator.of(context).pop();  // Ferme le dialogue
  }

  // Fonction pour afficher la boîte de dialogue de confirmation
  Future<void> _showDeleteConfirmationDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Êtes-vous sûr de vouloir supprimer ce message ?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Ferme la boîte de dialogue
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () => _deleteMessage(context),
              child: Text('Supprimer'),
            ),
          ],
        );
      },
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
          title: Row(
            children: [
              Text(
                message.libelle ?? '', // Affiche libelle si disponible
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Spacer(),
              IconButton(
                icon: Icon(Icons.delete_forever, color: Colors.red, size: 30),
                onPressed: () => _showDeleteConfirmationDialog(context),
              ),
            ],
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
                    // Le bouton poubelle pour supprimer le message (en haut à droite)
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
