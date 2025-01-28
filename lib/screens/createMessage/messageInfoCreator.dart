import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geomessage/services/databaseService.dart';
import 'package:geomessage/services/utils.dart';
import 'package:latlong2/latlong.dart';

import '../../generated/l10n.dart';
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
  final databaseService = DatabaseService();
  late bool _isVisible;
  String? _libelle;
  String _message = '';
  String _phoneNumber = '';
  double _radius = 30.0;

  @override
  void initState() {
    super.initState();
    _isVisible = widget._isVisible; // Initialize from parent
  }


  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); // Cette ligne appelle les fonctions onSaved des champs
      setState(() {
        if (_libelle != null && _libelle!.isNotEmpty) {
          widget._message!.libelle = _libelle; // Assurez-vous de l'assignation ici
        }

        widget._message!.message = _message;
        widget._message!.phoneNumber = _phoneNumber;
        widget._message!.radius = _radius;
      });

      databaseService.insertMessage(widget._message!);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(capitalizeFirstLetter(S.of(context).messageCreated))),
      );
      Navigator.pushNamed(context, '/home');
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
                labelText: capitalizeFirstLetter(S.of(context).libelle),
                border: OutlineInputBorder(),
              ),
              onSaved: (value) => _libelle = value,
            ),
            const SizedBox(height: 16),

            // Champ Message
            TextFormField(
              initialValue: _message,
              decoration: InputDecoration(
                labelText: capitalizeFirstLetter(S.of(context).message),
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
              validator: (value) => (value == null || value.isEmpty) ? capitalizeFirstLetter(S.of(context).messageRequired) : null,
              onSaved: (value) => _message = value!,
            ),
            const SizedBox(height: 16),

            // Champ Numéro de téléphone
            TextFormField(
              initialValue: _phoneNumber,
              decoration: InputDecoration(
                labelText: capitalizeFirstLetter(S.of(context).phoneNumber),
                border: OutlineInputBorder(),
              ),
              validator: (value) => (value == null || value.isEmpty) ? capitalizeFirstLetter(S.of(context).phoneNumberRequired) : null,
              onSaved: (value) => _phoneNumber = value!,
            ),
            const SizedBox(height: 16),

            // Champ Rayon
            TextFormField(
              initialValue: _radius.toString(),
              decoration: InputDecoration(
                labelText: capitalizeFirstLetter(S.of(context).rayon),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) return capitalizeFirstLetter(S.of(context).radiusRequired);
                final parsed = double.tryParse(value);
                if (parsed == null || parsed <= 0) return capitalizeFirstLetter(S.of(context).validRadius);
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
                  child: Text(capitalizeFirstLetter(S.of(context).validate)),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _toggleVisibility,
                  child: Text(capitalizeFirstLetter(S.of(context).cancel)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
