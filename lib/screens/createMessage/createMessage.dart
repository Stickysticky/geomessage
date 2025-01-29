import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geomessage/screens/createMessage/messageInfoCreator.dart';
import 'package:geomessage/services/localisationService.dart';
import 'package:geomessage/services/utils.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart'; // Assurez-vous d'importer geolocator

import '../../commonWidgets/customAppBar.dart';
import '../../generated/l10n.dart';
import '../../model/message.dart';

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
  Message? _message;
  LatLng? _userLocation;
  LocalisationService _localisationService = LocalisationService();


  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  // Méthode asynchrone pour récupérer la position actuelle
  Future<void> _initLocation() async {
    LatLng position = await _localisationService.getCurrentLocation();

    // Mets à jour la carte avec la position récupérée
    setState(() {
      _userLocation = position;
      markers = [
        Marker(
          point: LatLng(position.latitude, position.longitude),
          child: Icon(
            Icons.person_pin_circle_rounded,
            color: Colors.red,
            size: 40,
          ),
        ),
      ];

      if(ModalRoute.of(context)?.settings.arguments != null){
        _message = ModalRoute.of(context)?.settings.arguments as Message;
        _initCenter = LatLng(_message!.latitude, _message!.longitude);
        _center = _initCenter;

        markers.add(
          Marker(
            point: LatLng(_center!.latitude, _center!.longitude),
            child: Icon(
              Icons.location_on,
              color: Colors.green,
              size: 40,
            ),
          ),
        );

      } else {
        _initCenter = LatLng(position.latitude, position.longitude);
      }


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

  void _updateVisibility(bool isVisible) {
    setState(() {
      mapHeightFraction = mapHeightFraction == 1.0 ? 0.3 : 1.0;
      _mapController.move(LatLng(_center!.latitude, _center!.longitude), 13.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    LatLng paris = LatLng(48.866667, 2.333333);
    markers.add(
        Marker(
          point: _userLocation ?? paris,
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
        SingleChildScrollView(
          child: Column(
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
                height: MediaQuery.of(context).size.height * (_center == null ? 0.8 : 0.9) * mapHeightFraction,
                child: Stack(
                  children: [
                    FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        initialCenter: _initCenter ?? paris,
                        onTap: (tapPosition, point) {
                          setState(() {
                            if(_message == null){
                              _message = Message(
                                latitude: point.latitude,
                                longitude: point.longitude,
                              );
                            } else {
                              _message!.latitude = point.latitude;
                              _message!.longitude = point.longitude;
                            }


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
                        Scalebar(),
                        _message != null ?
                          CircleLayer(
                            circles: [
                              CircleMarker(
                                point: LatLng(
                                  _message!.latitude,
                                  _message!.longitude,
                                ),
                                color: Colors.green.withOpacity(0.3),
                                borderStrokeWidth: 1,
                                borderColor: Colors.green,
                                useRadiusInMeter: true,
                                radius: _message!.radius.toDouble(),
                              ),
                            ],
                          ) : Container(),
                      ],
                    ),
                    mapHeightFraction == 1.0 ?
                    Positioned(
                      right: 5,
                      bottom: 20,
                      child: Column(
                        children: [
                          _center != null ?
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  mapHeightFraction = 0.3;
                                  _mapController.move(_center!, 20);
                                });
                              },
                              icon: const Icon(Icons.check),
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                              color: Colors.white,
                              iconSize: 40,
                            ),
                          ) : Container(),
                          ElevatedButton(
                            onPressed: _recenterMap,
                            child: const Icon(Icons.my_location),
                            style: ElevatedButton.styleFrom(
                              shape: CircleBorder(),
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.green,
                              padding: EdgeInsets.all(16),
                            ),
                          ),
                        ],
                      ),
                    ) : Container(),
                  ],
                ),
              ),
              Visibility(
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 16.0, 0, 0),
                    child: MessageInfoCreator(
                        message: _message,
                        isVisible: mapHeightFraction != 1.0,
                        onVisibilityChanged: _updateVisibility
                    )
                ),
                visible: mapHeightFraction != 1.0,

              )
            ],
          ),
        ),
      ),
    );
  }
}
