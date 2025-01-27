import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../commonWidgets/customAppBar.dart';
import '../../generated/l10n.dart';

class CreateMessage extends StatefulWidget {
  const CreateMessage({super.key});

  @override
  State<CreateMessage> createState() => _CreateMessageState();
}

class _CreateMessageState extends State<CreateMessage> {
  List<Marker> markers = [];
  final MapController _mapController = MapController(); // Ajout du MapController
  LatLng _center = LatLng(48.866667, 2.333333); //Paris
  LatLng _initCenter = LatLng(48.866667, 2.333333);

  void _recenterMap() {
    _mapController.moveAndRotate(
      _initCenter,
      13, // Zoom initial
      0.0, // Rotation pour mettre le nord en haut
    );
  }

  @override
  Widget build(BuildContext context) {
    markers.add(
      Marker(
          point: _initCenter,
          child: Icon(
            Icons.person_pin_circle_rounded,
            color: Colors.red,
            size: 40,
          ),
      )
    );

    return Scaffold(
        appBar: CustomAppBar(title: S.of(context).title),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0),
        child: Column(
          children: [
            Text(
              S.of(context).infoMessagePoint,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.80,
              child: Stack(
                  children: [
                    FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        initialCenter: _center,
                        onTap: (tapPosition, point) {
                          // Lorsque l'utilisateur clique sur la carte, ajoutez un marqueur
                          setState(() {
                            _center = point;
                            markers = [
                              Marker(
                                point: point,
                                child: Icon(
                                  Icons.location_on,
                                  color: Colors.green,
                                  size: 40,
                                ),
                              ),
                            ];
                          });
                        },
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
                    Positioned(
                      bottom: 20, // Espace du bas
                      right: 5,  // Espace de la droite
                      child: ElevatedButton(
                        onPressed: () => _recenterMap(), // Appelle la fonction de recentrage
                        child: const Icon(Icons.my_location), // Icône de recentrage
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(), // Forme ronde comme le FloatingActionButton
                          backgroundColor: Colors.white, // Couleur d'arrière-plan (comme le backgroundColor de FloatingActionButton)
                          foregroundColor: Colors.green, // Couleur du premier plan (comme le foregroundColor de FloatingActionButton)
                          padding: EdgeInsets.all(16), // Donne un padding pour augmenter la taille du bouton
                        ),
                      ),
                    ),

                  ]
              ),
            ),
          ],
        ),
      )
    );
  }
}
