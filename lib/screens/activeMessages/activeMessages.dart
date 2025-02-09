import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geomessage/commonWidgets/cardMessage.dart';
import 'package:geomessage/services/databaseService.dart';
import 'package:geomessage/services/utils.dart';

import '../../commonWidgets/customAppBar.dart';
import '../../generated/l10n.dart';
import '../../model/message.dart';
import '../../services/messageService.dart';

class ActiveMessages extends StatefulWidget {
  const ActiveMessages({super.key});

  @override
  State<ActiveMessages> createState() => _ActiveMessagesState();
}

class _ActiveMessagesState extends State<ActiveMessages> {
  late Future<List<Message>> _messagesFuture;  // Déclarez la variable Future

  @override
  void initState() {
    super.initState();
    _messagesFuture = DatabaseService().getMessagesWithoutDate(); // Initialisez avec la fonction asynchrone
  }

  // Fonction de suppression d'un message
  Future<void> _deleteMessage(Message message) async {
    DatabaseService db = DatabaseService();
    MessageService msService = MessageService();

    await db.deleteMessage(message.id!);

    // Rafraîchissez la liste des messages après suppression
    setState(() {
      _messagesFuture = db.getMessagesWithoutDate();  // Recharge la liste après suppression
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(capitalizeFirstLetter(S.of(context).deletedMessage))),
    );

    final messages = await db.getMessagesWithoutDate();
    if(messages.isEmpty){
      msService.stopForeGroundProcess();
    }
    //MessageService.stopBackgroundProcess();


  }

  @override
  Widget build(BuildContext context) {
    DatabaseService db = DatabaseService();

    return Scaffold(
      appBar: CustomAppBar(title: capitalizeFirstLetter(S.of(context).activeMessage)),
      body: FutureBuilder<List<Message>>(
        future: _messagesFuture,  // Utilisez la future mise à jour
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Affiche un indicateur de chargement pendant l'attente
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Gère les erreurs
            return Center(child: Text('${capitalizeFirstLetter(S.of(context).error)}: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Affiche un message si aucun message n'est disponible
            return Center(child: Text(capitalizeFirstLetter(S.of(context).noActiveMessages)));
          } else {
            // Affiche la liste des messages récupérés
            List<Message> messages = snapshot.data!;
            return ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                Message message = messages[index];
                return CardMessage(
                  message: message,
                  onDelete: () => _deleteMessage(message), // Passer la fonction de suppression
                );
              },
            );
          }
        },
      ),
    );
  }
}
