import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import '../../model/message.dart';
import '../../generated/l10n.dart';
import '../services/utils.dart';

class CardMessage extends StatelessWidget {
  final Message message;
  final VoidCallback onDelete;
  final VoidCallback? onRestore;

  const CardMessage({Key? key, required this.message, required this.onDelete, this.onRestore}) : super(key: key);

  Future<void> recenterMap(MapController mapController) async {
    mapController.moveAndRotate(
      LatLng(message.latitude, message.longitude),
      13,
      0.0,
    );
  }

  Future<void> _showRestoreConfirmationDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(capitalizeFirstLetter(S.of(context).confirmation)),
          content: Text(capitalizeFirstLetter(S.of(context).restoreMessageConfirmation)),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Ferme la boîte de dialogue
              },
              child: Text(capitalizeFirstLetter(S.of(context).cancel)),
            ),
            TextButton(
              onPressed: () {
                onRestore!();  // Appeler la fonction de suppression
                Navigator.of(context).pop(); // Ferme la boîte de dialogue
              },
              child: Text(capitalizeFirstLetter(S.of(context).restore)),
            ),
          ],
        );
      },
    );
  }

  // Fonction pour afficher la boîte de dialogue de confirmation
  Future<void> _showDeleteConfirmationDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(capitalizeFirstLetter(S.of(context).confirmation)),
          content: Text(capitalizeFirstLetter(S.of(context).deleteMessageConfirmation)),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Ferme la boîte de dialogue
              },
              child: Text(capitalizeFirstLetter(S.of(context).cancel)),
            ),
            TextButton(
              onPressed: () {
                onDelete();  // Appeler la fonction de suppression
                Navigator.of(context).pop(); // Ferme la boîte de dialogue
              },
              child: Text(capitalizeFirstLetter(S.of(context).delete)),
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
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16.0),
          title: Row(
            children: [
              Text(
                message.libelle ?? '',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Spacer(),
              message.date != null ?
                IconButton(
                  icon: Icon(Icons.restore, color: Colors.orange, size: 30),
                  onPressed: () => _showRestoreConfirmationDialog(context),
                )
                  :
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.orange, size: 30),
                  onPressed: () => Navigator.pushNamed(context, '/message-creation', arguments: message),
                ),
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
                        CircleLayer(
                          circles: [
                            CircleMarker(
                              point: LatLng(
                                message.latitude,
                                message.longitude,
                              ),
                              color: Colors.green.withOpacity(0.3),
                              borderStrokeWidth: 1,
                              borderColor: Colors.green,
                              useRadiusInMeter: true,
                              radius: message.radius.toDouble(),
                            ),
                          ],
                        ),
                      ],
                    ),
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
                '${capitalizeFirstLetter(S.of(context).receiver)} ${message.phoneNumber}',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              message.date != null ?
              Text(
                '${capitalizeFirstLetter(S.of(context).sendingDate)} ${DateFormat('HH:mm dd/MM/yyyy').format(message.date!)}',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ) : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
