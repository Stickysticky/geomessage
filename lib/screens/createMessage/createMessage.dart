import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geomessage/services/utils.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart'; // Assurez-vous d'importer geolocator

import '../../commonWidgets/customAppBar.dart';
import '../../generated/l10n.dart';

class CreateMessage extends StatefulWidget {
  const CreateMessage({super.key});

  @override
  State<CreateMessage> createState() => _CreateMessageState();
}

class _CreateMessageState extends State<CreateMessage> {
  List<Marker> markers = [];
  final MapController _mapController = MapController();
  LatLng? _center;
  LatLng? _initCenter;
  double mapHeightFraction = 1.0;

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  // Méthode asynchrone pour récupérer la position actuelle
  Future<void> _initLocation() async {
    LatLng position = await getCurrentLocation();

    // Mets à jour la carte avec la position récupérée
    setState(() {
      _initCenter = LatLng(position.latitude, position.longitude);
      markers = [
        Marker(
          point: _initCenter!,
          child: Icon(
            Icons.person_pin_circle_rounded,
            color: Colors.red,
            size: 40,
          ),
        ),
      ];
    });

    _mapController.moveAndRotate(
      _initCenter!,  // Utilise _initCenter mis à jour avec la position actuelle
      13, // Zoom initial
      0.0, // Rotation pour mettre le nord en haut
    );
  }

  Future<void> _recenterMap() async {
    _mapController.moveAndRotate(
      _initCenter!,  // Utilise _initCenter mis à jour avec la position actuelle
      13, // Zoom initial
      0.0, // Rotation pour mettre le nord en haut
    );
  }

  @override
  Widget build(BuildContext context) {
    LatLng paris = LatLng(48.866667, 2.333333);
    markers.add(
        Marker(
          point: _initCenter ?? paris,
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
        child:
        Column(
          children: [
            _center == null ?
              Text(
                S.of(context).infoMessagePoint,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ) : Container(),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300), // Animation fluide
              height: MediaQuery.of(context).size.height * 0.8 * mapHeightFraction,
              child: Stack(
                children: [
                  FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: _initCenter ?? paris,
                      onTap: (tapPosition, point) {
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

                          setState(() {
                            mapHeightFraction = 0.3;
                            _mapController.move(point, 20);
                          });
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
                  mapHeightFraction == 1.0 ?
                    Positioned(
                      bottom: 20,
                      right: 5,
                      child: ElevatedButton(
                        onPressed: _recenterMap,
                        child: const Icon(Icons.my_location),
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.green,
                          padding: EdgeInsets.all(16),
                        ),
                      ),
                    ) : Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
