import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geomessage/commonWidgets/cardMessage.dart';
import 'package:geomessage/services/databaseService.dart';
import 'package:geomessage/services/utils.dart';

import '../../commonWidgets/customAppBar.dart';
import '../../generated/l10n.dart';
import '../../model/message.dart';

class ActiveMessages extends StatelessWidget {
  const ActiveMessages({super.key});

  @override
  Widget build(BuildContext context) {
    DatabaseService db = DatabaseService();

    return Scaffold(
      appBar: CustomAppBar(title: capitalizeFirstLetter(S.of(context).activeMessage)),
      body: FutureBuilder<List<Message>>(
        future: db.getMessagesWithoutDate(),  // Appel asynchrone
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Affiche un indicateur de chargement pendant l'attente
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Gère les erreurs
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Affiche un message si aucun message n'est disponible
            return Center(child: Text('no message'));//S.of(context).noActiveMessages)); // Texte traduit
          } else {
            // Affiche la liste des messages récupérés
            List<Message> messages = snapshot.data!;
            return ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                Message message = messages[index];
                return CardMessage(message: message);
              },
            );
          }
        },
      ),
    );
  }
}
