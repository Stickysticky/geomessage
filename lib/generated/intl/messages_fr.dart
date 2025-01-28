// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a fr locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'fr';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "activeMessage": MessageLookupByLibrary.simpleMessage("Messages actifs"),
    "cancel": MessageLookupByLibrary.simpleMessage("Annuler"),
    "confirmation": MessageLookupByLibrary.simpleMessage("confirmation"),
    "createMessage": MessageLookupByLibrary.simpleMessage(
      "Création d\'un message",
    ),
    "delete": MessageLookupByLibrary.simpleMessage("supprimer"),
    "deleteMessageConfirmation": MessageLookupByLibrary.simpleMessage(
      "Êtes-vous sûr de vouloir supprimer ce message ?",
    ),
    "deletedMessage": MessageLookupByLibrary.simpleMessage(
      "Le message a été supprimé",
    ),
    "error": MessageLookupByLibrary.simpleMessage("Erreur"),
    "gpsActivation": MessageLookupByLibrary.simpleMessage("Activer le GPS"),
    "gpsDisabled": MessageLookupByLibrary.simpleMessage("Gps désactivé"),
    "gpsDisabledInfo": MessageLookupByLibrary.simpleMessage(
      "Pour bénéficier de toutes les fonctionnalités de l\'application, veuillez activer le GPS",
    ),
    "infoMessagePoint": MessageLookupByLibrary.simpleMessage(
      "Veuillez ajouter la localisation pour l\'envoie du message",
    ),
    "libelle": MessageLookupByLibrary.simpleMessage("Libellé"),
    "message": MessageLookupByLibrary.simpleMessage("message"),
    "messageCreated": MessageLookupByLibrary.simpleMessage(
      "Le message a été créé",
    ),
    "messageRequired": MessageLookupByLibrary.simpleMessage(
      "The message is required",
    ),
    "noActiveMessages": MessageLookupByLibrary.simpleMessage(
      "Il n\'y a aucun message actif.",
    ),
    "phoneNumber": MessageLookupByLibrary.simpleMessage("numéro de téléphone"),
    "phoneNumberRequired": MessageLookupByLibrary.simpleMessage(
      "Numéro de téléphone requis.",
    ),
    "radiusRequired": MessageLookupByLibrary.simpleMessage(
      "Le rayon est requis.",
    ),
    "rayon": MessageLookupByLibrary.simpleMessage("radius"),
    "sentMessages": MessageLookupByLibrary.simpleMessage("Messages envoyés"),
    "title": MessageLookupByLibrary.simpleMessage("GeoMessage"),
    "validRadius": MessageLookupByLibrary.simpleMessage(
      "Veuillez entrer un rayon valide.",
    ),
    "validate": MessageLookupByLibrary.simpleMessage("Valider"),
  };
}
