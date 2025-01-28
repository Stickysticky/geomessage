import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../../model/message.dart';

class MessageInfoCreator extends StatefulWidget {
  Message? _message;
  final bool _isVisible;
  final ValueChanged<bool> onVisibilityChanged;

  MessageInfoCreator({
    Key? key,
    required Message? message,
    required bool isVisible,
    required this.onVisibilityChanged,
  })  :
        _message = message,
        _isVisible = isVisible,
        super(key: key);

  @override
  State<MessageInfoCreator> createState() => _MessageInfoCreatorState();
}

class _MessageInfoCreatorState extends State<MessageInfoCreator> {
  final _formKey = GlobalKey<FormState>();
  late bool _isVisible;
  String? _libelle;
  String _message = '';
  String _phoneNumber = '';
  double _radius = 30.0;

  @override
  void initState() {
    super.initState();
    /*
    _libelle = widget._message!.libelle;
    _message = widget._message!.message;
    _latitude = widget._message!.latitude;
    _longitude = widget._message!.longitude;
    _phoneNumber = widget._message!.phoneNumber;
    _radius = widget._message!.radius;*/
    _isVisible = widget._isVisible; // Initialize from parent
  }


  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      print(widget._message);
      // Création de l'objet Message à partir des données du formulaire
      /*final message = Message(
        libelle: _libelleController.text.isNotEmpty ? _libelleController.text : null,
        message: _messageController.text,
        latitude: double.parse(_latitudeController.text),
        longitude: double.parse(_longitudeController.text),
        phoneNumber: _phoneNumberController.text.isNotEmpty ? _phoneNumberController.text : null,
        radius: double.tryParse(_radiusController.text) ?? 10.0,
      );*/

      //widget.onSubmit(message); // Passe l'objet Message au callback
    }
  }


  void _toggleVisibility() {
    setState(() {
      _isVisible = !_isVisible;
    });
    widget.onVisibilityChanged(_isVisible); // Notify parent
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: _isVisible,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Champ Libellé
            TextFormField(
              initialValue: _libelle ?? '',
              decoration: InputDecoration(
                labelText: 'Libellé',
                border: OutlineInputBorder(),
              ),
              onSaved: (value) => _libelle = value,
            ),
            const SizedBox(height: 16),

            // Champ Message
            TextFormField(
              initialValue: _message,
              decoration: InputDecoration(
                labelText: 'Message',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
              validator: (value) => (value == null || value.isEmpty) ? 'Le message est requis.' : null,
              onSaved: (value) => _message = value!,
            ),
            const SizedBox(height: 16),

            // Champ Numéro de téléphone
            TextFormField(
              initialValue: _phoneNumber,
              decoration: InputDecoration(
                labelText: 'Numéro de téléphone',
                border: OutlineInputBorder(),
              ),
              validator: (value) => (value == null || value.isEmpty) ? 'Numéro de téléphone requis.' : null,
              onSaved: (value) => _phoneNumber = value!,
            ),
            const SizedBox(height: 16),

            // Champ Rayon
            TextFormField(
              initialValue: _radius.toString(),
              decoration: InputDecoration(
                labelText: 'Rayon',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Le rayon est requis.';
                final parsed = double.tryParse(value);
                if (parsed == null || parsed <= 0) return 'Veuillez entrer un rayon valide.';
                return null;
              },
              onSaved: (value) => _radius = double.parse(value!),
            ),
            const SizedBox(height: 16),

            // Boutons d'action
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Valider'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _toggleVisibility,
                  child: const Text('Annuler'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
