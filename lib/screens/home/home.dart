import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart'; // Import pour gérer les permissions
import 'package:geomessage/screens/home/menuCard.dart';
import 'package:geomessage/services/utils.dart';

import '../../commonWidgets/customAppBar.dart';
import '../../generated/l10n.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isGpsEnabled = false;

  @override
  void initState() {
    super.initState();
    _checkPermissions(); // Vérifie les permissions dès le démarrage
    _checkGpsStatus();
  }

  // Vérifie les permissions de SMS et GPS
  Future<void> _checkPermissions() async {
    // Vérification des permissions de localisation
    PermissionStatus locationStatus = await Permission.location.status;
    if (!locationStatus.isGranted) {
      await Permission.location.request();
    }

    // Vérification des permissions d'envoi de SMS
    PermissionStatus smsStatus = await Permission.sms.status;
    if (!smsStatus.isGranted) {
      await Permission.sms.request();
    }
  }

  // Vérifie si le GPS est activé
  Future<void> _checkGpsStatus() async {
    bool isEnabled = await Geolocator.isLocationServiceEnabled();
    setState(() {
      _isGpsEnabled = isEnabled; //! pour les tests
    });
    if (!_isGpsEnabled) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showGpsDialog();
      });
    }
  }

  // Affiche la boîte de dialogue
  void _showGpsDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(capitalizeFirstLetter(S.of(context).gpsDisabled)),
            content: Text(capitalizeFirstLetter(S.of(context).gpsDisabledInfo)),
            actions: [
              TextButton(
                child: Text(capitalizeFirstLetter(S.of(context).gpsActivation)),
                onPressed: () {
                  _openGpsSettings();
                },
              ),
            ],
          );
        }
    );
  }

  // Ouvre les paramètres pour activer le GPS
  Future<void> _openGpsSettings() async {
    if (!_isGpsEnabled) {
      await Geolocator.openLocationSettings();
    }
    //_checkGpsStatus(); // Vérifie à nouveau après ouverture des paramètres
    _isGpsEnabled = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: S.of(context).title),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 10),
            MenuCard(text: capitalizeFirstLetter(S.of(context).createMessage), iconData: Icons.send, route: '/message-creation'),
            MenuCard(text: capitalizeFirstLetter(S.of(context).activeMessage), iconData: Icons.message, route: '/active-messages'),
            MenuCard(text: capitalizeFirstLetter(S.of(context).sentMessages), iconData: Icons.message_outlined, route: '/sent-messages'),
          ]
      ),
    );
  }
}
